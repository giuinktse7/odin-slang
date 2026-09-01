package slang_tests

import "core:slice"
import "core:testing"

import sp "../slang"
import reflection "../slang/reflection_wrapper"

REFLECTION_SOURCE :: #load("fixtures/reflection.slang", string)

consume_diagnostics :: proc(t: ^testing.T, diagnostics: ^^sp.IBlob) -> bool {
	if diagnostics^ == nil {
		return true
	}

	blob := diagnostics^
	bytes := slice.bytes_from_ptr(blob->getBufferPointer(), int(blob->getBufferSize()))
	ok := testing.expectf(t, false, "unexpected Slang diagnostics:\n%s", string(bytes))
	blob->release()
	diagnostics^ = nil
	return ok
}

find_global_field :: proc(
	root: ^sp.TypeLayoutReflection,
	name: cstring,
) -> (field: ^sp.VariableLayoutReflection, field_index: u32, found: bool) {
	for index in 0 ..< sp.type_layout_getFieldCount(root) {
		candidate := sp.type_layout_getFieldByIndex(root, index)
		if candidate != nil && sp.variable_layout_getName(candidate) == name {
			return candidate, index, true
		}
	}
	return nil, 0, false
}

unwrap_global_scope :: proc(layout: ^sp.VariableLayoutReflection) -> ^sp.TypeLayoutReflection {
	type_layout := sp.variable_layout_getTypeLayout(layout)
	for type_layout != nil {
		#partial switch sp.type_layout_getKind(type_layout) {
		case .ConstantBuffer, .ParameterBlock:
			element := sp.type_layout_getElementVarLayout(type_layout)
			if element == nil {
				return nil
			}
			type_layout = sp.variable_layout_getTypeLayout(element)
		case:
			return type_layout
		}
	}
	return nil
}

has_category :: proc(layout: ^sp.VariableLayoutReflection, category: sp.ParameterCategory) -> bool {
	for index in 0 ..< sp.variable_layout_getCategoryCount(layout) {
		if sp.variable_layout_getCategoryByIndex(layout, index) == category {
			return true
		}
	}
	return false
}

expect_binding_type :: proc(
	t: ^testing.T,
	root: ^sp.TypeLayoutReflection,
	field_index: u32,
	expected: sp.BindingType,
) {
	range_index := sp.type_layout_getFieldBindingRangeOffset(root, sp.Int(field_index))
	if testing.expectf(t, range_index >= 0, "field %d has no binding range", field_index) {
		testing.expect_value(t, sp.type_layout_getBindingRangeType(root, range_index), expected)
	}
}

@(test)
reflection_reports_known_vulkan_resources :: proc(t: ^testing.T) {
	global_session: ^sp.IGlobalSession
	result := sp.createGlobalSession(sp.API_VERSION, &global_session)
	if !testing.expectf(t, sp.SUCCEEDED(result) && global_session != nil, "createGlobalSession failed: %d", result) {
		if global_session != nil {
			global_session->release()
		}
		return
	}
	defer global_session->release()

	target_desc := sp.TargetDesc{
		structureSize = size_of(sp.TargetDesc),
		format        = .SPIRV,
		profile       = global_session->findProfile("sm_6_0"),
		flags         = {.GENERATE_SPIRV_DIRECTLY},
	}
	session_desc := sp.SessionDesc{
		structureSize = size_of(sp.SessionDesc),
		targets       = &target_desc,
		targetCount   = 1,
	}

	session: ^sp.ISession
	result = global_session->createSession(session_desc, &session)
	if !testing.expectf(t, sp.SUCCEEDED(result) && session != nil, "createSession failed: %d", result) {
		if session != nil {
			session->release()
		}
		return
	}
	defer session->release()

	diagnostics: ^sp.IBlob
	module := sp.loadModuleFromSource(
		session,
		"phase3_reflection",
		"fixtures/reflection.slang",
		cstring(raw_data(REFLECTION_SOURCE)),
		uint(len(REFLECTION_SOURCE)),
		&diagnostics,
	)
	if !consume_diagnostics(t, &diagnostics) || !testing.expect(t, module != nil, "loadModuleFromSource failed") {
		if module != nil {
			module->release()
		}
		return
	}
	defer module->release()

	entry_point: ^sp.IEntryPoint
	result = module->findEntryPointByName("main", &entry_point)
	if !testing.expectf(t, sp.SUCCEEDED(result) && entry_point != nil, "findEntryPointByName failed: %d", result) {
		if entry_point != nil {
			entry_point->release()
		}
		return
	}
	defer entry_point->release()

	components: [2]^sp.IComponentType
	components[0] = module
	components[1] = entry_point

	composite: ^sp.IComponentType
	result = session->createCompositeComponentType(
		&components[0],
		len(components),
		&composite,
		&diagnostics,
	)
	if !consume_diagnostics(t, &diagnostics) || !testing.expectf(t, sp.SUCCEEDED(result) && composite != nil, "createCompositeComponentType failed: %d", result) {
		if composite != nil {
			composite->release()
		}
		return
	}
	defer composite->release()

	linked: ^sp.IComponentType
	result = composite->link(&linked, &diagnostics)
	if !consume_diagnostics(t, &diagnostics) || !testing.expectf(t, sp.SUCCEEDED(result) && linked != nil, "link failed: %d", result) {
		if linked != nil {
			linked->release()
		}
		return
	}
	defer linked->release()

	program_layout := linked->getLayout(0, &diagnostics)
	if !consume_diagnostics(t, &diagnostics) || !testing.expect(t, program_layout != nil, "getLayout failed") {
		return
	}

	testing.expect_value(t, sp.program_layout_getEntryPointCount(program_layout), sp.UInt(1))
	entry_layout := sp.program_layout_getEntryPointByIndex(program_layout, 0)
	if testing.expect(t, entry_layout != nil, "missing reflected entry point") {
		testing.expect_value(t, sp.entry_point_getStage(entry_layout), sp.Stage.COMPUTE)
		thread_group_size: [3]sp.UInt
		sp.entry_point_getComputeThreadGroupSize(entry_layout, len(thread_group_size), &thread_group_size[0])
		testing.expect_value(t, thread_group_size, [3]sp.UInt{8, 4, 1})
	}

	global_layout := sp.program_layout_getGlobalParamsVarLayout(program_layout)
	if !testing.expect(t, global_layout != nil, "missing global parameter layout") {
		return
	}
	root := unwrap_global_scope(global_layout)
	if !testing.expect(t, root != nil, "missing global parameter type layout") {
		return
	}

	texture, texture_index, texture_found := find_global_field(root, "albedoTexture")
	if testing.expect(t, texture_found, "missing albedoTexture reflection") {
		testing.expect_value(t, sp.type_layout_getKind(sp.variable_layout_getTypeLayout(texture)), sp.TypeReflectionKind.Resource)
		testing.expect_value(t, sp.variable_layout_getBindingIndex(texture), u32(0))
		testing.expect_value(t, sp.variable_layout_getBindingSpace_bytes(texture), u32(0))
		expect_binding_type(t, root, texture_index, .TEXTURE)
	}

	sampler, sampler_index, sampler_found := find_global_field(root, "linearSampler")
	if testing.expect(t, sampler_found, "missing linearSampler reflection") {
		testing.expect_value(t, sp.type_layout_getKind(sp.variable_layout_getTypeLayout(sampler)), sp.TypeReflectionKind.SamplerState)
		testing.expect_value(t, sp.variable_layout_getBindingIndex(sampler), u32(1))
		testing.expect_value(t, sp.variable_layout_getBindingSpace_bytes(sampler), u32(0))
		expect_binding_type(t, root, sampler_index, .SAMPLER)
	}

	scene, scene_index, scene_found := find_global_field(root, "scene")
	if testing.expect(t, scene_found, "missing scene constant-buffer reflection") {
		scene_type_layout := sp.variable_layout_getTypeLayout(scene)
		testing.expect_value(t, sp.type_layout_getKind(scene_type_layout), sp.TypeReflectionKind.ConstantBuffer)
		testing.expect(t, sp.type_layout_getSize(sp.type_layout_getElementTypeLayout(scene_type_layout), .Uniform) >= 32)
		expect_binding_type(t, root, scene_index, .CONSTANT_BUFFER)
	}

	push_data, push_index, push_found := find_global_field(root, "pushData")
	if testing.expect(t, push_found, "missing pushData reflection") {
		testing.expect(t, has_category(push_data, .PushConstantBuffer), "pushData lacks the push-constant category")
		expect_binding_type(t, root, push_index, .PUSH_CONSTANT)
	}

	testing.expect(t, sp.program_layout_getGlobalConstantBufferSize(program_layout) >= 4)
	bindless_space := sp.program_layout_getBindlessSpaceIndex(program_layout)
	testing.expect(t, bindless_space >= -1)

	wrapped := reflection.init_program_layout(program_layout)
	testing.expect_value(t, wrapped->getEntryPointCount(), sp.UInt(1))
	testing.expect_value(t, wrapped->getEntryPointByIndex(0)->getStage(), sp.Stage.COMPUTE)
	testing.expect_value(t, wrapped->getBindlessSpaceIndex(), bindless_space)
}
