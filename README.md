Forked from: https://github.com/DragosPopse/odin-slang

# odin-slang

Odin bindings for the [Slang shader compiler](https://github.com/shader-slang/slang), built and tested against `Slang v2026.16.1`.

Includes:

- compiler, component-model, and reflection bindings;
- reflection helpers;
- in-process Slang-to-SPIR-V compilation;
- bundled Slang libraries for Windows x86-64, Linux x86-64, and macOS arm64;
- compiler, reflection, and ABI tests;

The bindings link against the native libraries included in this repository.

## Quick start

From the repository root, run:

```sh
odin run .
```

This builds and opens the Vulkan example. It displays a rotating triangle and recompiles
`example/triangle.slang` whenever you save the file. A Vulkan 1.3-capable driver is required.

To try the reflection API without opening a window, run:

```sh
odin run . -- reflection-example
```

This compiles the shaders under `example/reflection_api/` and prints their reflected
parameters, resource bindings, and entry points.

## Repository layout

```text
odin-slang/
├── slang/
│   ├── lib/windows/            Windows import library and runtime DLL
│   ├── lib/linux/              Linux shared library
│   ├── lib/mac/                macOS shared library
│   └── reflection_wrapper/     Higher-level reflection helpers
├── example/                    Vulkan shader hot-reload example
│   └── reflection_api/         Reflection API example
├── tests/
└── public_headers/             Slang headers used to check ABI
```

## Use odin-slang in your project

Place this repository somewhere your Odin source can import it. For example:

```text
your-project/
├── src/
└── vendor/
    └── odin-slang/
```

If your program is in `src/`, import the bindings with:

```odin
import sp "../vendor/odin-slang/slang"
```

The first step in any compiler integration is to create a global session, describe the output you
want, and create a compilation session. This example requests SPIR-V output:

```odin
global_session: ^sp.IGlobalSession
result := sp.createGlobalSession(sp.API_VERSION, &global_session)
assert(sp.SUCCEEDED(result) && global_session != nil)
defer sp.shutdown()
defer global_session->release()

target := sp.TargetDesc {
	structureSize = size_of(sp.TargetDesc),
	format        = .SPIRV,
	profile       = global_session->findProfile("sm_6_0"),
	flags         = {.GENERATE_SPIRV_DIRECTLY},
}

session_desc := sp.SessionDesc {
	structureSize = size_of(sp.SessionDesc),
	targets       = &target,
	targetCount   = 1,
}

session: ^sp.ISession
result = global_session->createSession(session_desc, &session)
assert(sp.SUCCEEDED(result) && session != nil)
defer session->release()
```

From that session, load a module, find its entry points, compose and link them, and call
`getTargetCode` to obtain the compiled bytes. See
[`reload_shader_pipelines`](example/example.odin) for a complete working implementation with
diagnostic handling.

Slang interfaces are reference-counted. The `defer` calls matter: release compiled code, linked
programs, entry points, and modules before the session that created them, then release the global
session last.

## Development commands

All project commands are run from the repository root:

| Command | What it does |
| --- | --- |
| `odin run .` | Builds and runs the Vulkan hot-reload example |
| `odin run . -- build` | Builds the Vulkan example without running it |
| `odin run . -- reflection-example` | Builds and runs the console reflection example |
| `odin run . -- check` | Type-checks the bindings and Vulkan example |
| `odin run . -- test` | Runs the native-library, compiler, reflection, and ABI tests |

## Versioning and maintenance

`sp.BOUND_SLANG_VERSION` identifies the Slang release used by the bindings. When updating Slang,
update the Odin files, copied public headers, bundled libraries, ABI checks, and library version test
together.

## Licensing status

This repository is derived from [DragosPopse/odin-slang](https://github.com/DragosPopse/odin-slang),
which did not include a license for its source code. This fork therefore cannot grant an
open-source license for the repository as a whole. See [LICENSE](LICENSE) for details.

The bundled Slang libraries remain separately licensed under Apache-2.0 with the LLVM exception;
see [slang.LICENSE](slang.LICENSE) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

Credits to [@wrapperup](https://github.com/wrapperup) for the original hot-reloadable Vulkan
example.
