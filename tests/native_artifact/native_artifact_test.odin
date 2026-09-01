package native_artifact_tests

import "core:testing"

import sp "../../slang"

@(test)
native_compiler_matches_bound_version :: proc(t: ^testing.T) {
	global_session: ^sp.IGlobalSession
	result := sp.createGlobalSession(sp.API_VERSION, &global_session)
	if !testing.expectf(t, sp.SUCCEEDED(result) && global_session != nil, "createGlobalSession failed: %d", result) {
		return
	}
	defer sp.shutdown()
	defer global_session->release()

	build_tag := global_session->getBuildTagString()
	if testing.expect(t, build_tag != nil, "Slang returned a nil build tag") {
		testing.expect_value(t, string(build_tag), sp.BOUND_SLANG_VERSION)
	}
}
