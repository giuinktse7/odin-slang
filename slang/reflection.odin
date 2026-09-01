package slang

when ODIN_OS == .Windows {
	foreign import libslang "lib/slang.lib"
} else when ODIN_OS == .Darwin {
	foreign import libslang "lib/libslang.dylib"
} else when ODIN_OS == .Linux {
	foreign import libslang "lib/libslang.so"
}
_ :: libslang

// Opaque handles
ProgramLayout            :: ShaderReflection
ShaderReflection         :: struct {}
EntryPointReflection     :: struct {}

VariableReflection       :: struct {}
VariableLayoutReflection :: struct {}
TypeReflection           :: struct {}
TypeLayoutReflection     :: struct {}

FunctionReflection       :: struct {}
DeclReflection           :: struct {}

Attribute                :: struct {}
TypeParameterReflection  :: struct {}
GenericReflection        :: struct {}

SlangReflectionGenericArg :: struct #raw_union {
	typeVal: ^TypeReflection,
	intVal:  i64,
	boolVal: bool,
}

ReflectionGenericArgType :: enum i32 {
	TYPE = 0,
	INT  = 1,
	BOOL = 2,
}
GenericArgType :: ReflectionGenericArgType

Modifier :: struct {}
ModifierID :: enum u32 {
	Shared         = u32(SlangModifierID(.SHARED)),
	NoDiff         = u32(SlangModifierID(.NO_DIFF)),
	Static         = u32(SlangModifierID(.STATIC)),
	Const          = u32(SlangModifierID(.CONST)),
	Export         = u32(SlangModifierID(.EXPORT)),
	Extern         = u32(SlangModifierID(.EXTERN)),
	Differentiable = u32(SlangModifierID(.DIFFERENTIABLE)),
	Mutating       = u32(SlangModifierID(.MUTATING)),
	In             = u32(SlangModifierID(.IN)),
	Out            = u32(SlangModifierID(.OUT)),
	InOut          = u32(SlangModifierID(.INOUT)),
}

SlangModifierID :: enum u32 {
	SHARED         = 0,
	NO_DIFF        = 1,
	STATIC         = 2,
	CONST          = 3,
	EXPORT         = 4,
	EXTERN         = 5,
	DIFFERENTIABLE = 6,
	MUTATING       = 7,
	IN             = 8,
	OUT            = 9,
	INOUT          = 10,
}

LayoutUnit        :: ParameterCategory
ParameterCategory :: enum u32 {
	None                       = u32(SlangParameterCategory(.NONE)),
	Mixed                      = u32(SlangParameterCategory(.MIXED)),
	ConstantBuffer             = u32(SlangParameterCategory(.CONSTANT_BUFFER)),
	ShaderResource             = u32(SlangParameterCategory(.SHADER_RESOURCE)),
	UnorderedAccess            = u32(SlangParameterCategory(.UNORDERED_ACCESS)),
	VaryingInput               = u32(SlangParameterCategory(.VARYING_INPUT)),
	VaryingOutput              = u32(SlangParameterCategory(.VARYING_OUTPUT)),
	SamplerState               = u32(SlangParameterCategory(.SAMPLER_STATE)),
	Uniform                    = u32(SlangParameterCategory(.UNIFORM)),
	DescriptorTableSlot        = u32(SlangParameterCategory(.DESCRIPTOR_TABLE_SLOT)),
	SpecializationConstant     = u32(SlangParameterCategory(.SPECIALIZATION_CONSTANT)),
	PushConstantBuffer         = u32(SlangParameterCategory(.PUSH_CONSTANT_BUFFER)),
	RegisterSpace              = u32(SlangParameterCategory(.REGISTER_SPACE)),
	GenericResource            = u32(SlangParameterCategory(.GENERIC)),
	RayPayload                 = u32(SlangParameterCategory(.RAY_PAYLOAD)),
	HitAttributes              = u32(SlangParameterCategory(.HIT_ATTRIBUTES)),
	CallablePayload            = u32(SlangParameterCategory(.CALLABLE_PAYLOAD)),
	ShaderRecord               = u32(SlangParameterCategory(.SHADER_RECORD)),
	ExistentialTypeParam       = u32(SlangParameterCategory(.EXISTENTIAL_TYPE_PARAM)),
	ExistentialObjectParam     = u32(SlangParameterCategory(.EXISTENTIAL_OBJECT_PARAM)),
	SubElementRegisterSpace    = u32(SlangParameterCategory(.SUB_ELEMENT_REGISTER_SPACE)),
	InputAttachmentIndex       = u32(SlangParameterCategory(.SUBPASS)),
	MetalBuffer                = u32(SlangParameterCategory(.CONSTANT_BUFFER)),
	MetalTexture               = u32(SlangParameterCategory(.METAL_TEXTURE)),
	MetalArgumentBufferElement = u32(SlangParameterCategory(.METAL_ARGUMENT_BUFFER_ELEMENT)),
	MetalAttribute             = u32(SlangParameterCategory(.METAL_ATTRIBUTE)),
	MetalPayload               = u32(SlangParameterCategory(.METAL_PAYLOAD)),
	VertexInput                = u32(SlangParameterCategory(.VERTEX_INPUT)),
	FragmentOutput             = u32(SlangParameterCategory(.FRAGMENT_OUTPUT)),
}

SlangParameterCategory :: enum u32 {
	NONE                    = 0,
	MIXED                   = 1,
	CONSTANT_BUFFER         = 2,
	SHADER_RESOURCE         = 3,
	UNORDERED_ACCESS        = 4,
	VARYING_INPUT           = 5,
	VARYING_OUTPUT          = 6,
	SAMPLER_STATE           = 7,
	UNIFORM                 = 8,
	DESCRIPTOR_TABLE_SLOT   = 9,
	SPECIALIZATION_CONSTANT = 10,
	PUSH_CONSTANT_BUFFER    = 11,
	// HLSL register `space`, Vulkan GLSL `set`
	REGISTER_SPACE = 12,
	// TODO: Ellie, Both APIs treat mesh outputs as more or less varying output,
	// Does it deserve to be represented here??
	// A parameter whose type is to be specialized by a global generic type argument
	GENERIC          = 13,
	RAY_PAYLOAD      = 14,
	HIT_ATTRIBUTES   = 15,
	CALLABLE_PAYLOAD = 16,
	SHADER_RECORD    = 17,
	// An existential type parameter represents a "hole" that
	// needs to be filled with a concrete type to enable
	// generation of specialized code.
	//
	// Consider this example:
	//
	//      struct MyParams
	//      {
	//          IMaterial material;
	//          ILight lights[3];
	//      };
	//
	// This `MyParams` type introduces two existential type parameters:
	// one for `material` and one for `lights`. Even though `lights`
	// is an array, it only introduces one type parameter, because
	// we need to hae a *single* concrete type for all the array
	// elements to be able to generate specialized code.
	//
	EXISTENTIAL_TYPE_PARAM = 18,
	// An existential object parameter represents a value
	// that needs to be passed in to provide data for some
	// interface-type shader paameter.
	//
	// Consider this example:
	//
	//      struct MyParams
	//      {
	//          IMaterial material;
	//          ILight lights[3];
	//      };
	//
	// This `MyParams` type introduces four existential object parameters:
	// one for `material` and three for `lights` (one for each array
	// element). This is consistent with the number of interface-type
	// "objects" that are being passed through to the shader.
	//
	EXISTENTIAL_OBJECT_PARAM = 19,
	// The register space offset for the sub-elements that occupies register spaces.
	SUB_ELEMENT_REGISTER_SPACE = 20,
	// The input_attachment_index subpass occupancy tracker
	SUBPASS = 21,
	// Metal tier-1 argument buffer element [[id]].
	METAL_ARGUMENT_BUFFER_ELEMENT = 22,
	// Metal [[attribute]] inputs.
	METAL_ATTRIBUTE = 23,
	// Metal [[payload]] inputs
	METAL_PAYLOAD = 24,

	 //
	COUNT = 25,

	 // Aliases for Metal-specific categories.
	METAL_BUFFER = CONSTANT_BUFFER,
	METAL_TEXTURE = SHADER_RESOURCE,
	METAL_SAMPLER = SAMPLER_STATE,

	 // DEPRECATED:
	VERTEX_INPUT = VARYING_INPUT,
	FRAGMENT_OUTPUT = VARYING_OUTPUT,
	COUNT_V1 = SUBPASS,
}

TypeReflectionKind :: enum u32 {
	None                 = u32(SlangTypeKind(.NONE)),
	Struct               = u32(SlangTypeKind(.STRUCT)),
	Array                = u32(SlangTypeKind(.ARRAY)),
	Matrix               = u32(SlangTypeKind(.MATRIX)),
	Vector               = u32(SlangTypeKind(.VECTOR)),
	Scalar               = u32(SlangTypeKind(.SCALAR)),
	ConstantBuffer       = u32(SlangTypeKind(.CONSTANT_BUFFER)),
	Resource             = u32(SlangTypeKind(.RESOURCE)),
	SamplerState         = u32(SlangTypeKind(.SAMPLER_STATE)),
	TextureBuffer        = u32(SlangTypeKind(.TEXTURE_BUFFER)),
	ShaderStorageBuffer  = u32(SlangTypeKind(.SHADER_STORAGE_BUFFER)),
	ParameterBlock       = u32(SlangTypeKind(.PARAMETER_BLOCK)),
	GenericTypeParameter = u32(SlangTypeKind(.GENERIC_TYPE_PARAMETER)),
	Interface            = u32(SlangTypeKind(.INTERFACE)),
	OutputStream         = u32(SlangTypeKind(.OUTPUT_STREAM)),
	Specialized          = u32(SlangTypeKind(.SPECIALIZED)),
	Feedback             = u32(SlangTypeKind(.FEEDBACK)),
	Pointer              = u32(SlangTypeKind(.POINTER)),
	DynamicResource      = u32(SlangTypeKind(.DYNAMIC_RESOURCE)),
	MeshOutput           = u32(SlangTypeKind(.MESH_OUTPUT)),
	Enum                 = u32(SlangTypeKind(.ENUM)),
}

SlangTypeKind :: enum u32 {
	NONE                   = 0,
	STRUCT                 = 1,
	ARRAY                  = 2,
	MATRIX                 = 3,
	VECTOR                 = 4,
	SCALAR                 = 5,
	CONSTANT_BUFFER        = 6,
	RESOURCE               = 7,
	SAMPLER_STATE          = 8,
	TEXTURE_BUFFER         = 9,
	SHADER_STORAGE_BUFFER  = 10,
	PARAMETER_BLOCK        = 11,
	GENERIC_TYPE_PARAMETER = 12,
	INTERFACE              = 13,
	OUTPUT_STREAM          = 14,
	MESH_OUTPUT            = 15,
	SPECIALIZED            = 16,
	FEEDBACK               = 17,
	POINTER                = 18,
	DYNAMIC_RESOURCE       = 19,
	ENUM                   = 20,
	COUNT                  = 21,
}

TypeReflectionScalarType :: enum u32 {
	None    = u32(SlangScalarType(.NONE)),
	Void    = u32(SlangScalarType(.VOID)),
	Bool    = u32(SlangScalarType(.BOOL)),
	Int32   = u32(SlangScalarType(.INT32)),
	UInt32  = u32(SlangScalarType(.UINT32)),
	Int64   = u32(SlangScalarType(.INT64)),
	UInt64  = u32(SlangScalarType(.UINT64)),
	Float16 = u32(SlangScalarType(.FLOAT16)),
	Float32 = u32(SlangScalarType(.FLOAT32)),
	Float64 = u32(SlangScalarType(.FLOAT64)),
	Int8    = u32(SlangScalarType(.INT8)),
	UInt8   = u32(SlangScalarType(.UINT8)),
	Int16   = u32(SlangScalarType(.INT16)),
	UInt16  = u32(SlangScalarType(.UINT16)),
	IntPtr  = u32(SlangScalarType(.INTPTR)),
	UIntPtr = u32(SlangScalarType(.UINTPTR)),
	BFloat16 = u32(SlangScalarType(.BFLOAT16)),
	FloatE4M3 = u32(SlangScalarType(.FLOAT_E4M3)),
	FloatE5M2 = u32(SlangScalarType(.FLOAT_E5M2)),
}

SlangScalarType :: enum u32 {
	NONE       = 0,
	VOID       = 1,
	BOOL       = 2,
	INT32      = 3,
	UINT32     = 4,
	INT64      = 5,
	UINT64     = 6,
	FLOAT16    = 7,
	FLOAT32    = 8,
	FLOAT64    = 9,
	INT8       = 10,
	UINT8      = 11,
	INT16      = 12,
	UINT16     = 13,
	INTPTR     = 14,
	UINTPTR    = 15,
	BFLOAT16   = 16,
	FLOAT_E4M3 = 17,
	FLOAT_E5M2 = 18,
}



SlangResourceShape :: enum u32 {
	BASE_SHAPE_MASK              = 0x0F,
	NONE                         = 0x00,
	TEXTURE_1D                   = 0x01,
	TEXTURE_2D                   = 0x02,
	TEXTURE_3D                   = 0x03,
	TEXTURE_CUBE                 = 0x04,
	TEXTURE_BUFFER               = 0x05,
	STRUCTURED_BUFFER            = 0x06,
	BYTE_ADDRESS_BUFFER          = 0x07,
	RESOURCE_UNKNOWN             = 0x08,
	ACCELERATION_STRUCTURE       = 0x09,
	TEXTURE_SUBPASS              = 0x0A,
	RESOURCE_EXT_SHAPE_MASK      = 0x1F0,
	TEXTURE_FEEDBACK_FLAG        = 0x10,
	TEXTURE_SHADOW_FLAG          = 0x20,
	TEXTURE_ARRAY_FLAG           = 0x40,
	TEXTURE_MULTISAMPLE_FLAG     = 0x80,
	TEXTURE_COMBINED_FLAG        = 0x100,
	TEXTURE_1D_ARRAY             = TEXTURE_1D | TEXTURE_ARRAY_FLAG,
	TEXTURE_2D_ARRAY             = TEXTURE_2D | TEXTURE_ARRAY_FLAG,
	TEXTURE_CUBE_ARRAY           = TEXTURE_CUBE | TEXTURE_ARRAY_FLAG,
	TEXTURE_2D_MULTISAMPLE       = TEXTURE_2D | TEXTURE_MULTISAMPLE_FLAG,
	TEXTURE_2D_MULTISAMPLE_ARRAY = TEXTURE_2D | TEXTURE_MULTISAMPLE_FLAG | TEXTURE_ARRAY_FLAG,
	TEXTURE_SUBPASS_MULTISAMPLE  = TEXTURE_SUBPASS | TEXTURE_MULTISAMPLE_FLAG,
}

SlangResourceAccess :: enum u32 {
	NONE           = 0,
	READ           = 1,
	READ_WRITE     = 2,
	RASTER_ORDERED = 3,
	APPEND         = 4,
	CONSUME        = 5,
	WRITE          = 6,
	FEEDBACK       = 7,
	UNKNOWN = 0x7FFFFFFF,
}

DeclKind :: enum u32 {
	UNSUPPORTED_FOR_REFLECTION = 0,
	STRUCT                     = 1,
	FUNC                       = 2,
	MODULE                     = 3,
	GENERIC                    = 4,
	VARIABLE                   = 5,
	NAMESPACE                  = 6,
	ENUM                       = 7,
}

BindingType :: enum u32 {
	UNKNOWN = 0,
	SAMPLER                            = 1,
	TEXTURE                            = 2,
	CONSTANT_BUFFER                    = 3,
	PARAMETER_BLOCK                    = 4,
	TYPED_BUFFER                       = 5,
	RAW_BUFFER                         = 6,
	COMBINED_TEXTURE_SAMPLER           = 7,
	INPUT_RENDER_TARGET                = 8,
	INLINE_UNIFORM_DATA                = 9,
	RAY_TRACING_ACCELERATION_STRUCTURE = 10,
	VARYING_INPUT                      = 11,
	VARYING_OUTPUT                     = 12,
	EXISTENTIAL_VALUE                  = 13,
	PUSH_CONSTANT                      = 14,
	MUTABLE_FLAG = 0x100,

	MUTABLE_TETURE = TEXTURE | MUTABLE_FLAG, // upstream ABI spelling
	MUTABLE_TEXTURE = MUTABLE_TETURE,
	MUTABLE_TYPED_BUFFER = TYPED_BUFFER | MUTABLE_FLAG,
	MUTABLE_RAW_BUFFER = RAW_BUFFER | MUTABLE_FLAG,

	BASE_MASK = 0x00FF,
	EXT_MASK = 0xFF00,
}

#assert(size_of(SlangReflectionGenericArg) == 8 && align_of(SlangReflectionGenericArg) == 8)
#assert(offset_of(SlangReflectionGenericArg, typeVal) == 0)
#assert(offset_of(SlangReflectionGenericArg, intVal) == 0)
#assert(offset_of(SlangReflectionGenericArg, boolVal) == 0)
#assert(size_of(ReflectionGenericArgType) == 4)
#assert(int(SlangTypeKind.ENUM) == 20)
#assert(int(SlangScalarType.BFLOAT16) == 16)
#assert(int(SlangScalarType.FLOAT_E5M2) == 18)
#assert(int(DeclKind.ENUM) == 7)
#assert(int(SlangParameterCategory.COUNT) == 25)

@(link_prefix="sp")
@(default_calling_convention="c")
foreign libslang {
	// Variable
	ReflectionVariable_GetName :: proc(entryPoint: ^VariableReflection) -> cstring ---
	ReflectionVariable_GetType :: proc(inVar: ^VariableReflection) -> ^TypeReflection ---
	ReflectionVariable_FindModifier :: proc(inVar: ^VariableReflection, modifierID: SlangModifierID) -> ^Modifier ---
	ReflectionVariable_GetUserAttributeCount :: proc(inVar: ^VariableReflection) -> u32 ---
	ReflectionVariable_GetUserAttribute :: proc(inVar: ^VariableReflection, index: u32) -> ^Attribute ---
	ReflectionVariable_FindUserAttributeByName :: proc(inVar: ^VariableReflection, session: ^IGlobalSession, name: cstring) -> ^Attribute ---
	ReflectionVariable_HasDefaultValue :: proc(inVar: ^VariableReflection) -> bool ---
	ReflectionVariable_GetDefaultValueInt :: proc(inVar: ^VariableReflection, rs: ^i64) -> Result ---
	ReflectionVariable_GetGenericContainer :: proc(var: ^VariableReflection) -> ^GenericReflection ---
	ReflectionVariable_applySpecializations :: proc(var: ^VariableReflection, generic: ^GenericReflection) -> ^VariableReflection ---

	// Type
  	ReflectionType_GetName :: proc(inType: ^TypeReflection) -> cstring ---
	ReflectionType_GetFullName :: proc(inType: ^TypeReflection, outNameBlob: ^^IBlob) -> Result ---
	ReflectionType_GetGenericContainer :: proc(inType: ^TypeReflection) -> ^GenericReflection ---
	ReflectionType_GetResourceResultType :: proc(inType: ^TypeReflection) -> ^TypeReflection ---
	ReflectionType_GetKind       :: proc(type: ^TypeReflection) -> SlangTypeKind ---
	ReflectionType_GetFieldCount :: proc(type: ^TypeReflection) -> u32 ---
	ReflectionType_GetFieldByIndex :: proc(inType: ^TypeReflection, index: u32) -> ^VariableReflection ---
	ReflectionType_GetElementCount :: proc(inType: ^TypeReflection) -> uint ---
	ReflectionType_GetSpecializedElementCount :: proc(inType: ^TypeReflection, reflection: ^ProgramLayout) -> uint ---
	ReflectionType_GetElementType :: proc(inType: ^TypeReflection) -> ^TypeReflection ---
	ReflectionType_GetRowCount :: proc(inType: ^TypeReflection) -> u32 ---
	ReflectionType_GetColumnCount :: proc(inType: ^TypeReflection) -> u32 ---
	ReflectionType_GetScalarType :: proc(inType: ^TypeReflection) -> SlangScalarType ---
	ReflectionType_GetUserAttributeCount :: proc(inType: ^TypeReflection) -> u32 ---
	ReflectionType_GetResourceShape :: proc(inType: ^TypeReflection) -> SlangResourceShape ---
	ReflectionType_GetResourceAccess :: proc(inType: ^TypeReflection) -> SlangResourceAccess ---
	ReflectionType_getSpecializedTypeArgCount :: proc(inType: ^TypeReflection) -> Int ---
	ReflectionType_getSpecializedTypeArgType :: proc(inType: ^TypeReflection, index: Int) -> ^TypeReflection ---

	// Program Layout
	Reflection_FindFunctionByName :: proc(reflection: ^ProgramLayout, name: cstring) -> ^FunctionReflection ---
	Reflection_FindFunctionByNameInType :: proc(reflection: ^ProgramLayout, reflType: ^TypeReflection, name: cstring) -> ^FunctionReflection ---
	Reflection_FindVarByNameInType :: proc(reflection: ^ProgramLayout, reflType: ^TypeReflection, name: cstring) -> ^VariableReflection ---
	Reflection_FindTypeByName :: proc(reflection: ^ProgramLayout, name: cstring) -> ^TypeReflection ---
	Reflection_TryResolveOverloadedFunction :: proc(reflection: ^ProgramLayout, candidateCount: u32, candidates: ^^FunctionReflection,) -> ^FunctionReflection ---
	Reflection_isSubType :: proc(reflection: ^ProgramLayout, subType: ^TypeReflection, superType: ^TypeReflection,) -> bool ---
	Reflection_GetTypeLayout :: proc(reflection: ^ProgramLayout, inType: ^TypeReflection, rules: LayoutRules,) -> ^TypeLayoutReflection ---

	ReflectionUserAttribute_GetName :: proc(attrib: ^Attribute) -> cstring ---
	ReflectionUserAttribute_GetArgumentCount :: proc(attrib: ^Attribute) -> u32 ---
	ReflectionUserAttribute_GetArgumentValueInt :: proc(attrib: ^Attribute, index: u32, rs: ^int) -> Result ---
	ReflectionUserAttribute_GetArgumentValueFloat :: proc(attrib: ^Attribute, index: u32, rs: ^f32) -> Result ---
	ReflectionUserAttribute_GetArgumentValueString :: proc(attrib: ^Attribute, index: u32, bufLen: ^uint) -> cstring ---

	ReflectionTypeLayout_GetType :: proc(inTypeLayout: ^TypeLayoutReflection) -> ^TypeReflection ---
	ReflectionTypeLayout_getKind :: proc(inTypeLayout: ^TypeLayoutReflection) -> SlangTypeKind ---
	ReflectionTypeLayout_GetSize :: proc(inTypeLayout: ^TypeLayoutReflection, category: ParameterCategory) -> uint ---
	ReflectionTypeLayout_GetStride :: proc(inTypeLayout: ^TypeLayoutReflection, category: ParameterCategory) -> uint ---
	ReflectionTypeLayout_getAlignment :: proc(inTypeLayout: ^TypeLayoutReflection, category: ParameterCategory) -> i32 ---
	ReflectionTypeLayout_GetFieldByIndex :: proc(inTypeLayout: ^TypeLayoutReflection, index: u32) -> ^VariableLayoutReflection ---
	ReflectionTypeLayout_findFieldIndexByName :: proc(inTypeLayout: ^TypeLayoutReflection, nameBegin: cstring, nameEnd: cstring) -> Int ---
	ReflectionTypeLayout_GetExplicitCounter :: proc(inTypeLayout: ^TypeLayoutReflection) -> ^VariableLayoutReflection ---
	ReflectionTypeLayout_GetElementStride :: proc(inTypeLayout: ^TypeLayoutReflection, category: ParameterCategory) -> uint ---
	ReflectionTypeLayout_GetElementTypeLayout :: proc(inTypeLayout: ^TypeLayoutReflection) -> ^TypeLayoutReflection ---
	ReflectionTypeLayout_GetElementVarLayout :: proc(inTypeLayout: ^TypeLayoutReflection) -> ^VariableLayoutReflection ---
	ReflectionTypeLayout_getContainerVarLayout :: proc(inTypeLayout: ^TypeLayoutReflection) -> ^VariableLayoutReflection ---
	ReflectionTypeLayout_GetParameterCategory :: proc(inTypeLayout: ^TypeLayoutReflection) -> ParameterCategory ---
	ReflectionTypeLayout_GetFieldCount :: proc(inTypeLayout: ^TypeLayoutReflection) -> u32 ---
	ReflectionTypeLayout_GetCategoryCount :: proc(inTypeLayout: ^TypeLayoutReflection) -> u32 ---
	ReflectionTypeLayout_GetCategoryByIndex :: proc(inTypeLayout: ^TypeLayoutReflection, index: u32) -> ParameterCategory ---
	ReflectionTypeLayout_GetMatrixLayoutMode :: proc(inTypeLayout: ^TypeLayoutReflection) -> MatrixLayoutMode ---
	ReflectionTypeLayout_getGenericParamIndex :: proc(inTypeLayout: ^TypeLayoutReflection) -> i32 ---
	ReflectionTypeLayout_getPendingDataTypeLayout :: proc() -> ^TypeLayoutReflection ---
	ReflectionTypeLayout_getSpecializedTypePendingDataVarLayout :: proc() -> ^VariableLayoutReflection ---
	ReflectionTypeLayout_getBindingRangeCount :: proc(inTypeLayout: ^TypeLayoutReflection) -> Int ---
	ReflectionTypeLayout_getBindingRangeType :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> BindingType ---
	ReflectionTypeLayout_isBindingRangeSpecializable :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> Int ---
	ReflectionTypeLayout_getBindingRangeBindingCount :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> Int ---
	// @(deprecated="commented out in slang now")
	// ReflectionTypeLayout_getBindingRangeIndexOffset :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> Int ---
	// ReflectionTypeLayout_getBindingRangeSpaceOffset :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> Int ---
	ReflectionTypeLayout_getBindingRangeLeafTypeLayout :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> ^TypeLayoutReflection ---
	ReflectionTypeLayout_getBindingRangeLeafVariable :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> ^VariableReflection ---
	ReflectionTypeLayout_getBindingRangeImageFormat :: proc(typeLayout: ^TypeLayoutReflection, index: Int) -> ImageFormat ---
	ReflectionTypeLayout_getBindingRangeDescriptorSetIndex :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> Int ---
	ReflectionTypeLayout_getBindingRangeFirstDescriptorRangeIndex :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> Int ---
	ReflectionTypeLayout_getBindingRangeDescriptorRangeCount :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> Int ---
	ReflectionTypeLayout_getDescriptorSetCount :: proc(inTypeLayout: ^TypeLayoutReflection) -> Int ---
	ReflectionTypeLayout_getDescriptorSetSpaceOffset :: proc(inTypeLayout: ^TypeLayoutReflection, setIndex: Int) -> Int ---
	ReflectionTypeLayout_getDescriptorSetDescriptorRangeCount :: proc(inTypeLayout: ^TypeLayoutReflection, setIndex: Int) -> Int ---
	ReflectionTypeLayout_getDescriptorSetDescriptorRangeIndexOffset :: proc(inTypeLayout: ^TypeLayoutReflection, setIndex: Int, rangeIndex: Int) -> Int ---
	ReflectionTypeLayout_getDescriptorSetDescriptorRangeDescriptorCount :: proc(inTypeLayout: ^TypeLayoutReflection, setIndex: Int, rangeIndex: Int) -> Int ---
	ReflectionTypeLayout_getDescriptorSetDescriptorRangeType :: proc(inTypeLayout: ^TypeLayoutReflection, setIndex: Int, rangeIndex: Int) -> BindingType ---
	ReflectionTypeLayout_getDescriptorSetDescriptorRangeCategory :: proc(inTypeLayout: ^TypeLayoutReflection, setIndex: Int, rangeIndex: Int) -> ParameterCategory ---
	ReflectionTypeLayout_getSubObjectRangeSpaceOffset :: proc(inTypeLayout: ^TypeLayoutReflection, subObjectRangeIndex: Int) -> Int ---
	ReflectionTypeLayout_getSubObjectRangeOffset :: proc(inTypeLayout: ^TypeLayoutReflection, subObjectRangeIndex: Int) -> ^VariableLayoutReflection ---
	ReflectionTypeLayout_getBindingRangeSubObjectRangeIndex :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> Int ---
	ReflectionTypeLayout_getFieldBindingRangeOffset :: proc(inTypeLayout: ^TypeLayoutReflection, fieldIndex: Int) -> Int ---
	ReflectionTypeLayout_getExplicitCounterBindingRangeOffset :: proc(inTypeLayout: ^TypeLayoutReflection) -> Int ---
	ReflectionTypeLayout_getSubObjectRangeCount :: proc(inTypeLayout: ^TypeLayoutReflection) -> Int ---
	ReflectionTypeLayout_getSubObjectRangeObjectCount :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> Int ---
	ReflectionTypeLayout_getSubObjectRangeBindingRangeIndex :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> Int ---
	ReflectionTypeLayout_getSubObjectRangeTypeLayout :: proc(inTypeLayout: ^TypeLayoutReflection, index: Int) -> ^TypeLayoutReflection ---
	ReflectionTypeLayout_getSubObjectRangeDescriptorRangeCount :: proc(inTypeLayout: ^TypeLayoutReflection, subObjectRangeIndex: Int) -> Int ---
	ReflectionTypeLayout_getSubObjectRangeDescriptorRangeBindingType :: proc(inTypeLayout: ^TypeLayoutReflection, subObjectRangeIndex: Int, bindingRangeIndexInSubObject: Int) -> BindingType ---
	ReflectionTypeLayout_getSubObjectRangeDescriptorRangeBindingCount :: proc(inTypeLayout: ^TypeLayoutReflection, subObjectRangeIndex: Int, bindingRangeIndexInSubObject: Int) -> Int ---
	ReflectionTypeLayout_getSubObjectRangeDescriptorRangeIndexOffset :: proc(inTypeLayout: ^TypeLayoutReflection, subObjectRangeIndex: Int, bindingRangeIndexInSubObject: Int) -> Int ---
	ReflectionTypeLayout_getSubObjectRangeDescriptorRangeSpaceOffset :: proc(inTypeLayout: ^TypeLayoutReflection, subObjectRangeIndex: Int, bindingRangeIndexInSubObject: Int) -> Int ---

	ReflectionVariableLayout_GetVariable :: proc(inVarLayout: ^VariableLayoutReflection) -> ^VariableReflection ---
	ReflectionVariableLayout_GetTypeLayout :: proc(inVarLayout: ^VariableLayoutReflection) -> ^TypeLayoutReflection ---
	ReflectionVariableLayout_GetOffset :: proc(inVarLayout: ^VariableLayoutReflection, category: ParameterCategory) -> uint ---
	ReflectionVariableLayout_GetSpace :: proc(inVarLayout: ^VariableLayoutReflection, category: ParameterCategory) -> uint ---
	ReflectionVariableLayout_GetImageFormat :: proc(inVarLayout: ^VariableLayoutReflection) -> ImageFormat ---
	ReflectionVariableLayout_GetSemanticName :: proc(inVarLayout: ^VariableLayoutReflection) -> cstring ---
	ReflectionVariableLayout_GetSemanticIndex :: proc(inVarLayout: ^VariableLayoutReflection) -> uint ---
	ReflectionVariableLayout_getStage :: proc(inVarLayout: ^VariableLayoutReflection) -> Stage ---
	ReflectionVariableLayout_getPendingDataLayout :: proc() -> ^VariableLayoutReflection ---

	ReflectionFunction_asDecl :: proc(inFunc: ^FunctionReflection) -> ^DeclReflection ---
	ReflectionFunction_GetName :: proc(inFunc: ^FunctionReflection) -> cstring ---
	ReflectionFunction_GetResultType :: proc(inFunc: ^FunctionReflection) -> ^TypeReflection ---
	ReflectionFunction_FindModifier :: proc(inFunc: ^FunctionReflection, modifierID: SlangModifierID) -> ^Modifier ---
	ReflectionFunction_GetUserAttributeCount :: proc(inFunc: ^FunctionReflection) -> u32 ---
	ReflectionFunction_GetUserAttribute :: proc(inFunc: ^FunctionReflection, index: u32) -> ^Attribute ---
	ReflectionFunction_FindUserAttributeByName :: proc(inFunc: ^FunctionReflection, session: ^IGlobalSession, name: cstring) -> ^Attribute ---
	ReflectionFunction_GetParameterCount :: proc(inFunc: ^FunctionReflection) -> u32 ---
	ReflectionFunction_GetParameter :: proc(inFunc: ^FunctionReflection, index: u32) -> ^VariableReflection ---
	ReflectionFunction_GetGenericContainer :: proc(func: ^FunctionReflection) -> ^GenericReflection ---
	ReflectionFunction_applySpecializations :: proc(func: ^FunctionReflection, generic: ^GenericReflection) -> ^FunctionReflection ---
	ReflectionFunction_specializeWithArgTypes :: proc(func: ^FunctionReflection, argTypeCount: Int, argTypes: ^TypeReflection) -> ^FunctionReflection ---
	ReflectionFunction_isOverloaded :: proc(func: ^FunctionReflection) -> bool ---
	ReflectionFunction_getOverloadCount :: proc(func: ^FunctionReflection) -> u32 ---
	ReflectionFunction_getOverload :: proc(func: ^FunctionReflection, index: u32) -> ^FunctionReflection ---
	
	Reflection_getTypeFromDecl :: proc(decl: ^DeclReflection) -> ^TypeReflection ---
	ReflectionDecl_findModifier :: proc(decl: ^DeclReflection, modifierID: SlangModifierID) -> ^Modifier ---
	ReflectionDecl_getChildrenCount :: proc(parentDecl: ^DeclReflection) -> u32 ---
	ReflectionDecl_getChild :: proc(parentDecl: ^DeclReflection, index: u32) -> ^DeclReflection ---
	ReflectionDecl_getName :: proc(decl: ^DeclReflection) -> cstring ---
	ReflectionDecl_getKind :: proc(decl: ^DeclReflection) -> DeclKind ---
	ReflectionDecl_castToFunction :: proc(decl: ^DeclReflection) -> ^FunctionReflection ---
	ReflectionDecl_castToVariable :: proc(decl: ^DeclReflection) -> ^VariableReflection ---
	ReflectionDecl_castToGeneric :: proc(decl: ^DeclReflection) -> ^GenericReflection ---
	ReflectionDecl_getParent :: proc(decl: ^DeclReflection) -> ^DeclReflection ---

	ReflectionGeneric_asDecl :: proc(generic: ^GenericReflection) -> ^DeclReflection ---
	ReflectionGeneric_GetName :: proc(generic: ^GenericReflection) -> cstring ---
	ReflectionGeneric_GetTypeParameterCount :: proc(generic: ^GenericReflection) -> u32 ---
	ReflectionGeneric_GetTypeParameter :: proc(generic: ^GenericReflection, index: u32) -> ^VariableReflection ---
	ReflectionGeneric_GetValueParameterCount :: proc(generic: ^GenericReflection) -> u32 ---
	ReflectionGeneric_GetValueParameter :: proc(generic: ^GenericReflection, index: u32) -> ^VariableReflection ---
	ReflectionGeneric_GetTypeParameterConstraintCount :: proc(generic: ^GenericReflection, typeParam: ^VariableReflection) -> u32 ---
	ReflectionGeneric_GetTypeParameterConstraintType :: proc(generic: ^GenericReflection, typeParam: ^VariableReflection, index: u32) -> ^TypeReflection ---
	ReflectionGeneric_GetInnerKind :: proc(generic: ^GenericReflection) -> DeclKind ---
	ReflectionGeneric_GetInnerDecl :: proc(generic: ^GenericReflection) -> ^DeclReflection ---
	ReflectionGeneric_GetOuterGenericContainer :: proc(generic: ^GenericReflection) -> ^GenericReflection ---
	ReflectionGeneric_GetConcreteType :: proc(generic: ^GenericReflection, typeParam: ^VariableReflection) -> ^TypeReflection ---
	ReflectionGeneric_GetConcreteIntVal :: proc(generic: ^GenericReflection, valueParam: ^VariableReflection) -> i64 ---
	ReflectionGeneric_applySpecializations :: proc(currGeneric: ^GenericReflection, generic: ^GenericReflection) -> ^GenericReflection ---

	ReflectionParameter_GetBindingIndex :: proc(inVarLayout: ^VariableLayoutReflection) -> u32 ---
	ReflectionParameter_GetBindingSpace :: proc(inVarLayout: ^VariableLayoutReflection) -> u32 ---
	@(deprecated="Use IMetadata->isParameterLocationUsed() instead.")
	IsParameterLocationUsed :: proc(request: ^ICompileRequest,  entryPointIndex: Int, targetIndex: Int, category: ParameterCategory, spaceIndex: UInt, registerIndex: UInt, outUsed: ^bool) -> Result ---

	ReflectionEntryPoint_getName :: proc(inEntryPoint: ^EntryPointReflection) -> cstring ---
	ReflectionEntryPoint_getNameOverride :: proc(inEntryPoint: ^EntryPointReflection) -> cstring ---
	ReflectionEntryPoint_getFunction :: proc(inEntryPoint: ^EntryPointReflection) -> ^FunctionReflection ---
	ReflectionEntryPoint_getParameterCount :: proc(inEntryPoint: ^EntryPointReflection) -> u32 ---
	ReflectionEntryPoint_getParameterByIndex :: proc(inEntryPoint: ^EntryPointReflection, index: u32) -> ^VariableLayoutReflection ---
	ReflectionEntryPoint_getStage :: proc(inEntryPoint: ^EntryPointReflection) -> Stage ---
	ReflectionEntryPoint_getComputeThreadGroupSize :: proc(inEntryPoint: ^EntryPointReflection, axisCount: UInt, outSizeAlongAxis: ^UInt) ---
	ReflectionEntryPoint_getComputeWaveSize :: proc(inEntryPoint: ^EntryPointReflection, outWaveSize: ^UInt) ---
	ReflectionEntryPoint_usesAnySampleRateInput :: proc(inEntryPoint: ^EntryPointReflection) -> int ---
	ReflectionEntryPoint_getVarLayout :: proc(inEntryPoint: ^EntryPointReflection) -> ^VariableLayoutReflection ---
	ReflectionEntryPoint_getResultVarLayout :: proc(inEntryPoint: ^EntryPointReflection) -> ^VariableLayoutReflection ---
	ReflectionEntryPoint_hasDefaultConstantBuffer :: proc(inEntryPoint: ^EntryPointReflection) -> int ---

	ReflectionTypeParameter_GetName :: proc(inTypeParam: ^TypeParameterReflection) -> cstring ---
	ReflectionTypeParameter_GetIndex :: proc(inTypeParam: ^TypeParameterReflection) -> u32 ---
	ReflectionTypeParameter_GetConstraintCount :: proc(inTypeParam: ^TypeParameterReflection) -> u32 ---
	ReflectionTypeParameter_GetConstraintByIndex :: proc(inTypeParam: ^TypeParameterReflection, index: u32) -> ^TypeReflection ---

	Reflection_GetParameterCount :: proc(inProgram: ^ProgramLayout) -> u32 ---
	Reflection_GetParameterByIndex :: proc(inProgram: ^ProgramLayout, index: u32) -> ^VariableLayoutReflection ---
	Reflection_getGlobalParamsVarLayout :: proc(inProgram: ^ProgramLayout) -> ^VariableLayoutReflection ---
	Reflection_GetTypeParameterCount :: proc(reflection: ^ProgramLayout) -> u32 ---
	Reflection_GetTypeParameterByIndex :: proc(reflection: ^ProgramLayout, index: u32) -> ^TypeParameterReflection ---
	Reflection_FindTypeParameter :: proc(inProgram: ^ProgramLayout, name: cstring) -> ^TypeParameterReflection ---
	Reflection_getEntryPointCount :: proc(inProgram: ^ProgramLayout) -> UInt ---
	Reflection_getEntryPointByIndex :: proc(inProgram: ^ProgramLayout, index: UInt) -> ^EntryPointReflection ---
	Reflection_findEntryPointByName :: proc(inProgram: ^ProgramLayout, name: cstring) -> ^EntryPointReflection ---
	Reflection_getGlobalConstantBufferBinding :: proc(inProgram: ^ProgramLayout) -> UInt ---
	Reflection_getGlobalConstantBufferSize :: proc(inProgram: ^ProgramLayout) -> uint ---
	Reflection_specializeType :: proc(inProgramLayout: ^ProgramLayout, inType: ^TypeReflection, specializationArgCount: Int, specializationArgs: ^TypeReflection, outDiagnostics: ^^IBlob) -> ^TypeReflection ---
	Reflection_specializeGeneric :: proc(inProgramLayout: ^ProgramLayout, generic: ^GenericReflection, argCount: Int, argTypes: ^GenericArgType, args: ^SlangReflectionGenericArg, outDiagnostics: ^^IBlob) -> ^GenericReflection ---
	Reflection_getHashedStringCount :: proc(reflection: ^ProgramLayout) -> UInt ---
	Reflection_getHashedString :: proc(reflection: ^ProgramLayout, index: UInt, outCount: ^uint) -> cstring ---

	ComputeStringHash :: proc(chars: cstring, count: uint) -> u32 ---

	Reflection_getGlobalParamsTypeLayout :: proc(reflection: ^ProgramLayout) -> ^TypeLayoutReflection ---
	Reflection_ToJson :: proc(reflection: ^ProgramLayout,request: ^ICompileRequest, outBlob: ^^IBlob) -> Result ---
}
