# Slang v2026.16.1 Structural ABI Audit

This is the Phase 1 implementation ledger for the declarations currently exposed by
`slang/slang.odin`, `slang/reflection.odin`, `slang/deprecated.odin`, and `slang/uuid.odin`.
The target contract is the pinned three-header `v2026.16.1` set in this directory. The
`v2025.16.1` set is the comparison baseline. Product version `2026.16.1` does not change
`SLANG_API_VERSION`, which remains `0`.

The audit is structural: declaration names, integer widths and values, pointer depth, calling
convention, struct/union fields, base interfaces, and vtable order were compared. Exact native
sizes and offsets are deliberately deferred to the C++/Odin probes in Phase 2.

Status terms used below:

- **keep** — the current declaration has the target ABI on the supported 64-bit targets.
- **correct** — Phase 2 or 3 must change the Odin declaration.
- **append/add** — target ABI added a value, field-dependent type, method, or export needed by an
  already exposed surface.
- **remove** — no callable target declaration exists.
- **source-only** — `const`, spelling, or naming differs without changing the binary signature.
- **exclude** — a separate target API is outside the agreed V1 surface and cannot shift an existing
  vtable.

## Core scalar, enum, flag, and callback ledger

All ABI-facing enums must receive explicit numeric values during Phase 2, including values that did
not numerically change. This avoids future shifts from implicit Odin numbering.

| Current Odin declaration                                                    | Target contract and required action                                                                                                                                                                                                             |
| --------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Int`, `UInt`                                                               | **keep** as pointer-sized signed/unsigned integers (`SlangInt`, `SlangUInt`). Supported artifacts are all 64-bit.                                                                                                                               |
| `Bool`, `Result`                                                            | **keep** as C++ `bool` and signed `int32_t`.                                                                                                                                                                                                    |
| `API_VERSION`                                                               | **keep** at `0`; add separate `BOUND_SLANG_VERSION = "2026.16.1"`.                                                                                                                                                                              |
| `PassThrough`                                                               | Values 0-14 are stable; add/count `COUNT_OF = 15`.                                                                                                                                                                                              |
| `CompileTarget`                                                             | Values 0-31 are stable. Add `CPP_HEADER=32`, `CUDA_HEADER=33`, `HOST_OBJECT_CODE=34`, `HOST_LLVM_IR=35`, `SHADER_LLVM_IR=36`, and `COUNT_OF=37`. Correct the source spelling `CPP_PYTORCH_BINDING=23` (current plural spelling is ABI-neutral). |
| `ContainerFormat`                                                           | **keep** 0-1; make values explicit.                                                                                                                                                                                                             |
| `ArchiveType`                                                               | **keep** 0-4; add `COUNT_OF=5`.                                                                                                                                                                                                                 |
| `CompileFlag`/`CompileFlags`                                                | **keep** bit positions 3, 4, 5, which produce masks `0x08`, `0x10`, `0x20`; assert masks. Zero-valued deprecated flags remain intentionally unrepresentable as bit-set members.                                                                 |
| `TargetFlag`/`TargetFlags`                                                  | **keep** bit positions 4, 8, 9, 10, which produce masks `0x10`, `0x100`, `0x200`, `0x400`; use unsigned ABI width and assert masks.                                                                                                             |
| `FloatingPointMode`, `FpDenormalMode`, `LineDirectiveMode`                  | **keep** respective values `0..2`, `0..2`, and `0..4`; make explicit.                                                                                                                                                                           |
| `SourceLanguage`                                                            | Add `LLVM=10`; existing values 0-9 are stable.                                                                                                                                                                                                  |
| `ProfileID`, `CapabilityID`, `MatrixLayoutMode`                             | **keep** widths and values; make enum values explicit.                                                                                                                                                                                          |
| `Stage`                                                                     | Add `NODE=16`, `COUNT_OF=17`; keep `PIXEL=FRAGMENT=5`.                                                                                                                                                                                          |
| `DebugInfoLevel`, `DebugInfoFormat`, `OptimizationLevel`, `EmitSpirvMethod` | **keep** values; make explicit.                                                                                                                                                                                                                 |
| `CompilerOptionName`                                                        | Existing 0-129 values remain stable. Make all explicit and append 130-159 as listed below.                                                                                                                                                      |
| `CompilerOptionValueKind`                                                   | **keep** `Int=0`, `String=1`.                                                                                                                                                                                                                   |
| `CompileCoreModuleFlag`/`CompileCoreModuleFlags`                            | **correct**: upstream `WriteDocumentation` is already the mask `0x1`; the current `bit_set` interprets `1` as a bit position and produces `0x2`. Represent or map it so the public mask is exactly `0x1`.                                       |
| `PathType`, `OSPathKind`, `PathKind`                                        | **keep** widths `u32`, `u8`, `i32` and values; make explicit and add relevant count sentinels.                                                                                                                                                  |
| `WriterChannel`, `WriterMode`                                               | **keep** unsigned 32-bit values; make explicit.                                                                                                                                                                                                 |
| `SpecializationArgKind`, `LanguageVersion`                                  | **keep** specialization values. Add language aliases `202A=2025`, `202B=2026`, development `202C=2027`, and `NEXT=2027`; stable `LATEST=2026`.                                                                                                  |
| `SessionFlags`                                                              | **correct** from an empty signed `i32` enum to the upstream `uint32_t` representation.                                                                                                                                                          |
| `ImageFormat`                                                               | **correct** the empty enum by expanding the complete ordered `slang-image-format-defs.h` list (`unknown` through `bgra8`); values are unchanged between snapshots.                                                                              |
| `LayoutRules`                                                               | Add `DEFAULT_STRUCTURED_BUFFER=2` and `DEFAULT_CONSTANT_BUFFER=3`; keep 0-1.                                                                                                                                                                    |
| `ContainerType`, `BuiltinModuleName`                                        | **keep** values and signed enum representation; make explicit.                                                                                                                                                                                  |
| `DiagnosticFlags`, `Severity`                                               | **keep** signed 32-bit masks/values; make all values explicit.                                                                                                                                                                                  |
| `FileSystemContentsCallback`                                                | **correct** to explicit C calling convention; parameters already match.                                                                                                                                                                         |
| `FuncPtr`, `DiagnosticCallback`                                             | **keep** C calling convention and parameters.                                                                                                                                                                                                   |

`CompilerOptionName` target additions are:

```text
130 ExperimentalFeature                 145 TraceCoverage
131 ReportDetailedPerfBenchmark         146 TraceCoverageBinding
132 ValidateIRDetailed                  147 TraceCoverageReservedSpace
133 DumpIRBefore                        148 TraceFunctionCoverage
134 DumpIRAfter                         149 TraceBranchCoverage
135 EmitCPUMethod                       150 CoverageManifestOutput
136 EmitCPUViaCPP                       151 TraceCoverageCounterByteWidth
137 EmitCPUViaLLVM                      152 TraceCoverageBoolean
138 LLVMTargetTriple                    153 CompilerVersion
139 LLVMCPU                             154 SPIRVUnifiedDescriptorHeapStride
140 LLVMFeatures                        155 WarningLevel
141 EnableRichDiagnostics               156 SeparateDebugInfoOutput
142 ReportDynamicDispatchSites          157 DebugInfoIncludeSource
143 EnableMachineReadableDiagnostics    158 TraceCoverageBindlessIndex
144 DiagnosticColor                     159 CountOf
```

Because the exposed compiler-option surface can carry their values, add literal enums for
`SlangEmitCPUMethod`, `SlangDiagnosticColor`, and `SlangWarningLevel`. New scope/cooperative-type
enums are **excluded** with their separate experimental data models.

Reflection enum audit:

| Current Odin declaration                                   | Target contract and required action                                                                                                                       |
| ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ReflectionGenericArgType`                                 | **keep** signed values `TYPE=0`, `INT=1`, `BOOL=2`.                                                                                                       |
| `ModifierID`, `SlangModifierID`                            | **keep** `u32` values 0-10.                                                                                                                               |
| `ParameterCategory`, `SlangParameterCategory`              | **keep** 0-24, `COUNT=25`, aliases, and widths; make explicit.                                                                                            |
| `TypeReflectionKind`, `SlangTypeKind`                      | Existing 0-19 are stable; add `Enum/ENUM=20` and count.                                                                                                   |
| `TypeReflectionScalarType`, `SlangScalarType`              | Existing 0-15 are stable; expose pointer-sized entries in the convenience enum and add `BFLOAT16=16`, `FLOAT_E4M3=17`, `FLOAT_E5M2=18`.                   |
| `SlangResourceShape`, `SlangResourceAccess`, `BindingType` | **keep** explicit masks and values. Preserve upstream's misspelled `MUTABLE_TETURE` as a raw alias while retaining a correctly spelled convenience alias. |
| `DeclKind`                                                 | Add `ENUM=7`; existing 0-6 are stable.                                                                                                                    |

## Struct, union, opaque-handle, and UUID ledger

| Declaration                 | Target shape and required action                                                                                                                                                                                                                                                                                                                         |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CompilerOptionValue`       | **keep layout**: `kind:i32`, two `i32`, two pointers. Input strings become `const` (**source-only**).                                                                                                                                                                                                                                                    |
| `CompilerOptionEntry`       | **keep layout**: option enum followed by value.                                                                                                                                                                                                                                                                                                          |
| `UUID`                      | **keep layout**: `u32,u16,u16,[8]u8`.                                                                                                                                                                                                                                                                                                                    |
| `GlobalSessionDesc`         | **keep fields/order**: `u32 structureSize`, `u32 apiVersion`, `u32 minLanguageVersion`, `bool enableGLSL`, `[16]u32 reserved`. Default minimum stays 2025.                                                                                                                                                                                               |
| `SpecializationArg`         | **keep layout**: `i32 kind` plus pointer union.                                                                                                                                                                                                                                                                                                          |
| `TargetDesc`                | **keep fields/order**; `structureSize` is `size_t`, enum/flag fields retain widths, entries become pointer-to-const (**source-only**).                                                                                                                                                                                                                   |
| `PreprocessorMacroDesc`     | **keep layout**: two input string pointers.                                                                                                                                                                                                                                                                                                              |
| `SessionDesc`               | **keep field order**; correct `SessionFlags` width. Target/search/macro/option pointers gain `const` only.                                                                                                                                                                                                                                               |
| `SourceLocation`            | **add** `{cstring filePath; Int line; Int column}` for appended `ISession` slot.                                                                                                                                                                                                                                                                         |
| `SlangReflectionGenericArg` | **correct union**: `typeVal:^TypeReflection`, `intVal:i64` (current binding incorrectly uses `^i64`), `boolVal:bool`.                                                                                                                                                                                                                                    |
| `Modifier`                  | **correct** to an opaque handle. Upstream `SlangReflectionModifier` is incomplete and the C++ helper `Modifier` has no data field; current `id` field must not be dereferenced.                                                                                                                                                                          |
| Reflection handles          | **keep opaque**: `ShaderReflection`/`ProgramLayout`, `EntryPointReflection`, `VariableReflection`, `VariableLayoutReflection`, `TypeReflection`, `TypeLayoutReflection`, `FunctionReflection`, `DeclReflection`, `Attribute`, `TypeParameterReflection`, and `GenericReflection`. Remove the spurious opaque `GenericArgType` in favor of the real enum. |
| Interface values            | Every interface object remains exactly one vtable pointer; flattened base vtables are audited below.                                                                                                                                                                                                                                                     |

All UUID constants currently in `uuid.odin` match the target header byte-for-byte:

```text
IUnknown ICastable IClonable IBlob IFileSystem ISharedLibrary ISharedLibraryLoader
IFileSystemExt IMutableFileSystem IWriter IProfiler IGlobalSession ISession IMetadata
ICompileResult IComponentType IEntryPoint ITypeConformance IComponentType2 IModule
```

Phase 2 must add size/alignment and relevant field-offset assertions for all concrete structs and
the generic-argument union, verified by the exact-header C++ probe.

## Interface and vtable ledger

All methods use `SLANG_MCALL`, represented by Odin `proc "system"`. `const`, default arguments, and
`SLANG_NO_THROW` do not add slots. The exact flattened slot order is below; semicolon-separated
names are consecutive slots.

| Interface and base                    | Exact target slots after inherited base                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Required action                                                                                                                                                                              |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `IUnknown`                            | `queryInterface; addRef; release`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | **keep**.                                                                                                                                                                                    |
| `ICastable : IUnknown`                | `castAs`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | **keep**.                                                                                                                                                                                    |
| `IClonable : ICastable`               | `clone`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | **keep**.                                                                                                                                                                                    |
| `IBlob : IUnknown`                    | `getBufferPointer; getBufferSize`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | **keep**.                                                                                                                                                                                    |
| `IFileSystem : ICastable`             | `loadFile`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | **keep**.                                                                                                                                                                                    |
| `ISharedLibrary : ICastable`          | `findSymbolAddressByName`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Binary signature **keep**; correct Odin field name from `findSymbolByName` (**source-only**). The inline `findFuncByName` is not a slot.                                                     |
| `ISharedLibraryLoader : IUnknown`     | `loadSharedLibrary`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | **keep**.                                                                                                                                                                                    |
| `IFileSystemExt : IFileSystem`        | `getFileUniqueIdentity; calcCombinedPath; getPathType; getPath; clearCache; enumeratePathContents; getOSPathKind`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | **correct** `calcCombinedPath` by inserting leading `PathType fromPathType`; **correct** `getPath` by inserting leading `PathKind kind`; correct callback convention. Other slots keep.      |
| `IMutableFileSystem : IFileSystemExt` | `saveFile; saveFileBlob; remove; createDirectory`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | **keep**.                                                                                                                                                                                    |
| `IWriter : IUnknown`                  | `beginAppendBuffer; endAppendBuffer; write; flush; isConsole; setMode`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | **keep**.                                                                                                                                                                                    |
| `IProfiler : IUnknown`                | `getEntryCount; getEntryName; getEntryTimeMS; getEntryInvocationTimes`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | **keep**, including platform C `long`.                                                                                                                                                       |
| `IComponentType : IUnknown`           | `getSession; getLayout; getSpecializationParamCount; getEntryPointCode; getResultAsFileSystem; getEntryPointHash; specialize; link; getEntryPointHostCallable; renameEntryPoint; linkWithOptions; getTargetCode; getTargetMetadata; getEntryPointMetadata`                                                                                                                                                                                                                                                                                                                                                                                                                                                           | **correct** `getEntryPointHash` return from `Result` to `void`. Other binary signatures/order keep; input arrays gain `const` only. Host-callable indices are C `int`/`i32`, not `SlangInt`. |
| `IEntryPoint : IComponentType`        | `getFunctionReflection`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | **keep**.                                                                                                                                                                                    |
| `ITypeConformance : IComponentType`   | no new slots                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | **keep**.                                                                                                                                                                                    |
| `IComponentType2 : IUnknown`          | `getTargetCompileResult; getEntryPointCompileResult; getTargetHostCallable`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | **append** `getTargetHostCallable(int, ISharedLibrary**, IBlob**)`.                                                                                                                          |
| `IModule : IComponentType`            | `findEntryPointByName; getDefinedEntryPointCount; getDefinedEntryPoint; serialize; writeToFile; getName; getFilePath; getUniqueIdentity; findAndCheckEntryPoint; getDependencyFileCount; getDependencyFilePath; getModuleReflection; disassemble`                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | **keep**.                                                                                                                                                                                    |
| `ISession : IUnknown`                 | `getGlobalSession; loadModule; loadModuleFromSource; createCompositeComponentType; specializeType; getTypeLayout; getContainerType; getDynamicType; getTypeRTTIMangledName; getTypeConformanceWitnessMangledName; getTypeConformanceWitnessSequentialID; createCompileRequest; createTypeConformanceComponentType; loadModuleFromIRBlob; getLoadedModuleCount; getLoadedModule; isBinaryModuleUpToDate; loadModuleFromSourceString; getDynamicObjectRTTIBytes; loadModuleInfoFromIRBlob; getDeclSourceLocation`                                                                                                                                                                                                      | **append** `getDeclSourceLocation(DeclReflection*, SourceLocation*) -> Result`; existing slots keep. Correct typo-only Odin parameter `indxe`.                                               |
| `IMetadata : ICastable`               | `isParameterLocationUsed; getDebugBuildIdentifier`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | **keep**.                                                                                                                                                                                    |
| `ICompileResult : ICastable`          | `getItemCount; getItemData; getMetadata`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | **keep**.                                                                                                                                                                                    |
| `IGlobalSession : IUnknown`           | `createSession; findProfile; setDownstreamCompilerPath; setDownstreamCompilerPrelude; getDownstreamCompilerPrelude; getBuildTagString; setDefaultDownstreamCompiler; getDefaultDownstreamCompiler; setLanguagePrelude; getLanguagePrelude; createCompileRequest; addBuiltins; setSharedLibraryLoader; getSharedLibraryLoader; checkCompileTargetSupport; checkPassThroughSupport; compileCoreModule; loadCoreModule; saveCoreModule; findCapability; setDownstreamCompilerForTransition; getDownstreamCompilerForTransition; getCompilerElapsedTime; setSPIRVCoreGrammar; parseCommandLineArguments; getSessionDescDigest; compileBuiltinModule; loadBuiltinModule; saveBuiltinModule; getDownstreamCompilerVersion` | **correct** `saveBuiltinModule` to `(module, archiveType, outBlob)`; **append** `getDownstreamCompilerVersion(passThrough, ^i32 major, ^i32 minor) -> Result`. Earlier slots keep.           |

`ICompileRequest : IUnknown` remains an 80-method deprecated interface with no vtable additions or
reordering between the comparison tags. Its exact audited slot inventory is:

```text
setFileSystem; setCompileFlags; getCompileFlags; setDumpIntermediates;
setDumpIntermediatePrefix; setLineDirectiveMode; setCodeGenTarget; addCodeGenTarget;
setTargetProfile; setTargetFlags; setTargetFloatingPointMode; setTargetMatrixLayoutMode;
setMatrixLayoutMode; setDebugInfoLevel; setOptimizationLevel; setOutputContainerFormat;
setPassThrough; setDiagnosticCallback; setWriter; getWriter; addSearchPath;
addPreprocessorDefine; processCommandLineArguments; addTranslationUnit; setDefaultModuleName;
addTranslationUnitPreprocessorDefine; addTranslationUnitSourceFile;
addTranslationUnitSourceString; addLibraryReference; addTranslationUnitSourceStringSpan;
addTranslationUnitSourceBlob; addEntryPoint; addEntryPointEx; setGlobalGenericArgs;
setTypeNameForGlobalExistentialTypeParam; setTypeNameForEntryPointExistentialTypeParam;
setAllowGLSLInput; compile; getDiagnosticOutput; getDiagnosticOutputBlob;
getDependencyFileCount; getDependencyFilePath; getTranslationUnitCount; getEntryPointSource;
getEntryPointCode; getEntryPointCodeBlob; getEntryPointHostCallable; getTargetCodeBlob;
getTargetHostCallable; getCompileRequestCode; getCompileRequestResultAsFileSystem;
getContainerCode; loadRepro; saveRepro; enableReproCapture; getProgram; getEntryPoint;
getModule; getSession; getReflection; addTargetCapability; getProgramWithEntryPoints;
isParameterLocationUsed; setTargetLineDirectiveMode; setTargetForceGLSLScalarBufferLayout;
overrideDiagnosticSeverity; getDiagnosticFlags; setDiagnosticFlags; setDebugInfoFormat;
setEnableEffectAnnotations; setReportDownstreamTime; setReportPerfBenchmark;
setSkipSPIRVValidation; setTargetUseMinimumSlangOptimization; setIgnoreCapabilityCheck;
getCompileTimeProfile; setTargetGenerateWholeProgram; setTargetForceDXLayout;
setTargetEmbedDownstreamIR; setTargetForceCLayout
```

Its current parameter widths, pointer depths, return types, and `system` convention match the
target. Input array/string `const` changes are source-only.

## Standalone export ledger

Standalone exports use the C calling convention.

| Current export                                    | Exact target action                                                                                                               |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `slang_createBlob(const void*, size_t) -> IBlob*` | **keep**.                                                                                                                         |
| `slang_loadModuleFromSource`                      | **correct** to `(ISession*, moduleName, path, const char* source, size_t, IBlob**) -> IModule*`; current Odin omits `moduleName`. |
| `slang_loadModuleFromIRBlob`                      | **correct** source from `cstring` to `const void*`/`rawptr`; remaining parameters keep.                                           |
| `slang_loadModuleInfoFromIRBlob`                  | **keep** pointer/reference ABI.                                                                                                   |
| `slang_createGlobalSession`                       | **keep** `(SlangInt, IGlobalSession**) -> Result`.                                                                                |
| `slang_createGlobalSession2`                      | **keep** pointer-to-const descriptor ABI.                                                                                         |
| `slang_shutdown`                                  | **keep**.                                                                                                                         |
| `slang_getLastInternalErrorMessage`               | **keep**.                                                                                                                         |

The existing raw surface intentionally does not add `slang_createGlobalSessionWithoutCoreModule`,
`slang_getEmbeddedCoreModule`, coverage-manifest serialization, record/replay controls, or VM
entry points. They are independent exports and are unnecessary for the V1 flow.

## Raw reflection export ledger

The current foreign block contains 176 names. Unless called out after the inventory, each name and
its target parameter/return widths and pointer depth match a callable `v2026.16.1` declaration on
the supported 64-bit targets. All use the C calling convention.

### Variable, type, program, and attribute (40)

```text
ReflectionVariable_GetName; ReflectionVariable_GetType; ReflectionVariable_FindModifier;
ReflectionVariable_GetUserAttributeCount; ReflectionVariable_GetUserAttribute;
ReflectionVariable_FindUserAttributeByName; ReflectionVariable_HasDefaultValue;
ReflectionVariable_GetDefaultValueInt; ReflectionVariable_GetGenericContainer;
ReflectionVariable_applySpecializations;
ReflectionType_GetName; ReflectionType_GetFullName; ReflectionType_GetGenericContainer;
ReflectionType_GetResourceResultType; ReflectionType_GetKind; ReflectionType_GetFieldCount;
ReflectionType_GetFieldByIndex; ReflectionType_GetElementCount;
ReflectionType_GetSpecializedElementCount; ReflectionType_GetElementType;
ReflectionType_GetRowCount; ReflectionType_GetColumnCount; ReflectionType_GetScalarType;
ReflectionType_GetUserAttributeCount; ReflectionType_GetResourceShape;
ReflectionType_GetResourceAccess; ReflectionType_getSpecializedTypeArgCount;
ReflectionType_getSpecializedTypeArgType;
Reflection_FindFunctionByName; Reflection_FindFunctionByNameInType;
Reflection_FindVarByNameInType; Reflection_FindTypeByName;
Reflection_TryResolveOverloadedFunction; Reflection_isSubType; Reflection_GetTypeLayout;
ReflectionUserAttribute_GetName; ReflectionUserAttribute_GetArgumentCount;
ReflectionUserAttribute_GetArgumentValueInt; ReflectionUserAttribute_GetArgumentValueFloat;
ReflectionUserAttribute_GetArgumentValueString
```

### Type layout (51)

```text
ReflectionTypeLayout_GetType; ReflectionTypeLayout_getKind; ReflectionTypeLayout_GetSize;
ReflectionTypeLayout_GetStride; ReflectionTypeLayout_getAlignment;
ReflectionTypeLayout_GetFieldByIndex; ReflectionTypeLayout_findFieldIndexByName;
ReflectionTypeLayout_GetExplicitCounter; ReflectionTypeLayout_GetElementStride;
ReflectionTypeLayout_GetElementTypeLayout; ReflectionTypeLayout_GetElementVarLayout;
ReflectionTypeLayout_getContainerVarLayout; ReflectionTypeLayout_GetParameterCategory;
ReflectionTypeLayout_GetFieldCount; ReflectionTypeLayout_GetCategoryCount;
ReflectionTypeLayout_GetCategoryByIndex; ReflectionTypeLayout_GetMatrixLayoutMode;
ReflectionTypeLayout_getGenericParamIndex; ReflectionTypeLayout_getPendingDataTypeLayout;
ReflectionTypeLayout_getSpecializedTypePendingDataVarLayout;
ReflectionTypeLayout_getBindingRangeCount; ReflectionTypeLayout_getBindingRangeType;
ReflectionTypeLayout_isBindingRangeSpecializable;
ReflectionTypeLayout_getBindingRangeBindingCount;
ReflectionTypeLayout_getBindingRangeLeafTypeLayout;
ReflectionTypeLayout_getBindingRangeLeafVariable;
ReflectionTypeLayout_getBindingRangeImageFormat;
ReflectionTypeLayout_getBindingRangeDescriptorSetIndex;
ReflectionTypeLayout_getBindingRangeFirstDescriptorRangeIndex;
ReflectionTypeLayout_getBindingRangeDescriptorRangeCount;
ReflectionTypeLayout_getDescriptorSetCount;
ReflectionTypeLayout_getDescriptorSetSpaceOffset;
ReflectionTypeLayout_getDescriptorSetDescriptorRangeCount;
ReflectionTypeLayout_getDescriptorSetDescriptorRangeIndexOffset;
ReflectionTypeLayout_getDescriptorSetDescriptorRangeDescriptorCount;
ReflectionTypeLayout_getDescriptorSetDescriptorRangeType;
ReflectionTypeLayout_getDescriptorSetDescriptorRangeCategory;
ReflectionTypeLayout_getSubObjectRangeSpaceOffset;
ReflectionTypeLayout_getSubObjectRangeOffset;
ReflectionTypeLayout_getBindingRangeSubObjectRangeIndex;
ReflectionTypeLayout_getFieldBindingRangeOffset;
ReflectionTypeLayout_getExplicitCounterBindingRangeOffset;
ReflectionTypeLayout_getSubObjectRangeCount;
ReflectionTypeLayout_getSubObjectRangeObjectCount;
ReflectionTypeLayout_getSubObjectRangeBindingRangeIndex;
ReflectionTypeLayout_getSubObjectRangeTypeLayout;
ReflectionTypeLayout_getSubObjectRangeDescriptorRangeCount;
ReflectionTypeLayout_getSubObjectRangeDescriptorRangeBindingType;
ReflectionTypeLayout_getSubObjectRangeDescriptorRangeBindingCount;
ReflectionTypeLayout_getSubObjectRangeDescriptorRangeIndexOffset;
ReflectionTypeLayout_getSubObjectRangeDescriptorRangeSpaceOffset
```

### Variable layout, function, declaration, and generic (48)

```text
ReflectionVariableLayout_GetVariable; ReflectionVariableLayout_GetTypeLayout;
ReflectionVariableLayout_GetOffset; ReflectionVariableLayout_GetSpace;
ReflectionVariableLayout_GetImageFormat; ReflectionVariableLayout_GetSemanticName;
ReflectionVariableLayout_GetSemanticIndex; ReflectionVariableLayout_getStage;
ReflectionVariableLayout_getPendingDataLayout;
ReflectionFunction_asDecl; ReflectionFunction_GetName; ReflectionFunction_GetResultType;
ReflectionFunction_FindModifier; ReflectionFunction_GetUserAttributeCount;
ReflectionFunction_GetUserAttribute; ReflectionFunction_FindUserAttributeByName;
ReflectionFunction_GetParameterCount; ReflectionFunction_GetParameter;
ReflectionFunction_GetGenericContainer; ReflectionFunction_applySpecializations;
ReflectionFunction_specializeWithArgTypes; ReflectionFunction_isOverloaded;
ReflectionFunction_getOverloadCount; ReflectionFunction_getOverload;
Reflection_getTypeFromDecl; ReflectionDecl_findModifier; ReflectionDecl_getChildrenCount;
ReflectionDecl_getChild; ReflectionDecl_getName; ReflectionDecl_getKind;
ReflectionDecl_castToFunction; ReflectionDecl_castToVariable; ReflectionDecl_castToGeneric;
ReflectionDecl_getParent;
ReflectionGeneric_asDecl; ReflectionGeneric_GetName; ReflectionGeneric_GetTypeParameterCount;
ReflectionGeneric_GetTypeParameter; ReflectionGeneric_GetValueParameterCount;
ReflectionGeneric_GetValueParameter; ReflectionGeneric_GetTypeParameterConstraintCount;
ReflectionGeneric_GetTypeParameterConstraintType; ReflectionGeneric_GetInnerKind;
ReflectionGeneric_GetInnerDecl; ReflectionGeneric_GetOuterGenericContainer;
ReflectionGeneric_GetConcreteType; ReflectionGeneric_GetConcreteIntVal;
ReflectionGeneric_applySpecializations
```

### Parameter, entry-point, type-parameter, program, hash, and JSON (37)

```text
ReflectionParameter_GetBindingIndex; ReflectionParameter_GetBindingSpace;
IsParameterLocationUsed;
ReflectionEntryPoint_getName; ReflectionEntryPoint_getNameOverride;
ReflectionEntryPoint_getFunction; ReflectionEntryPoint_getParameterCount;
ReflectionEntryPoint_getParameterByIndex; ReflectionEntryPoint_getStage;
ReflectionEntryPoint_getComputeThreadGroupSize; ReflectionEntryPoint_getComputeWaveSize;
ReflectionEntryPoint_usesAnySampleRateInput; ReflectionEntryPoint_getVarLayout;
ReflectionEntryPoint_getResultVarLayout; ReflectionEntryPoint_hasDefaultConstantBuffer;
ReflectionTypeParameter_GetName; ReflectionTypeParameter_GetIndex;
ReflectionTypeParameter_GetConstraintCount; ReflectionTypeParameter_GetConstraintByIndex;
Reflection_GetParameterCount; Reflection_GetParameterByIndex;
Reflection_getGlobalParamsVarLayout; Reflection_GetTypeParameterCount;
Reflection_GetTypeParameterByIndex; Reflection_FindTypeParameter;
Reflection_getEntryPointCount; Reflection_getEntryPointByIndex;
Reflection_findEntryPointByName; Reflection_getGlobalConstantBufferBinding;
Reflection_getGlobalConstantBufferSize; Reflection_specializeType;
Reflection_specializeGeneric; Reflection_getHashedStringCount;
Reflection_getHashedString; ComputeStringHash; Reflection_getGlobalParamsTypeLayout;
Reflection_ToJson
```

The four inventory groups reproduce all 176 current declarations. The heading counts are
descriptive group sizes, not ABI constants.

Required reflection corrections:

- **Correct required receiver parameters** on
  `ReflectionTypeLayout_getPendingDataTypeLayout(^TypeLayoutReflection)`,
  `ReflectionTypeLayout_getSpecializedTypePendingDataVarLayout(^TypeLayoutReflection)`, and
  `ReflectionVariableLayout_getPendingDataLayout(^VariableLayoutReflection)`. These exports remain
  declared; they are not removals.
- **Correct pointer-to-pointer arrays** for `ReflectionFunction_specializeWithArgTypes` and
  `Reflection_specializeType`. Correct `Reflection_specializeGeneric` to use
  `^ReflectionGenericArgType` plus the corrected `^SlangReflectionGenericArg` union.
- Use literal `^i64` for `ReflectionUserAttribute_GetArgumentValueInt` instead of pointer-sized
  `^int` (same binary width on the supported 64-bit targets, but not a literal declaration).
- **Correct** `ReflectionEntryPoint_usesAnySampleRateInput` and
  `ReflectionEntryPoint_hasDefaultConstantBuffer` return types from Odin pointer-sized `int` to C
  `int`/`i32`.
- **Remove eight non-exports**:
  `ReflectionTypeLayout_getBindingRangeSubObjectRangeIndex` is absent, while
  `ReflectionTypeLayout_getSubObjectRangeObjectCount`,
  `ReflectionTypeLayout_getSubObjectRangeTypeLayout`, and the five
  `ReflectionTypeLayout_getSubObjectRangeDescriptorRange*` names are inside upstream `#if 0` and
  therefore are not callable declarations.
- **Add** `ReflectionVariable_GetDefaultValueFloat` (target addition matching the exposed integer
  accessor) and `Reflection_getBindlessSpaceIndex` (target program-layout query).
- `ReflectionDecl_findModifier` is a target addition already present in the Odin block and should
  remain.

## Intentionally excluded target additions

The following are separate interfaces/data models/exports, not new slots in an already bound base:

```text
IBindlessResourceMetadata
ICoverageTracingMetadata and coverage entry/buffer structs
ISyntheticResourceMetadata and synthetic resource structs
ICooperativeTypesMetadata and cooperative matrix/vector structs
IModulePrecompileService_Experimental
IByteCodeRunner and VM operand/instruction structs
record/replay standalone control exports
```

They are excluded because the V1 contract is embedded source-to-SPIR-V compilation, diagnostics,
and established program reflection. Omitting them cannot corrupt an existing vtable. If later
bound, each requires its own complete base/vtable and data-layout audit.

## Phase 2/3 execution checklist

1. Apply every **correct**, **append/add**, and **remove** action above without reordering stable
   slots or enum values.
2. Keep ABI declarations literal; place aliases and spelling improvements outside raw declarations.
3. Add the exact-header C++ size/alignment/offset probe and matching Odin compile-time assertions.
4. Run `odin check slang -no-entry-point` after core edits and again after reflection edits.
5. Do not treat a declaration found inside `#if 0` or only as a C++ inline helper as an exported ABI.
