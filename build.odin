package main

import "core:fmt"
import "core:os"

when ODIN_OS == .Windows {
	EXAMPLE_OUTPUT     :: "build/odin-slang-example.exe"
	REFLECTION_OUTPUT  :: "build/odin-slang-reflection-example.exe"
	TEST_OUTPUT        :: "build/odin-slang-tests.exe"
	NATIVE_TEST_OUTPUT :: "build/odin-slang-native-artifact-tests.exe"
	WINDOWS_DLL        :: "slang/lib/windows/slang-compiler.dll"
} else {
	EXAMPLE_OUTPUT     :: "build/odin-slang-example"
	REFLECTION_OUTPUT  :: "build/odin-slang-reflection-example"
	TEST_OUTPUT        :: "build/odin-slang-tests"
	NATIVE_TEST_OUTPUT :: "build/odin-slang-native-artifact-tests"
}

main :: proc() {
	target := "run"
	if len(os.args) > 1 {
		target = os.args[1]
	}

	switch target {
	case "build":
		build_example()
	case "run":
		build_example()
		run_process({EXAMPLE_OUTPUT})
	case "reflection-example":
		run_reflection_example()
	case "test":
		run_tests()
	case "check":
		run_process({"odin", "check", "slang", "-no-entry-point"})
		run_process({"odin", "check", "example"})
	case:
		fmt.eprintln("usage: odin run . -- [build|run|reflection-example|test|check]")
		os.exit(2)
	}
}

build_example :: proc() {
	prepare_runtime()
	run_process({"odin", "build", "example", "-out:" + EXAMPLE_OUTPUT})
}

run_reflection_example :: proc() {
	prepare_runtime()
	run_process({
		"odin",
		"build",
		"example/reflection_api",
		"-out:" + REFLECTION_OUTPUT,
		"-define:SLANG_REFLECTION_ENTRY_POINT_METADATA=false",
		"-define:SLANG_REFLECTION_INCLUDE_RASTER=false",
	})

	reflection_executable := absolute_path(REFLECTION_OUTPUT)
	run_process_in({reflection_executable}, "example/reflection_api")
}

run_tests :: proc() {
	prepare_runtime()
	run_process({"odin", "test", "tests/native_artifact", "-out:" + NATIVE_TEST_OUTPUT})
	run_process({
		"odin",
		"test",
		"tests",
		"-out:" + TEST_OUTPUT,
		"-define:ODIN_TEST_THREADS=1",
		"-sanitize:address",
	})
}

prepare_runtime :: proc() {
	if err := os.make_directory_all("build"); err != nil && err != .Exist {
		fmt.eprintf("could not create build directory: %v\n", err)
		os.exit(1)
	}

	when ODIN_OS == .Windows {
		if err := os.copy_file("build/slang-compiler.dll", WINDOWS_DLL); err != nil {
			fmt.eprintf("could not stage Slang DLL: %v\n", err)
			os.exit(1)
		}
	}

	when ODIN_OS == .Linux {
		if err := os.set_env("LD_LIBRARY_PATH", absolute_path("slang/lib/linux")); err != nil {
			fmt.eprintf("could not set LD_LIBRARY_PATH: %v\n", err)
			os.exit(1)
		}
	}

	when ODIN_OS == .Darwin {
		if err := os.set_env("DYLD_LIBRARY_PATH", absolute_path("slang/lib/mac")); err != nil {
			fmt.eprintf("could not set DYLD_LIBRARY_PATH: %v\n", err)
			os.exit(1)
		}
	}
}

absolute_path :: proc(path: string) -> string {
	working_directory, err := os.get_working_directory(context.temp_allocator)
	if err != nil {
		fmt.eprintf("could not get working directory: %v\n", err)
		os.exit(1)
	}
	return fmt.tprintf("%s/%s", working_directory, path)
}

run_process :: proc(command: []string) {
	run_process_in(command, "")
}

run_process_in :: proc(command: []string, working_dir: string) {
	process, err := os.process_start({
		command     = command,
		working_dir = working_dir,
		stdin       = os.stdin,
		stdout      = os.stdout,
		stderr      = os.stderr,
	})

	if err != nil {
		fmt.eprintf("could not start %s: %v\n", command[0], err)
		os.exit(1)
	}

	state, wait_err := os.process_wait(process)
	if wait_err != nil {
		fmt.eprintf("could not wait for %s: %v\n", command[0], wait_err)
		os.exit(1)
	}

	if !state.success {
		os.exit(state.exit_code)
	}
}
