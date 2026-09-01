package slang_tests

import sp "../slang"

// Slang's process-wide shutdown must run after every test-owned interface has been released.
@(fini)
shutdown_slang_test_runtime :: proc "contextless"() {
	sp.shutdown()
}
