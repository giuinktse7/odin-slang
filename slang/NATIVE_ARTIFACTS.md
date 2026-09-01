# Slang v2026.16.1 Native Artifact Manifest

This manifest fixes the Phase 4 replacement set before any checked-in binary is changed. The V1
runtime is embedded Slang compilation directly to SPIR-V. It does not invoke `slangc`, use a system
Slang installation, or request a downstream GLSL/LLVM/host compiler.

## Verified official archives

| Target         | Official release asset                 |      Bytes | SHA-256                                                            |
| -------------- | -------------------------------------- | ---------: | ------------------------------------------------------------------ |
| Linux x86-64   | `slang-2026.16.1-linux-x86_64.tar.gz`  | 79,187,425 | `6c271f69309af124cf948a9f442b813fec190feb46ff7a883e11001d29df005f` |
| Windows x86-64 | `slang-2026.16.1-windows-x86_64.zip`   | 59,502,572 | `0fd3e6a9a5d05ed4cdd000d467f1ffb5d9701b827e83bfb428902a45c37ef8a5` |
| macOS arm64    | `slang-2026.16.1-macos-aarch64.tar.gz` | 58,375,540 | `31bb295d0ead64f5906ae140fb42067029412ca02330c11ff8ea63986560216a` |

Release asset URL pattern:

```text
https://github.com/shader-slang/slang/releases/download/v2026.16.1/<asset>
```

## Final retained set

| Target         | Repository files to retain                                                                                                    |               Bytes | SHA-256 / identity                                                                                                                                                                                                   |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------: | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux x86-64   | `slang/lib/libslang-compiler.so` -> `libslang-compiler.so.0.2026.16.1`; `slang/lib/libslang-compiler.so.0.2026.16.1`          | 30,677,280 (target) | target SHA-256 `8d5a575b44e894270e89190d01d7b08da0ae5f219002530cfeb298d42a73ac66`; ELF x86-64; SONAME `libslang-compiler.so.0.2026.16.1`                                                                             |
| Windows x86-64 | `slang/lib/slang-compiler.lib`; staged runtime `slang/bin/slang-compiler.dll`                                                 | 170,158; 25,414,144 | import library `50b841806a8ab4b77130d8872c0f1a262a0650e7248a43bec236528abcbba308`; DLL `794d74f4af8374c3623ee36e0d40451cabf1b76e0b25ce8bb3640ea4c4c1d70e`; COFF/PE x86-64; import library names `slang-compiler.dll` |
| macOS arm64    | `slang/lib/libslang-compiler.dylib` -> `libslang-compiler.0.2026.16.1.dylib`; `slang/lib/libslang-compiler.0.2026.16.1.dylib` | 29,415,280 (target) | target SHA-256 `97efbb23434bc98b36f4b08f4016eb2978b1575f7ed0cac4d6b23e832e512de7`; Mach-O arm64; install name `@rpath/libslang-compiler.0.2026.16.1.dylib`, current version `2026.16.1`                              |

The unversioned Unix files are the exact relative symlinks from the release archives. They are
needed at link time; their versioned targets are needed at runtime. Windows needs both the import
library at link time and the matching DLL on the executable search path.

## Dependency closure and exclusions

The Linux compiler DSO has RUNPATH `$ORIGIN/../lib:$ORIGIN` and directly needs only the platform C,
C++, math, GCC support, and ELF loader libraries. The macOS compiler dylib directly needs only
Apple's system `libc++` and `libSystem`. The Windows compiler DLL imports only `SHELL32.dll`,
`ADVAPI32.dll`, `KERNEL32.dll`, and `ole32.dll`. Therefore the compiler library is self-contained
for the direct SPIR-V path; no release companion module belongs in the minimal V1 runtime set.

Explicitly do not retain:

- Legacy compatibility proxies: `libslang.so`, `libslang.dylib`, `slang.lib`, and `slang.dll`.
- Optional downstream/compiler modules: `slang-glslang`, `slang-glsl-module`, and `slang-llvm`.
- Unused runtime/GFX layers: `slang-rt`, `gfx`, their import libraries, and their shared libraries.
- Tools and data not used by the embedded API path: `slang`, `slangc`, `slangd`, `slangi`,
  `slang.slang`, `gfx.slang`, and `slang-standard-module-*`.

Those files remain available in the upstream archive if a future feature intentionally uses GLSL,
LLVM, host-callable code, GFX, the Slang runtime, or the separately shipped standard modules. Such a
feature must expand this manifest and its runtime tests rather than silently relying on adjacent
files.

## Phase 4 acceptance checks

1. Delete or replace every retained v2025 artifact; never mix release generations.
2. Import only the canonical `slang-compiler` names in both raw Odin binding files.
3. Recompute file hashes and inspect ELF SONAME, Mach-O install name, and PE import target.
4. On Linux, inspect the built executable with `readelf`/`ldd` and prove it resolves the repository
   `libslang-compiler.so.0.2026.16.1`, not `libslang.so` or a system library.
5. At runtime, require `IGlobalSession.getBuildTagString()` to identify `v2026.16.1`.
