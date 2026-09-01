package slang

import "core:c"

when ODIN_OS == .Windows {
	foreign import libslang "lib/slang-compiler.lib"
}

when ODIN_OS == .Darwin {
	foreign import libslang "lib/libslang-compiler.dylib"
}

when ODIN_OS == .Linux {
	foreign import libslang "lib/libslang-compiler.so"
}

// SlangInt and SlangUInt are explicitly pointer-sized in slang.h.
Int :: int
UInt :: uint
Bool :: bool
Result :: i32

API_VERSION :: 0
BOUND_SLANG_VERSION :: "2026.16.1"

IUnknown_UUID := UUID{0x00000000, 0x0000, 0x0000, {0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46}}


PassThrough :: enum i32 {
	None          = 0,
	FXC           = 1,
	DXC           = 2,
	GLSLANG       = 3,
	SPIRV_DIS     = 4,
	CLANG         = 5,
	VISUAL_STUDIO = 6,
	GCC           = 7,
	GENERIC_C_CPP = 8,
	NVRTC         = 9,
	LLVM          = 10,
	SPIRV_OPT     = 11,
	METAL         = 12,
	TINT          = 13,
	SPIRV_LINK    = 14,
	COUNT_OF      = 15,
}


CompileTarget :: enum i32 {
	UNKNOWN                           = 0,
	None                              = 1,
	GLSL                              = 2,
	GLSL_VULKAN_DEPRECATED            = 3,
	GLSL_VULKAN_ONE_DESC_DEPRECATED   = 4,
	HLSL                              = 5,
	SPIRV                             = 6,
	SPIRV_ASM                         = 7,
	DXBC                              = 8,
	DXBC_ASM                          = 9,
	DXIL                              = 10,
	DXIL_ASM                          = 11,
	C_SOURCE                          = 12,
	CPP_SOURCE                        = 13,
	HOST_EXECUTABLE                   = 14,
	SHADER_SHARED_LIBRARY             = 15,
	SHADER_HOST_CALLABLE              = 16,
	CUDA_SOURCE                       = 17,
	PTX                               = 18,
	CUDA_OBJECT_CODE                  = 19,
	OBJECT_CODE                       = 20,
	HOST_CPP_SOURCE                   = 21,
	HOST_HOST_CALLABLE                = 22,
	CPP_PYTORCH_BINDING               = 23,
	CPP_PYTORCH_BINDINGS              = CPP_PYTORCH_BINDING, // compatibility alias
	METAL                             = 24,
	METAL_LIB                         = 25,
	METAL_LIB_ASM                     = 26,
	HOST_SHARED_LIBRARY               = 27,
	WGSL                              = 28,
	WGSL_SPIRV_ASM                    = 29,
	WGSL_SPIRV                        = 30,
	HOST_VM                           = 31,
	CPP_HEADER                        = 32,
	CUDA_HEADER                       = 33,
	HOST_OBJECT_CODE                  = 34,
	HOST_LLVM_IR                      = 35,
	SHADER_LLVM_IR                    = 36,
	COUNT_OF                          = 37,
}

ContainerFormat :: enum i32 {
	NONE                          = 0,
	CONTAINER_FORMAT_SLANG_MODULE = 1,
}

ArchiveType :: enum i32 {
	UNDEFINED    = 0,
	ZIP          = 1,
	RIFF         = 2,
	RIFF_DEFLATE = 3,
	RIFF_LZ4     = 4,
	COUNT_OF     = 5,
}

// These values are bit positions; the compile-time assertions below verify the ABI masks.
CompileFlag :: enum u32 {
	NO_MANGLING = 3,
	NO_CODEGEN  = 4,
	OBFUSCATE   = 5,
	// NO_CHECKING = 0,
	// SPLIT_MIXED_TYPES = 0,
}
CompileFlags :: bit_set[CompileFlag; u32]

TargetFlag :: enum u32 {
	/* [deprecated] */ PARAMETER_BLOCK_USE_REGISTER_SPACE = 4, // This behavior is now enabled unconditionally
	GENERATE_WHOLE_PROGRAM = 8,
	DUMP_IR = 9,
	GENERATE_SPIRV_DIRECTLY = 10,
}
TargetFlags :: bit_set[TargetFlag; u32]

kDefaultTargetFlags :: TargetFlags {
	.GENERATE_SPIRV_DIRECTLY,
}

FloatingPointMode :: enum u32 {
	DEFAULT = 0,
	FAST    = 1,
	PRECISE = 2,
}

FpDenormalMode :: enum u32 {
	ANY      = 0,
	PRESERVE = 1,
	FTZ      = 2,
}

LineDirectiveMode :: enum u32 {
	DEFAULT    = 0,
	NONE       = 1,
	STANDARD   = 2,
	GLSL       = 3,
	SOURCE_MAP = 4,
}

SourceLanguage :: enum i32 {
	Unknown  = 0,
	SLANG    = 1,
	HLSL     = 2,
	GLSL     = 3,
	C        = 4,
	CPP      = 5,
	CUDA     = 6,
	SPIRV    = 7,
	METAL    = 8,
	WGSL     = 9,
	LLVM     = 10,
	COUNT_OF = 11,
}

ProfileID :: enum u32 {
	Unknown = 0,
}

CapabilityID :: enum i32 {
	UNKNOWN = 0,
}

MatrixLayoutMode :: enum u32 {
	UNKNOWN      = 0,
	ROW_MAJOR    = 1,
	COLUMN_MAJOR = 2,
}

Stage :: enum u32 {
	NONE           = 0,
	VERTEX         = 1,
	HULL           = 2,
	DOMAIN         = 3,
	GEOMETRY       = 4,
	FRAGMENT       = 5,
	COMPUTE        = 6,
	RAY_GENERATION = 7,
	INTERSECTION   = 8,
	ANY_HIT        = 9,
	CLOSEST_HIT    = 10,
	MISS           = 11,
	CALLABLE       = 12,
	MESH           = 13,
	AMPLIFICATION  = 14,
	DISPATCH       = 15,
	NODE           = 16,
	COUNT          = 17,
	PIXEL = FRAGMENT, // alias
}

DebugInfoLevel :: enum u32 {
	NONE     = 0,
	MINIMAL  = 1,
	STANDARD = 2,
	MAXIMAL  = 3,
}

DebugInfoFormat :: enum u32 {
	DEFAULT  = 0,
	C7       = 1,
	PDB      = 2,
	STABS    = 3,
	COFF     = 4,
	DWARF    = 5,
	COUNT_OF = 6,
}

OptimizationLevel :: enum u32 {
	NONE    = 0,
	DEFAULT = 1,
	HIGH    = 2,
	MAXIMAL = 3,
}

EmitSpirvMethod :: enum i32 {
	DEFAULT  = 0,
	VIA_GLSL = 1,
	DIRECTLY = 2,
}

EmitCPUMethod :: enum i32 {
	DEFAULT  = 0,
	VIA_CPP  = 1,
	VIA_LLVM = 2,
}

DiagnosticColor :: enum i32 {
	AUTO   = 0,
	ALWAYS = 1,
	NEVER  = 2,
}

WarningLevel :: enum i32 {
	DEFAULT  = 0,
	ALL      = 1,
	EXTRA    = 2,
	PEDANTIC = 3,
}

CompilerOptionName :: enum i32 {
	MacroDefine                       = 0,
	DepFile                           = 1,
	EntryPointName                    = 2,
	Specialize                       = 3,
	Help                             = 4,
	HelpStyle                        = 5,
	Include                          = 6,
	Language                         = 7,
	MatrixLayoutColumn               = 8,
	MatrixLayoutRow                  = 9,
	ZeroInitialize                   = 10,
	IgnoreCapabilities               = 11,
	RestrictiveCapabilityCheck       = 12,
	ModuleName                       = 13,
	Output                           = 14,
	Profile                          = 15,
	Stage                            = 16,
	Target                           = 17,
	Version                          = 18,
	WarningsAsErrors                 = 19,
	DisableWarnings                  = 20,
	EnableWarning                    = 21,
	DisableWarning                   = 22,
	DumpWarningDiagnostics           = 23,
	InputFilesRemain                 = 24,
	EmitIr                           = 25,
	ReportDownstreamTime             = 26,
	ReportPerfBenchmark              = 27,
	ReportCheckpointIntermediates    = 28,
	SkipSPIRVValidation              = 29,
	SourceEmbedStyle                 = 30,
	SourceEmbedName                  = 31,
	SourceEmbedLanguage              = 32,
	DisableShortCircuit              = 33,
	MinimumSlangOptimization         = 34,
	DisableNonEssentialValidations   = 35,
	DisableSourceMap                 = 36,
	UnscopedEnum                     = 37,
	PreserveParameters               = 38,
	Capability                       = 39,
	DefaultImageFormatUnknown        = 40,
	DisableDynamicDispatch           = 41,
	DisableSpecialization            = 42,
	FloatingPointMode                = 43,
	DebugInformation                 = 44,
	LineDirectiveMode                = 45,
	Optimization                     = 46,
	Obfuscate                        = 47,
	VulkanBindShift                  = 48,
	VulkanBindGlobals                = 49,
	VulkanInvertY                    = 50,
	VulkanUseDxPositionW             = 51,
	VulkanUseEntryPointName          = 52,
	VulkanUseGLLayout                = 53,
	VulkanEmitReflection             = 54,
	GLSLForceScalarLayout            = 55,
	EnableEffectAnnotations          = 56,
	EmitSpirvViaGLSL                 = 57,
	EmitSpirvDirectly                = 58,
	SPIRVCoreGrammarJSON             = 59,
	IncompleteLibrary                = 60,
	CompilerPath                     = 61,
	DefaultDownstreamCompiler        = 62,
	DownstreamArgs                   = 63,
	PassThrough                      = 64,
	DumpRepro                        = 65,
	DumpReproOnError                 = 66,
	ExtractRepro                     = 67,
	LoadRepro                        = 68,
	LoadReproDirectory               = 69,
	ReproFallbackDirectory           = 70,
	DumpAst                          = 71,
	DumpIntermediatePrefix           = 72,
	DumpIntermediates                = 73,
	DumpIr                           = 74,
	DumpIrIds                        = 75,
	PreprocessorOutput               = 76,
	OutputIncludes                   = 77,
	ReproFileSystem                  = 78,
	REMOVED_SerialIR                 = 79,
	SkipCodeGen                      = 80,
	ValidateIr                       = 81,
	VerbosePaths                     = 82,
	VerifyDebugSerialIr              = 83,
	NoCodeGen                        = 84,
	FileSystem                       = 85,
	Heterogeneous                    = 86,
	NoMangle                         = 87,
	NoHLSLBinding                    = 88,
	NoHLSLPackConstantBufferElements = 89,
	ValidateUniformity               = 90,
	AllowGLSL                        = 91,
	EnableExperimentalPasses         = 92,
	BindlessSpaceIndex               = 93,
	SPIRVResourceHeapStride          = 94,
	SPIRVSamplerHeapStride           = 95,
	ArchiveType                      = 96,
	CompileCoreModule                = 97,
	Doc                              = 98,
	IrCompression                    = 99,
	LoadCoreModule                   = 100,
	ReferenceModule                  = 101,
	SaveCoreModule                   = 102,
	SaveCoreModuleBinSource          = 103,
	TrackLiveness                    = 104,
	LoopInversion                    = 105,
	ParameterBlocksUseRegisterSpaces = 106,
	LanguageVersion                  = 107,
	TypeConformance                  = 108,
	EnableExperimentalDynamicDispatch = 109,
	EmitReflectionJSON               = 110,
	CountOfParsableOptions           = 111,
	DebugInformationFormat           = 112,
	VulkanBindShiftAll               = 113,
	GenerateWholeProgram             = 114,
	UseUpToDateBinaryModule          = 115,
	EmbedDownstreamIR                = 116,
	ForceDXLayout                    = 117,
	EmitSpirvMethod                  = 118,
	SaveGLSLModuleBinSource          = 119,
	SkipDownstreamLinking            = 120,
	DumpModule                       = 121,
	GetModuleInfo                    = 122,
	GetSupportedModuleVersions       = 123,
	EmitSeparateDebug                = 124,
	DenormalModeFp16                 = 125,
	DenormalModeFp32                 = 126,
	DenormalModeFp64                 = 127,
	UseMSVCStyleBitfieldPacking      = 128,
	ForceCLayout                     = 129,
	ExperimentalFeature              = 130,
	ReportDetailedPerfBenchmark      = 131,
	ValidateIRDetailed               = 132,
	DumpIRBefore                     = 133,
	DumpIRAfter                      = 134,
	EmitCPUMethod                    = 135,
	EmitCPUViaCPP                    = 136,
	EmitCPUViaLLVM                   = 137,
	LLVMTargetTriple                 = 138,
	LLVMCPU                          = 139,
	LLVMFeatures                     = 140,
	EnableRichDiagnostics            = 141,
	ReportDynamicDispatchSites       = 142,
	EnableMachineReadableDiagnostics = 143,
	DiagnosticColor                  = 144,
	TraceCoverage                    = 145,
	TraceCoverageBinding             = 146,
	TraceCoverageReservedSpace       = 147,
	TraceFunctionCoverage            = 148,
	TraceBranchCoverage              = 149,
	CoverageManifestOutput           = 150,
	TraceCoverageCounterByteWidth    = 151,
	TraceCoverageBoolean             = 152,
	CompilerVersion                  = 153,
	SPIRVUnifiedDescriptorHeapStride = 154,
	WarningLevel                     = 155,
	SeparateDebugInfoOutput          = 156,
	DebugInfoIncludeSource           = 157,
	TraceCoverageBindlessIndex       = 158,
	CountOf                          = 159,
}

CompilerOptionValueKind :: enum i32 {
	Int    = 0,
	String = 1,
}

CompileCoreModuleFlag :: enum u32 {
	WriteDocumentation = 0x1,
}

CompileCoreModuleFlags :: u32

FAILED :: #force_inline proc "contextless"(#any_int status: int) -> bool { return status < 0 }
SUCCEEDED :: #force_inline proc "contextless"(#any_int status: int) -> bool { return status >= 0 }
// Note(Dragos): is Result the correct type for these?
GET_RESULT_FACILITY :: #force_inline proc "contextless"(r: Result) -> i32 { return  (i32(r) >> 16) & 0x7fff }
GET_RESULT_CODE :: #force_inline proc "contextless"(r: Result) -> i32 { return i32(r) & 0xffff }

// TODO(Dragos): submit some issue related to i32(0x80000000)
// TODO(Dragos): check correctness of this, it seems fucked
MAKE_ERROR :: #force_inline proc "contextless"(fac: i32, code: i32) -> i32 { return (fac << 16) | i32(cast(u32)code | u32(0x80000000)) }
MAKE_SUCCESS :: #force_inline proc "contextless"(fac: i32, code: i32) -> i32 { return (fac << 16) | code }


// Note(Dragos): should we add an enum for these? Are these "macros" used often?
FACILITY_WIN_GENERAL :: 0
FACILITY_WIN_INTERFACE :: 4
FACILITY_WIN_API :: 7
FACILITY_BASE :: 0x200
FACILITY_CORE :: FACILITY_BASE
FACILITY_INTERNAL :: FACILITY_BASE + 1
FACILITY_EXTERNAL_BASE :: 0x210

OK :: 0
FAIL :: #force_inline proc "contextless"() -> i32 { return MAKE_ERROR(FACILITY_WIN_GENERAL, 0x4005) }
MAKE_WIN_GENERAL_ERROR :: #force_inline proc "contextless"(code: i32) -> i32 { return MAKE_ERROR(FACILITY_WIN_GENERAL, code)}

// Note(dragos): We can hardcode these and put them in an enum. This is not the way.
E_NOT_IMPLEMENTED :: #force_inline proc "contextless"() -> i32 { return MAKE_WIN_GENERAL_ERROR(0x4001) }
E_NO_INTERFACE :: #force_inline proc "contextless"() -> i32 { return MAKE_WIN_GENERAL_ERROR(0x4002) }
E_ABORT :: #force_inline proc "contextless"() ->  i32 { return MAKE_WIN_GENERAL_ERROR(0x4004) }
E_INVALID_HANDLE :: #force_inline proc "contextless"() -> i32 { return MAKE_ERROR(FACILITY_WIN_API, 6) }
E_INVALID_ARG :: #force_inline proc "contextless"() -> i32 { return MAKE_ERROR(FACILITY_WIN_API, 0x57) }
E_OUT_OF_MEMORY :: #force_inline proc "contextless"() -> i32 { return MAKE_ERROR(FACILITY_WIN_API, 0xe) }

MAKE_CORE_ERROR :: #force_inline proc "contextless"(code: i32) -> i32 { return MAKE_ERROR(FACILITY_CORE, code) }

E_BUFFER_TOO_SMALL :: #force_inline proc "contextless"() -> i32 { return MAKE_CORE_ERROR(1) }
E_UNINITIALIZED :: #force_inline proc "contextless"() -> i32 { return MAKE_CORE_ERROR(2) }
E_PENDING :: #force_inline proc "contextless"() -> i32 { return MAKE_CORE_ERROR(3) }
E_CANNOT_OPEN :: #force_inline proc "contextless"() -> i32 { return MAKE_CORE_ERROR(4) }
E_NOT_FOUND :: #force_inline proc "contextless"() -> i32 { return MAKE_CORE_ERROR(5) }
E_INTERNAL_FAIL :: #force_inline proc "contextless"() -> i32 { return MAKE_CORE_ERROR(6) }
E_NOT_AVAILABLE :: #force_inline proc "contextless"() -> i32 { return MAKE_CORE_ERROR(7) }
E_TIME_OUT :: #force_inline proc "contextless"() -> i32 { return MAKE_CORE_ERROR(8) }

CompilerOptionValue :: struct {
	kind: CompilerOptionValueKind,
	intValue0: i32,
	intValue1: i32,
	stringValue0: cstring,
	stringValue1: cstring,
}

CompilerOptionEntry :: struct {
	name: CompilerOptionName,
	value: CompilerOptionValue,
}

UUID :: struct {
	data1: u32,
	data2: u16,
	data3: u16,
	data4: [8]u8,
}

IUnknown :: struct {
	using vtable: ^IUnknown_VTable,
}

IUnknown_VTable :: struct {
	queryInterface: proc "system" (this: ^IUnknown, #by_ptr uuid: UUID, outObject: ^rawptr) -> Result,
	addRef        : proc "system" (this: ^IUnknown) -> u32,
	release       : proc "system" (this: ^IUnknown) -> u32,
}

ICastable :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using vtable: ^ICastable_VTable,
}

ICastable_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	castAs: proc "system" (this: ^ICastable, #by_ptr guid: UUID) -> rawptr,
}

IClonable :: struct #raw_union {
	#subtype icastable: ICastable,
	using vtable: ^IClonable_VTable,
}

IClonable_VTable :: struct {
	using icastable_vtable: ICastable_VTable,
	clone: proc "system" (this: ^IClonable, #by_ptr guid: UUID) -> rawptr,
}

IBlob :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using vtable: ^struct {
		using iunknown_vtable: IUnknown_VTable,
		getBufferPointer: proc "system"(this: ^IBlob) -> rawptr,
		getBufferSize   : proc "system"(this: ^IBlob) -> uint,
	},
}

IFileSystem :: struct #raw_union {
	#subtype icastable: ICastable,
	using vtable: ^IFileSystem_VTable,
}

IFileSystem_VTable :: struct {
	using icastable_vtable: ICastable_VTable,
	loadFile: proc "system"(this: ^IFileSystem, path: cstring, outBlob: ^^IBlob) -> Result,
}

// Todo(Dragos): Should this be a rawptr?
FuncPtr :: #type proc "c"()

// TODO(Dragos): findFuncByName is a FORCE_INLINE with no stdcall calconv. Does that mean it's not part of the COM interface?
ISharedLibrary :: struct #raw_union {
	#subtype icastable: ICastable,
	using vtable: ^struct {
		using icastable_vtable: ICastable_VTable,
		findSymbolAddressByName: proc "system"(this: ^ISharedLibrary, name: cstring) -> rawptr,
	},
}

ISharedLibraryLoader :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using vtable: ^struct {
		using iunknown_vtable: IUnknown_VTable,
		loadSharedLibrary: proc "system" (this: ^ISharedLibraryLoader, path: cstring, sharedLibraryOut: ^^ISharedLibrary) -> Result,
	},
}

PathType :: enum u32 {
	DIRECTORY = 0,
	FILE      = 1,
}

FileSystemContentsCallback :: #type proc "c"(pathType: PathType, name: cstring, userData: rawptr)

OSPathKind :: enum u8 {
	None            = 0,
	Direct          = 1,
	OperatingSystem = 2,
}

PathKind :: enum i32 {
	Simplified      = 0,
	Canonical       = 1,
	Display         = 2,
	OperatingSystem = 3,
	CountOf         = 4,
}

// TODO(Dragos): should we replace #subtype with using?
IFileSystemExt :: struct #raw_union {
	#subtype ifilesystem: IFileSystem,
	using vtable: ^IFileSystemExt_VTable,
}

IFileSystemExt_VTable :: struct {
	using ifilesystem_vtable: IFileSystem_VTable,
	getFileUniqueIdentity: proc "system"(this: ^IFileSystemExt, path: cstring, outUniqueIdentity: ^^IBlob) -> Result,
	calcCombinedPath     : proc "system"(this: ^IFileSystemExt, fromPathType: PathType, fromPath, path: cstring, pathOut: ^^IBlob) -> Result,
	getPathType          : proc "system"(this: ^IFileSystemExt, path: cstring, pathTypeOut: ^PathType) -> Result,
	getPath              : proc "system"(this: ^IFileSystemExt, kind: PathKind, path: cstring, outPath: ^^IBlob) -> Result,
	clearCache           : proc "system"(this: ^IFileSystemExt),
	enumeratePathContents: proc "system"(this: ^IFileSystemExt, path: cstring, callback: FileSystemContentsCallback, userData: rawptr) -> Result,
	getOSPathKind        : proc "system"(this: ^IFileSystemExt) -> OSPathKind,
}

IMutableFileSystem :: struct #raw_union {
	#subtype ifilesystext: IFileSystemExt,
	using vtable: ^struct {
		using ifilesystemext_vtable: IFileSystemExt_VTable,
		saveFile       : proc "system"(this: ^IMutableFileSystem, path: cstring, data: rawptr, size: uint) -> Result,
		saveFileBlob   : proc "system"(this: ^IMutableFileSystem, path: cstring, dataBlob: ^IBlob) -> Result,
		remove         : proc "system"(this: ^IMutableFileSystem, path: cstring) -> Result,
		createDirectory: proc "system"(this: ^IMutableFileSystem, path: cstring) -> Result,
	},
}

WriterChannel :: enum u32 {
	DIAGNOSTIC = 0,
	STD_OUTPUT = 1,
	STD_ERROR  = 2,
	COUNT_OF   = 3,
}

WriterMode :: enum u32 {
	TEXT   = 0,
	BINARY = 1,
}

IWriter :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using vtable: ^struct {
		using iunknown_vtable: IUnknown_VTable,
		beginAppendBuffer: proc "system"(this: ^IWriter, maxNumChars: uint) -> [^]byte,
		endAppendBuffer  : proc "system"(this: ^IWriter, buffer: [^]byte, numChars: uint) -> Result,
		write            : proc "system"(this: ^IWriter, chars: [^]byte, numChars: uint) -> Result,
		flush            : proc "system"(this: ^IWriter),
		isConsole        : proc "system"(this: ^IWriter) -> Bool,
		setMode          : proc "system"(this: ^IWriter, mode: WriterMode) -> Result,
	},
}

IProfiler :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using vtable: ^struct {
		using iunknown_vtable: IUnknown_VTable,
		getEntryCount: proc "system"(this: ^IProfiler) -> uint,
		getEntryName: proc "system"(this: ^IProfiler, index: u32) -> cstring,
		getEntryTimeMS: proc "system"(this: ^IProfiler, index: u32) -> c.long,
		getEntryInvocationTimes: proc "system"(this: ^IProfiler, index: u32) -> u32,
	},
}

DiagnosticCallback :: #type proc "c"(message: cstring, userData: rawptr)



IComponentType :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using vtable: ^IComponentType_VTable,
}

IComponentType_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	getSession                 : proc "system"(this: ^IComponentType) -> ^ISession,
	getLayout                  : proc "system"(this: ^IComponentType, targetIndex: Int, outDiagnostics: ^^IBlob) -> ^ProgramLayout,
	getSpecializationParamCount: proc "system"(this: ^IComponentType) -> Int,
	getEntryPointCode          : proc "system"(this: ^IComponentType, entryPointIndex: Int, targetIndex: Int, outCode: ^^IBlob, outDiagnostics: ^^IBlob) -> Result,
	getResultAsFileSystem      : proc "system"(this: ^IComponentType, entryPointIndex: Int, targetIndex: Int, outFileSystem: ^^IMutableFileSystem) -> Result,
	getEntryPointHash          : proc "system"(this: ^IComponentType, entryPointIndex, targetIndex: Int, outHash: ^^IBlob),
	specialize                 : proc "system"(this: ^IComponentType, specializationArgs: [^]SpecializationArg, specializationArgCount: Int, outSpecializedComponentType: ^^IComponentType, outDiagnostics: ^^IBlob) -> Result,
	link                       : proc "system"(this: ^IComponentType, outLinkedComponentType: ^^IComponentType, outDiagnostics: ^^IBlob) -> Result,
	getEntryPointHostCallable  : proc "system"(this: ^IComponentType, entryPointIndex, targetIndex: i32, outSharedLibrary: ^^ISharedLibrary, outDiagnostics: ^^IBlob) -> Result,
	renameEntryPoint           : proc "system"(this: ^IComponentType, newName: cstring, outEntryPoint: ^^IComponentType) -> Result,
	linkWithOptions            : proc "system"(this: ^IComponentType, outLinkedComponentType: ^^IComponentType, compilerOptionEntryCount: u32, compilerOptionEntries: [^]CompilerOptionEntry, outDiagnostics: ^^IBlob) -> Result,
	getTargetCode              : proc "system"(this: ^IComponentType, targetIndex: Int, outCode: ^^IBlob, outDiagnostics: ^^IBlob) -> Result,
	getTargetMetadata          : proc "system"(this: ^IComponentType, targetIndex: Int, outMetadata: ^^IMetadata, outDiagnostics: ^^IBlob) -> Result,
	getEntryPointMetadata      : proc "system"(this: ^IComponentType, entryPointIndex: Int, targetIndex: Int, outMetadata: ^^IMetadata, outDiagnostics: ^^IBlob) -> Result,
}

IEntryPoint :: struct #raw_union {
	#subtype icomponenttype: IComponentType,
	using vtable: ^struct {
		using icomponenttype_vtable: IComponentType_VTable,
		getFunctionReflection: proc "system"(this: ^IEntryPoint) -> ^FunctionReflection,
	},
}

ITypeConformance :: struct #raw_union {
	#subtype icomponenttype: IComponentType,
	using vtable: ^struct {
		using icomponenttype_vtable: IComponentType_VTable,
	},
}

IComponentType2 :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using vtable: ^IComponentType2_VTable,
}

IComponentType2_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	getTargetCompileResult    : proc "system"(this: ^IComponentType2, targetIndex: Int, outCompileResult: ^^ICompileResult, outDiagnostics: ^^IBlob = nil) -> Result,
	getEntryPointCompileResult: proc "system"(this: ^IComponentType2, entryPointIndex: Int, targetIndex: Int, outCompileResult: ^^ICompileResult, outDiagnostics: ^^IBlob = nil) -> Result,
	getTargetHostCallable     : proc "system"(this: ^IComponentType2, targetIndex: i32, outSharedLibrary: ^^ISharedLibrary, outDiagnostics: ^^IBlob = nil) -> Result,
}

IModule :: struct #raw_union {
	#subtype icomponenttype: IComponentType,
	using vtable: ^struct {
		using icomponenttype_vtable: IComponentType_VTable,
		findEntryPointByName     : proc "system"(this: ^IModule, name: cstring, outEntryPoint: ^^IEntryPoint) -> Result,
		getDefinedEntryPointCount: proc "system"(this: ^IModule) -> i32,
		getDefinedEntryPoint     : proc "system"(this: ^IModule, index: i32, outEntryPoint: ^^IEntryPoint) -> Result,
		serialize                : proc "system"(this: ^IModule, outSerializedBlob: ^^IBlob) -> Result,
		writeToFile              : proc "system"(this: ^IModule, fileName: cstring) -> Result,
		getName                  : proc "system"(this: ^IModule) -> cstring,
		getFilePath              : proc "system"(this: ^IModule) -> cstring,
		getUniqueIdentity        : proc "system"(this: ^IModule) -> cstring,
		findAndCheckEntryPoint   : proc "system"(this: ^IModule, name: cstring, stage: Stage, outEntryPoint: ^^IEntryPoint, outDiagnostics: ^^IBlob) -> Result,
		getDependencyFileCount   : proc "system"(this: ^IModule) -> i32,
		getDependencyFilePath    : proc "system"(this: ^IModule, index: i32) -> cstring,
		getModuleReflection      : proc "system"(this: ^IModule) -> ^DeclReflection,
		disassemble              : proc "system"(this: ^IModule, outDisassembledBlob: ^^IBlob) -> Result,
	},
}

SpecializationArgKind :: enum i32 {
	Unknown = 0,
	Type    = 1,
	Expr    = 2,
}

SpecializationArg_fromType :: #force_inline proc "contextless"(inType: ^TypeReflection) -> (rs: SpecializationArg) {
	rs.kind = .Type
	rs.type = inType
	return rs
}

SpecializationArg_fromExpr :: #force_inline proc "contextless"(inExpr: cstring) -> (rs: SpecializationArg) {
	rs.kind = .Expr
	rs.expr = inExpr
	return rs
}

LanguageVersion :: enum i32 {
	UNKNOWN          = 0,
	LEGACY           = 2018,
	_202A            = 2025,
	_2025            = 2025,
	_202B            = 2026,
	_2026            = 2026,
	_202C            = 2027,
	LANGAUGE_DEFAULT = LEGACY, // upstream compatibility typo
	DEFAULT          = LEGACY,
	LATEST           = _2026,
	NEXT             = _202C,
}

// This must be constructed with the correct values. See `kGlobalSessionDescDefaultValues`.
GlobalSessionDesc :: struct {
	structureSize: u32, //= sizeof(SlangGlobalSessionDesc);
	/// Slang API version.
	apiVersion: u32, // = SLANG_API_VERSION;
	/// Specify the oldest Slang language version that any sessions will use.
	minLanguageVersion: u32, // = SLANG_LANGUAGE_VERSION_2025;
	/// Whether to enable GLSL support.
	enableGLSL: bool, // = false;
	/// Reserved for future use.
	reserved: [16]u32,
}
#assert(size_of(GlobalSessionDesc) == 80)

kGlobalSessionDescDefaultValues :: GlobalSessionDesc {
	structureSize      = size_of(GlobalSessionDesc),
	apiVersion         = API_VERSION,
	minLanguageVersion = u32(LanguageVersion._2025),
	enableGLSL         = false,
}


// TODO(Dragos): implement SpecializationArg::fromType
SpecializationArg :: struct {
	kind: SpecializationArgKind,
	using _: struct #raw_union {
		type: ^TypeReflection,
		expr: cstring,
	},
}

TargetDesc :: struct {
	structureSize              : uint,
	format                     : CompileTarget,
	profile                    : ProfileID,
	flags                      : TargetFlags,
	floatingPointMode          : FloatingPointMode,
	lineDirectiveMode          : LineDirectiveMode,
	forceGLSLScalarBufferLayout: bool,
	compilerOptionEntries      : [^]CompilerOptionEntry,
	compilerOptionEntryCount   : u32,
}

PreprocessorMacroDesc :: struct {
	name : cstring,
	value: cstring,
}

SessionFlags :: u32

SessionDesc :: struct {
	structureSize           : uint,
	targets                 : [^]TargetDesc,
	targetCount             : Int,
	flags                   : SessionFlags,
	defaultMatrixLayoutMode : MatrixLayoutMode,
	searchPaths             : [^]cstring,
	searchPathCount         : Int,
	preprocessorMacros      : [^]PreprocessorMacroDesc,
	preprocessorMacroCount  : Int,
	fileSystem              : ^IFileSystem,
	enableEffectAnnotations : bool,
	allowGLSLSyntax         : bool,
	compilerOptionEntries   : [^]CompilerOptionEntry,
	compilerOptionEntryCount: u32,
	skipSPIRVValidation     : bool,
}

ImageFormat :: enum u32 {
	unknown         = 0,
	rgba32f         = 1,
	rgba16f         = 2,
	rg32f           = 3,
	rg16f           = 4,
	r11f_g11f_b10f = 5,
	r32f            = 6,
	r16f            = 7,
	rgba16          = 8,
	rgb10_a2        = 9,
	rgba8           = 10,
	rg16            = 11,
	rg8             = 12,
	r16             = 13,
	r8              = 14,
	rgba16_snorm    = 15,
	rgba8_snorm     = 16,
	rg16_snorm      = 17,
	rg8_snorm       = 18,
	r16_snorm       = 19,
	r8_snorm        = 20,
	rgba32i         = 21,
	rgba16i         = 22,
	rgba8i          = 23,
	rg32i           = 24,
	rg16i           = 25,
	rg8i            = 26,
	r32i            = 27,
	r16i            = 28,
	r8i             = 29,
	rgba32ui        = 30,
	rgba16ui        = 31,
	rgb10_a2ui      = 32,
	rgba8ui         = 33,
	rg32ui          = 34,
	rg16ui          = 35,
	rg8ui           = 36,
	r32ui           = 37,
	r16ui           = 38,
	r8ui            = 39,
	r64ui           = 40,
	r64i            = 41,
	bgra8           = 42,
}

UNBOUNDED_SIZE :: ~uint(0)
UNKNOWN_SIZE   :: UNBOUNDED_SIZE - 1

LayoutRules :: enum u32 {
	DEFAULT                           = 0,
	METAL_ARGUMENT_BUFFER_TIER_2      = 1,
	DEFAULT_STRUCTURED_BUFFER         = 2,
	DEFAULT_CONSTANT_BUFFER           = 3,
}

ContainerType :: enum i32 {
	None             = 0,
	UnsizedArray     = 1,
	StructuredBuffer = 2,
	ConstantBuffer   = 3,
	ParameterBlock   = 4,
}

SourceLocation :: struct {
	filePath: cstring,
	line    : Int,
	column  : Int,
}


ISession :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using vtable: ^ISession_VTable,
}

ISession_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	getGlobalSession                     : proc "system"(this: ^ISession) -> ^IGlobalSession,
	loadModule                           : proc "system"(this: ^ISession, moduleName: cstring, outDiagnostics: ^^IBlob) -> ^IModule,
	loadModuleFromSource                 : proc "system"(this: ^ISession, moduleName: cstring, path: cstring, source: ^IBlob, outDiagnostics: ^^IBlob) -> ^IModule,
	createCompositeComponentType         : proc "system"(this: ^ISession, componentTypes: [^]^IComponentType, componentTypeCount: Int, outCompositeComponentType: ^^IComponentType, outDiagnostics: ^^IBlob) -> Result,
	specializeType                       : proc "system"(this: ^ISession, type: ^TypeReflection, specializationArgs: [^]SpecializationArg, specializationArgCount: Int, outDiagnostics: ^^IBlob) -> ^TypeReflection,
	getTypeLayout                        : proc "system"(this: ^ISession, type: ^TypeReflection, targetIndex: Int, rules: LayoutRules, outDiagnostics: ^^IBlob) -> ^TypeLayoutReflection,
	getContainerType                     : proc "system"(this: ^ISession, elementType: ^TypeReflection, containerType: ContainerType, outDiagnostics: ^^IBlob) -> ^TypeReflection,
	getDynamicType                       : proc "system"(this: ^ISession) -> ^TypeReflection,
	getTypeRTTIMangledName               : proc "system"(this: ^ISession, type: ^TypeReflection, outNameBlob: ^^IBlob) -> Result,
	getTypeConformanceWitnessMangledName : proc "system"(this: ^ISession, type: ^TypeReflection, interfaceType: ^TypeReflection, outNameBlob: ^^IBlob) -> Result,
	getTypeConformanceWitnessSequentialID: proc "system"(this: ^ISession, type: ^TypeReflection, interfaceType: ^TypeReflection, outId: ^u32) -> Result,
	createCompileRequest                 : proc "system"(this: ^ISession, outCompileRequest: ^^ICompileRequest) -> Result,
	createTypeConformanceComponentType   : proc "system"(this: ^ISession, type: ^TypeReflection, interfaceType: ^TypeReflection, outConformance: ^^ITypeConformance, conformanceIdOverride: Int, outDiagnostics: ^^IBlob) -> Result,
	loadModuleFromIRBlob                 : proc "system"(this: ^ISession, moduleName: cstring, path: cstring, source: ^IBlob, outDiagnostics: ^^IBlob) -> ^IModule,
	getLoadedModuleCount                 : proc "system"(this: ^ISession) -> Int,
	getLoadedModule                      : proc "system"(this: ^ISession, index: Int) -> ^IModule,
	isBinaryModuleUpToDate               : proc "system"(this: ^ISession, modulePath: cstring, binaryModuleBlob: ^IBlob) -> bool,
	loadModuleFromSourceString           : proc "system"(this: ^ISession, moduleName, path, str: cstring, outDiagnostics: ^^IBlob) -> ^IModule,
	getDynamicObjectRTTIBytes            : proc "system"(this: ^ISession, type: ^TypeReflection, interfaceType: ^TypeReflection, outRTTIDataBuffer: ^u32, bufferSizeInBytes: u32) -> Result,
	loadModuleInfoFromIRBlob             : proc "system"(this: ^ISession, source: ^IBlob, outModuleVersion: ^Int, outModuleCompilerVersion: ^cstring, outModuleName: ^cstring) -> Result,
	getDeclSourceLocation                : proc "system"(this: ^ISession, decl: ^DeclReflection, outLocation: ^SourceLocation) -> Result,
}


IMetadata :: struct #raw_union {
	#subtype icastable: ICastable,
	using vtable: ^struct {
		using icastable_vtable: ICastable_VTable,
		isParameterLocationUsed: proc "system"(this: ^IMetadata, category: SlangParameterCategory, spaceIndex, registerIndex: UInt, outUsed: ^bool) -> Result,
		getDebugBuildIdentifier: proc "system"(this: ^IMetadata) -> cstring,
	},
}

ICompileResult :: struct #raw_union {
	#subtype icastable: ICastable,
	using vtable: ^struct {
		using icastable_vtable: ICastable_VTable,
		getItemCount           : proc "system"(this: ^ICompileResult) -> u32,
		getItemData            : proc "system"(this: ^ICompileResult, index: u32, outBlob: ^^IBlob) -> Result,
		getMetadata            : proc "system"(this: ^ICompileResult, outMetadata: ^^IMetadata) -> Result,
	},
}

BuiltinModuleName :: enum i32 {
	Core = 0,
	GLSL = 1,
}

IGlobalSession :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using vtable: ^IGlobalSession_VTable,
}

IGlobalSession_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	createSession                     : proc "system"(this: ^IGlobalSession, #by_ptr desc: SessionDesc, outSession: ^^ISession) -> Result,
	findProfile                       : proc "system"(this: ^IGlobalSession, name: cstring) -> ProfileID,
	setDownstreamCompilerPath         : proc "system"(this: ^IGlobalSession, passThrough: PassThrough, path: cstring),
	setDownstreamCompilerPrelude      : proc "system"(this: ^IGlobalSession, passThrough: PassThrough, preludeText: cstring),
	getDownstreamCompilerPrelude      : proc "system"(this: ^IGlobalSession, passThrough: PassThrough, outPrelude: ^^IBlob),
	getBuildTagString                 : proc "system"(this: ^IGlobalSession) -> cstring,
	setDefaultDownstreamCompiler      : proc "system"(this: ^IGlobalSession, sourceLanguage: SourceLanguage, defaultCompiler: PassThrough) -> Result,
	getDefaultDownstreamCompiler      : proc "system"(this: ^IGlobalSession, sourceLanguage: SourceLanguage) -> PassThrough,
	setLanguagePrelude                : proc "system"(this: ^IGlobalSession, sourceLanguage: SourceLanguage, preludeText: cstring),
	getLanguagePrelude                : proc "system"(this: ^IGlobalSession, sourceLanguage: SourceLanguage, outPrelude: ^^IBlob),
	createCompileRequest              : proc "system"(this: ^IGlobalSession, outCompilerRequest: ^^ICompileRequest) -> Result, /* deprecated */
	addBuiltins                       : proc "system"(this: ^IGlobalSession, sourcePath: cstring, sourceString: cstring),
	setSharedLibraryLoader            : proc "system"(this: ^IGlobalSession, loader: ^ISharedLibraryLoader),
	getSharedLibraryLoader            : proc "system"(this: ^IGlobalSession) -> ^ISharedLibraryLoader,
	checkCompileTargetSupport         : proc "system"(this: ^IGlobalSession, target: CompileTarget) -> Result,
	checkPassThroughSupport           : proc "system"(this: ^IGlobalSession, passThrough: PassThrough) -> Result,
	compileCoreModule                 : proc "system"(this: ^IGlobalSession, flags: CompileCoreModuleFlags) -> Result,
	loadCoreModule                    : proc "system"(this: ^IGlobalSession, coreModule: rawptr, coreModuleSizeInBytes: uint) -> Result,
	saveCoreModule                    : proc "system"(this: ^IGlobalSession, archiveType: ArchiveType, outBlob: ^^IBlob) -> Result,
	findCapability                    : proc "system"(this: ^IGlobalSession, name: cstring) -> CapabilityID,
	setDownstreamCompilerForTransition: proc "system"(this: ^IGlobalSession, source: CompileTarget, target: CompileTarget, compiler: PassThrough),
	getDownstreamCompilerForTransition: proc "system"(this: ^IGlobalSession, source, target: CompileTarget) -> PassThrough,
	getCompilerElapsedTime            : proc "system"(this: ^IGlobalSession, outTotalTime, outDownstreamTime: ^f64),
	setSPIRVCoreGrammar               : proc "system"(this: ^IGlobalSession, jsonPath: cstring) -> Result,
	parseCommandLineArguments         : proc "system"(this: ^IGlobalSession, argc: i32, argv: [^]cstring, outSessionDesc: ^SessionDesc, outAuxAllocation: ^^IUnknown) -> Result,
	getSessionDescDigest              : proc "system"(this: ^IGlobalSession, sessionDesc: ^SessionDesc, outBlob: ^^IBlob) -> Result,
	compileBuiltinModule              : proc "system"(this: ^IGlobalSession, module: BuiltinModuleName, flags: CompileCoreModuleFlags) -> Result,
	loadBuiltinModule                 : proc "system"(this: ^IGlobalSession, module: BuiltinModuleName, moduleData: rawptr, sizeInBytes: uint) -> Result,
	saveBuiltinModule                 : proc "system"(this: ^IGlobalSession, module: BuiltinModuleName, archiveType: ArchiveType, outBlob: ^^IBlob) -> Result,
	getDownstreamCompilerVersion      : proc "system"(this: ^IGlobalSession, passThrough: PassThrough, outMajor, outMinor: ^i32) -> Result,
}

@(link_prefix="slang_")
@(default_calling_convention="c")
foreign libslang {
	createBlob :: proc(data: rawptr, size: uint) -> ^IBlob ---
	loadModuleFromSource :: proc(session: ^ISession, moduleName, path: cstring, source: cstring, sourceSize: uint, outDiagnostics: ^^IBlob = nil) -> ^IModule ---
	loadModuleFromIRBlob :: proc(session: ^ISession, moduleName: cstring, path: cstring, source: rawptr, sourceSize: uint, outDiagnostics: ^^IBlob = nil) -> ^IModule ---
	loadModuleInfoFromIRBlob :: proc(session: ^ISession, source: rawptr, sourceSize: uint, outModuleVersion: ^Int, outModuleCompilerVersion: ^cstring, outModuleName: ^cstring) -> Result ---
	createGlobalSession :: proc(apiVersion: Int, outGlobalSession: ^^IGlobalSession) -> Result ---
	createGlobalSession2 :: proc(#by_ptr desc: GlobalSessionDesc, outGlobalSession: ^^IGlobalSession) -> Result ---
	shutdown :: proc() ---
	getLastInternalErrorMessage :: proc() -> cstring ---
}

// These constants and layouts are cross-checked by tests/abi_probe.cpp against the pinned header.
#assert(API_VERSION == 0)
#assert(size_of(Int) == size_of(rawptr) && size_of(UInt) == size_of(rawptr))
#assert(size_of(Bool) == 1 && size_of(Result) == 4)
#assert(size_of(CompileTarget) == 4 && size_of(Stage) == 4)
#assert(size_of(CompileFlags) == 4 && size_of(TargetFlags) == 4)
#assert(size_of(CompileCoreModuleFlags) == 4 && size_of(SessionFlags) == 4)
#assert(int(CompileTarget.COUNT_OF) == 37)
#assert(int(SourceLanguage.COUNT_OF) == 11)
#assert(int(Stage.COUNT) == 17)
#assert(int(LanguageVersion.NEXT) == 2027)
#assert(int(ImageFormat.bgra8) == 42)
#assert(int(LayoutRules.DEFAULT_CONSTANT_BUFFER) == 3)
#assert(int(CompilerOptionName.SPIRVResourceHeapStride) == 94)
#assert(int(CompilerOptionName.ForceCLayout) == 129)
#assert(int(CompilerOptionName.CountOf) == 159)
#assert(u32(CompileFlags{.NO_MANGLING}) == 0x08)
#assert(u32(CompileFlags{.NO_CODEGEN}) == 0x10)
#assert(u32(CompileFlags{.OBFUSCATE}) == 0x20)
#assert(u32(TargetFlags{.PARAMETER_BLOCK_USE_REGISTER_SPACE}) == 0x10)
#assert(u32(TargetFlags{.GENERATE_WHOLE_PROGRAM}) == 0x100)
#assert(u32(TargetFlags{.DUMP_IR}) == 0x200)
#assert(u32(TargetFlags{.GENERATE_SPIRV_DIRECTLY}) == 0x400)
#assert(u32(CompileCoreModuleFlag.WriteDocumentation) == 0x1)

#assert(size_of(UUID) == 16 && align_of(UUID) == 4)
#assert(offset_of(UUID, data1) == 0)
#assert(offset_of(UUID, data2) == 4)
#assert(offset_of(UUID, data3) == 6)
#assert(offset_of(UUID, data4) == 8)

#assert(size_of(CompilerOptionValue) == 32 && align_of(CompilerOptionValue) == 8)
#assert(offset_of(CompilerOptionValue, kind) == 0)
#assert(offset_of(CompilerOptionValue, intValue0) == 4)
#assert(offset_of(CompilerOptionValue, intValue1) == 8)
#assert(offset_of(CompilerOptionValue, stringValue0) == 16)
#assert(offset_of(CompilerOptionValue, stringValue1) == 24)

#assert(size_of(CompilerOptionEntry) == 40 && align_of(CompilerOptionEntry) == 8)
#assert(offset_of(CompilerOptionEntry, name) == 0)
#assert(offset_of(CompilerOptionEntry, value) == 8)

#assert(size_of(GlobalSessionDesc) == 80 && align_of(GlobalSessionDesc) == 4)
#assert(offset_of(GlobalSessionDesc, structureSize) == 0)
#assert(offset_of(GlobalSessionDesc, apiVersion) == 4)
#assert(offset_of(GlobalSessionDesc, minLanguageVersion) == 8)
#assert(offset_of(GlobalSessionDesc, enableGLSL) == 12)
#assert(offset_of(GlobalSessionDesc, reserved) == 16)

#assert(size_of(SpecializationArg) == 16 && align_of(SpecializationArg) == 8)
#assert(offset_of(SpecializationArg, kind) == 0)
#assert(offset_of(SpecializationArg, type) == 8)

#assert(size_of(TargetDesc) == 48 && align_of(TargetDesc) == 8)
#assert(offset_of(TargetDesc, structureSize) == 0)
#assert(offset_of(TargetDesc, format) == 8)
#assert(offset_of(TargetDesc, profile) == 12)
#assert(offset_of(TargetDesc, flags) == 16)
#assert(offset_of(TargetDesc, floatingPointMode) == 20)
#assert(offset_of(TargetDesc, lineDirectiveMode) == 24)
#assert(offset_of(TargetDesc, forceGLSLScalarBufferLayout) == 28)
#assert(offset_of(TargetDesc, compilerOptionEntries) == 32)
#assert(offset_of(TargetDesc, compilerOptionEntryCount) == 40)

#assert(size_of(PreprocessorMacroDesc) == 16 && align_of(PreprocessorMacroDesc) == 8)
#assert(offset_of(PreprocessorMacroDesc, name) == 0)
#assert(offset_of(PreprocessorMacroDesc, value) == 8)

#assert(size_of(SessionDesc) == 96 && align_of(SessionDesc) == 8)
#assert(offset_of(SessionDesc, structureSize) == 0)
#assert(offset_of(SessionDesc, targets) == 8)
#assert(offset_of(SessionDesc, targetCount) == 16)
#assert(offset_of(SessionDesc, flags) == 24)
#assert(offset_of(SessionDesc, defaultMatrixLayoutMode) == 28)
#assert(offset_of(SessionDesc, searchPaths) == 32)
#assert(offset_of(SessionDesc, searchPathCount) == 40)
#assert(offset_of(SessionDesc, preprocessorMacros) == 48)
#assert(offset_of(SessionDesc, preprocessorMacroCount) == 56)
#assert(offset_of(SessionDesc, fileSystem) == 64)
#assert(offset_of(SessionDesc, enableEffectAnnotations) == 72)
#assert(offset_of(SessionDesc, allowGLSLSyntax) == 73)
#assert(offset_of(SessionDesc, compilerOptionEntries) == 80)
#assert(offset_of(SessionDesc, compilerOptionEntryCount) == 88)
#assert(offset_of(SessionDesc, skipSPIRVValidation) == 92)

#assert(size_of(SourceLocation) == 24 && align_of(SourceLocation) == 8)
#assert(offset_of(SourceLocation, filePath) == 0)
#assert(offset_of(SourceLocation, line) == 8)
#assert(offset_of(SourceLocation, column) == 16)

#assert(size_of(IUnknown) == size_of(rawptr))
#assert(size_of(ICastable) == size_of(rawptr))
#assert(size_of(IComponentType) == size_of(rawptr))
#assert(size_of(ISession) == size_of(rawptr))
#assert(size_of(IGlobalSession) == size_of(rawptr))
#assert(size_of(IUnknown_VTable) == 3 * size_of(rawptr))
#assert(size_of(ICastable_VTable) == 4 * size_of(rawptr))
#assert(size_of(IClonable_VTable) == 5 * size_of(rawptr))
#assert(size_of(IFileSystem_VTable) == 5 * size_of(rawptr))
#assert(size_of(IFileSystemExt_VTable) == 12 * size_of(rawptr))
#assert(size_of(IComponentType_VTable) == 17 * size_of(rawptr))
#assert(size_of(IComponentType2_VTable) == 6 * size_of(rawptr))
#assert(size_of(ISession_VTable) == 24 * size_of(rawptr))
#assert(size_of(IGlobalSession_VTable) == 33 * size_of(rawptr))

IBlob_VTable               :: type_of(IBlob{}.vtable^)
ISharedLibrary_VTable      :: type_of(ISharedLibrary{}.vtable^)
ISharedLibraryLoader_VTable :: type_of(ISharedLibraryLoader{}.vtable^)
IMutableFileSystem_VTable  :: type_of(IMutableFileSystem{}.vtable^)
IWriter_VTable             :: type_of(IWriter{}.vtable^)
IProfiler_VTable           :: type_of(IProfiler{}.vtable^)
IEntryPoint_VTable         :: type_of(IEntryPoint{}.vtable^)
ITypeConformance_VTable    :: type_of(ITypeConformance{}.vtable^)
IModule_VTable             :: type_of(IModule{}.vtable^)
IMetadata_VTable           :: type_of(IMetadata{}.vtable^)
ICompileResult_VTable      :: type_of(ICompileResult{}.vtable^)

#assert(size_of(IBlob_VTable) == 5 * size_of(rawptr))
#assert(size_of(ISharedLibrary_VTable) == 5 * size_of(rawptr))
#assert(size_of(ISharedLibraryLoader_VTable) == 4 * size_of(rawptr))
#assert(size_of(IMutableFileSystem_VTable) == 16 * size_of(rawptr))
#assert(size_of(IWriter_VTable) == 9 * size_of(rawptr))
#assert(size_of(IProfiler_VTable) == 7 * size_of(rawptr))
#assert(size_of(IEntryPoint_VTable) == 18 * size_of(rawptr))
#assert(size_of(ITypeConformance_VTable) == 17 * size_of(rawptr))
#assert(size_of(IModule_VTable) == 30 * size_of(rawptr))
#assert(size_of(IMetadata_VTable) == 6 * size_of(rawptr))
#assert(size_of(ICompileResult_VTable) == 7 * size_of(rawptr))
