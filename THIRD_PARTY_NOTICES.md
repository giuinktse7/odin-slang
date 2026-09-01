# Third-party notices

This project provides Odin bindings to the [Slang shader compiler](https://github.com/shader-slang/slang)
and redistributes precompiled Slang libraries under `slang/lib/`.

Slang is licensed under the Apache License 2.0 with the LLVM exception. A copy of its upstream
license is preserved in [slang.LICENSE](slang.LICENSE). This third-party license does not license
the inherited Odin binding code or override the repository's status described in the root
[LICENSE](LICENSE).

According to the Slang project, builds of its core tools depend automatically or optionally on
third-party projects including:

- ankerl::unordered_dense (MIT)
- fast_float (Apache-2.0, MIT, or Boost Software License)
- glslang (BSD)
- LZ4 (BSD)
- miniz (MIT)
- SPIR-V Headers (MIT-style license)
- SPIR-V Tools (Apache-2.0)

Some Slang releases may also include LLVM, licensed under Apache-2.0 with the LLVM exception.
Copyright and license notices belonging to Slang and these dependencies remain the property of
their respective authors. The authoritative license materials for the redistributed Slang build
are maintained in Slang's upstream [`LICENSE`](https://github.com/shader-slang/slang/blob/master/LICENSE)
and [`LICENSES`](https://github.com/shader-slang/slang/tree/master/LICENSES) directory.
