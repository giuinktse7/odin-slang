# Pinned Slang Public Headers

These files are immutable audit inputs for the Odin binding. They are copied from the named
upstream Git tag, not from a moving branch or from a locally installed SDK. Do not edit them to
make the binding compile; update the binding or add a new versioned directory instead.

## Provenance

| Version      | Annotated tag object                       | Peeled commit                              | Tag date   |
| ------------ | ------------------------------------------ | ------------------------------------------ | ---------- |
| `v2025.16.1` | `368e2283201fdb91cf96257a2ac398cd77bbd33d` | `3aff764c2b5d613f766538d27e0b9f448e7ed5ca` | 2025-09-08 |
| `v2026.16.1` | `ee2c5c129d74330751c3b91f6cdf494613389baf` | `ab5db6cf5c645a816894db670dacd322ec59d3ac` | 2026-08-28 |

Each file was retrieved from:

```text
https://raw.githubusercontent.com/shader-slang/slang/<tag>/include/<filename>
```

The three-file set is intentional:

- `slang.h` defines the core C/C++ ABI, interfaces, reflection types, and standalone exports.
- `slang-deprecated.h` declares the legacy `spReflection*` exports and `ICompileRequest` that the
  existing Odin package exposes.
- `slang-image-format-defs.h` is the canonical numeric source for `SlangImageFormat`.

## SHA-256

| Version      | File                        | SHA-256                                                            |
| ------------ | --------------------------- | ------------------------------------------------------------------ |
| `v2025.16.1` | `slang.h`                   | `133d09191a4a1eedc70f1b88be383910f9244c4c22a97da70a63bad39c7e25be` |
| `v2025.16.1` | `slang-deprecated.h`        | `637945c6162b9dab43cd51726eabab9ffaf6937841fcd8e4337cd4e2041ccc35` |
| `v2025.16.1` | `slang-image-format-defs.h` | `35ad9b68cfa889157b2bf4a4ef39263b4ad5f0f760ffee66aca03438e8363bcd` |
| `v2026.16.1` | `slang.h`                   | `d3ade061ab2b09b92112a66c89c75e7ec282ee52e9cefdfe7b384b4fd18e6892` |
| `v2026.16.1` | `slang-deprecated.h`        | `ec8b5936b7eb0ee7ab4dee024f4aada0e5a7a2b5ff78879694b26b235664f328` |
| `v2026.16.1` | `slang-image-format-defs.h` | `35ad9b68cfa889157b2bf4a4ef39263b4ad5f0f760ffee66aca03438e8363bcd` |

Reproduce the checksum check from the repository root with:

```sh
sha256sum public_headers/v2025.16.1/* public_headers/v2026.16.1/*
```

The declaration-level comparison and required binding actions are recorded in
[`ABI_AUDIT.md`](ABI_AUDIT.md).
