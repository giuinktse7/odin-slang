package slang_tests

import "core:slice"
import "core:testing"

import sp "../slang"

VALID_COMPUTE_SOURCE :: #load("fixtures/valid_compute.slang", string)
INVALID_COMPUTE_SOURCE :: #load("fixtures/invalid_compute.slang", string)

release_diagnostics :: proc(diagnostics: ^^sp.IBlob) {
	if diagnostics^ != nil {
		diagnostics^->release()
		diagnostics^ = nil
	}
}

expect_no_compile_diagnostics :: proc(t: ^testing.T, diagnostics: ^^sp.IBlob, operation: string) -> bool {
	if diagnostics^ == nil {
		return true
	}

	blob := diagnostics^
	bytes := slice.bytes_from_ptr(blob->getBufferPointer(), int(blob->getBufferSize()))
	ok := testing.expectf(t, false, "%s produced diagnostics:\n%s", operation, string(bytes))
	release_diagnostics(diagnostics)
	return ok
}

create_spirv_session :: proc(t: ^testing.T, global_session: ^sp.IGlobalSession) -> ^sp.ISession {
	target_options := [?]sp.CompilerOptionEntry{
		{
			name  = .EmitSpirvDirectly,
			value = {kind = .Int, intValue0 = 1},
		},
		{
			name  = .Optimization,
			value = {kind = .Int, intValue0 = i32(sp.OptimizationLevel.NONE)},
		},
	}
	target_desc := sp.TargetDesc{
		structureSize            = size_of(sp.TargetDesc),
		format                   = .SPIRV,
		profile                  = global_session->findProfile("sm_6_0"),
		flags                    = {.GENERATE_SPIRV_DIRECTLY},
		compilerOptionEntries    = &target_options[0],
		compilerOptionEntryCount = len(target_options),
	}
	session_desc := sp.SessionDesc{
		structureSize = size_of(sp.SessionDesc),
		targets       = &target_desc,
		targetCount   = 1,
	}

	session: ^sp.ISession
	result := global_session->createSession(session_desc, &session)
	if !testing.expectf(t, sp.SUCCEEDED(result) && session != nil, "createSession failed: %d", result) {
		if session != nil {
			session->release()
		}
		return nil
	}
	return session
}

compile_valid_spirv :: proc(t: ^testing.T, session: ^sp.ISession, module_name: cstring) -> bool {
	diagnostics: ^sp.IBlob
	module := sp.loadModuleFromSource(
		session,
		module_name,
		"fixtures/valid_compute.slang",
		cstring(raw_data(VALID_COMPUTE_SOURCE)),
		uint(len(VALID_COMPUTE_SOURCE)),
		&diagnostics,
	)
	if !expect_no_compile_diagnostics(t, &diagnostics, "loadModuleFromSource") ||
	   !testing.expect(t, module != nil, "loadModuleFromSource returned no module") {
		if module != nil {
			module->release()
		}
		return false
	}
	defer module->release()

	entry_point: ^sp.IEntryPoint
	result := module->findEntryPointByName("main", &entry_point)
	if !testing.expectf(t, sp.SUCCEEDED(result) && entry_point != nil, "findEntryPointByName failed: %d", result) {
		if entry_point != nil {
			entry_point->release()
		}
		return false
	}
	defer entry_point->release()

	components := [2]^sp.IComponentType{module, entry_point}
	composite: ^sp.IComponentType
	result = session->createCompositeComponentType(
		&components[0],
		len(components),
		&composite,
		&diagnostics,
	)
	if !expect_no_compile_diagnostics(t, &diagnostics, "createCompositeComponentType") ||
	   !testing.expectf(t, sp.SUCCEEDED(result) && composite != nil, "composition failed: %d", result) {
		if composite != nil {
			composite->release()
		}
		return false
	}
	defer composite->release()

	linked: ^sp.IComponentType
	result = composite->link(&linked, &diagnostics)
	if !expect_no_compile_diagnostics(t, &diagnostics, "link") ||
	   !testing.expectf(t, sp.SUCCEEDED(result) && linked != nil, "link failed: %d", result) {
		if linked != nil {
			linked->release()
		}
		return false
	}
	defer linked->release()

	code: ^sp.IBlob
	result = linked->getTargetCode(0, &code, &diagnostics)
	if !expect_no_compile_diagnostics(t, &diagnostics, "getTargetCode") ||
	   !testing.expectf(t, sp.SUCCEEDED(result) && code != nil, "SPIR-V emission failed: %d", result) {
		if code != nil {
			code->release()
		}
		return false
	}
	defer code->release()

	code_size := code->getBufferSize()
	if !testing.expect(t, code_size >= 4, "SPIR-V blob is too small") ||
	   !testing.expect(t, code_size % 4 == 0, "SPIR-V blob size is not word-aligned") {
		return false
	}
	magic := (^u32)(code->getBufferPointer())^
	return testing.expect_value(t, magic, u32(0x0723_0203))
}

@(test)
embedded_compilation_emits_spirv_and_recovers_from_errors :: proc(t: ^testing.T) {
	global_session: ^sp.IGlobalSession
	result := sp.createGlobalSession(sp.API_VERSION, &global_session)
	if !testing.expectf(t, sp.SUCCEEDED(result) && global_session != nil, "createGlobalSession failed: %d", result) {
		if global_session != nil {
			global_session->release()
		}
		return
	}
	defer global_session->release()

	session := create_spirv_session(t, global_session)
	if session == nil {
		return
	}
	defer session->release()

	diagnostics: ^sp.IBlob
	invalid_module := sp.loadModuleFromSource(
		session,
		"phase5_invalid",
		"fixtures/invalid_compute.slang",
		cstring(raw_data(INVALID_COMPUTE_SOURCE)),
		uint(len(INVALID_COMPUTE_SOURCE)),
		&diagnostics,
	)
	if invalid_module != nil {
		invalid_module->release()
	}
	testing.expect(t, invalid_module == nil, "invalid source unexpectedly produced a module")
	if testing.expect(t, diagnostics != nil, "invalid source produced no diagnostics") {
		testing.expect(t, diagnostics->getBufferSize() > 0, "invalid-source diagnostics are empty")
	}
	release_diagnostics(&diagnostics)

	compile_valid_spirv(t, session, "phase5_valid_after_error")
}
