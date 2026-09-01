#include "../public_headers/v2026.16.1/slang.h"
#include "../public_headers/v2026.16.1/slang-deprecated.h"

#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <type_traits>

// Run from the repository root with:
// c++ -std=c++17 -Wall -Wextra -Werror tests/abi_probe.cpp -o /tmp/odin-slang-abi-probe

#define CHECK_SIZE_ALIGN(TYPE, SIZE, ALIGN) \
    static_assert(sizeof(TYPE) == SIZE);    \
    static_assert(alignof(TYPE) == ALIGN)

#define CHECK_OFFSET(TYPE, FIELD, OFFSET) static_assert(offsetof(TYPE, FIELD) == OFFSET)

CHECK_SIZE_ALIGN(SlangUUID, 16, 4);
CHECK_OFFSET(SlangUUID, data1, 0);
CHECK_OFFSET(SlangUUID, data2, 4);
CHECK_OFFSET(SlangUUID, data3, 6);
CHECK_OFFSET(SlangUUID, data4, 8);

CHECK_SIZE_ALIGN(slang::CompilerOptionValue, 32, 8);
CHECK_OFFSET(slang::CompilerOptionValue, kind, 0);
CHECK_OFFSET(slang::CompilerOptionValue, intValue0, 4);
CHECK_OFFSET(slang::CompilerOptionValue, intValue1, 8);
CHECK_OFFSET(slang::CompilerOptionValue, stringValue0, 16);
CHECK_OFFSET(slang::CompilerOptionValue, stringValue1, 24);

CHECK_SIZE_ALIGN(slang::CompilerOptionEntry, 40, 8);
CHECK_OFFSET(slang::CompilerOptionEntry, name, 0);
CHECK_OFFSET(slang::CompilerOptionEntry, value, 8);

CHECK_SIZE_ALIGN(SlangGlobalSessionDesc, 80, 4);
CHECK_OFFSET(SlangGlobalSessionDesc, structureSize, 0);
CHECK_OFFSET(SlangGlobalSessionDesc, apiVersion, 4);
CHECK_OFFSET(SlangGlobalSessionDesc, minLanguageVersion, 8);
CHECK_OFFSET(SlangGlobalSessionDesc, enableGLSL, 12);
CHECK_OFFSET(SlangGlobalSessionDesc, reserved, 16);

CHECK_SIZE_ALIGN(slang::SpecializationArg, 16, 8);
CHECK_OFFSET(slang::SpecializationArg, kind, 0);
CHECK_OFFSET(slang::SpecializationArg, type, 8);

CHECK_SIZE_ALIGN(slang::TargetDesc, 48, 8);
CHECK_OFFSET(slang::TargetDesc, structureSize, 0);
CHECK_OFFSET(slang::TargetDesc, format, 8);
CHECK_OFFSET(slang::TargetDesc, profile, 12);
CHECK_OFFSET(slang::TargetDesc, flags, 16);
CHECK_OFFSET(slang::TargetDesc, floatingPointMode, 20);
CHECK_OFFSET(slang::TargetDesc, lineDirectiveMode, 24);
CHECK_OFFSET(slang::TargetDesc, forceGLSLScalarBufferLayout, 28);
CHECK_OFFSET(slang::TargetDesc, compilerOptionEntries, 32);
CHECK_OFFSET(slang::TargetDesc, compilerOptionEntryCount, 40);

CHECK_SIZE_ALIGN(slang::PreprocessorMacroDesc, 16, 8);
CHECK_OFFSET(slang::PreprocessorMacroDesc, name, 0);
CHECK_OFFSET(slang::PreprocessorMacroDesc, value, 8);

CHECK_SIZE_ALIGN(slang::SessionDesc, 96, 8);
CHECK_OFFSET(slang::SessionDesc, structureSize, 0);
CHECK_OFFSET(slang::SessionDesc, targets, 8);
CHECK_OFFSET(slang::SessionDesc, targetCount, 16);
CHECK_OFFSET(slang::SessionDesc, flags, 24);
CHECK_OFFSET(slang::SessionDesc, defaultMatrixLayoutMode, 28);
CHECK_OFFSET(slang::SessionDesc, searchPaths, 32);
CHECK_OFFSET(slang::SessionDesc, searchPathCount, 40);
CHECK_OFFSET(slang::SessionDesc, preprocessorMacros, 48);
CHECK_OFFSET(slang::SessionDesc, preprocessorMacroCount, 56);
CHECK_OFFSET(slang::SessionDesc, fileSystem, 64);
CHECK_OFFSET(slang::SessionDesc, enableEffectAnnotations, 72);
CHECK_OFFSET(slang::SessionDesc, allowGLSLSyntax, 73);
CHECK_OFFSET(slang::SessionDesc, compilerOptionEntries, 80);
CHECK_OFFSET(slang::SessionDesc, compilerOptionEntryCount, 88);
CHECK_OFFSET(slang::SessionDesc, skipSPIRVValidation, 92);

CHECK_SIZE_ALIGN(slang::SourceLocation, 24, 8);
CHECK_OFFSET(slang::SourceLocation, filePath, 0);
CHECK_OFFSET(slang::SourceLocation, line, 8);
CHECK_OFFSET(slang::SourceLocation, column, 16);

CHECK_SIZE_ALIGN(SlangReflectionGenericArg, 8, 8);
CHECK_OFFSET(SlangReflectionGenericArg, typeVal, 0);
CHECK_OFFSET(SlangReflectionGenericArg, intVal, 0);
CHECK_OFFSET(SlangReflectionGenericArg, boolVal, 0);

static_assert(SLANG_API_VERSION == 0);
static_assert(SLANG_COMPILE_FLAG_NO_MANGLING == 0x08);
static_assert(SLANG_COMPILE_FLAG_NO_CODEGEN == 0x10);
static_assert(SLANG_COMPILE_FLAG_OBFUSCATE == 0x20);
static_assert(SLANG_TARGET_FLAG_PARAMETER_BLOCKS_USE_REGISTER_SPACES == 0x10);
static_assert(SLANG_TARGET_FLAG_GENERATE_WHOLE_PROGRAM == 0x100);
static_assert(SLANG_TARGET_FLAG_DUMP_IR == 0x200);
static_assert(SLANG_TARGET_FLAG_GENERATE_SPIRV_DIRECTLY == 0x400);
static_assert(slang::CompileCoreModuleFlag::WriteDocumentation == 0x1);
static_assert(static_cast<int>(slang::CompilerOptionName::CountOf) == 159);
static_assert(SLANG_TARGET_COUNT_OF == 37);
static_assert(SLANG_STAGE_COUNT == 17);
static_assert(SLANG_TYPE_KIND_ENUM == 20);
static_assert(SLANG_SCALAR_TYPE_BFLOAT16 == 16);
static_assert(SLANG_SCALAR_TYPE_FLOAT_E5M2 == 18);
static_assert(SLANG_DECL_KIND_ENUM == 7);
static_assert(SLANG_LAYOUT_RULES_DEFAULT_CONSTANT_BUFFER == 3);

using ReflectionDefaultIntSignature =
    SlangResult (*)(SlangReflectionVariable*, int64_t*);
using ReflectionDefaultFloatSignature =
    SlangResult (*)(SlangReflectionVariable*, float*);
using ReflectionAttributeIntSignature =
    SlangResult (*)(SlangReflectionUserAttribute*, unsigned int, int*);
using PendingTypeLayoutSignature =
    SlangReflectionTypeLayout* (*)(SlangReflectionTypeLayout*);
using PendingVariableLayoutFromTypeSignature =
    SlangReflectionVariableLayout* (*)(SlangReflectionTypeLayout*);
using PendingVariableLayoutSignature =
    SlangReflectionVariableLayout* (*)(SlangReflectionVariableLayout*);
using SpecializeFunctionSignature = SlangReflectionFunction* (*)(
    SlangReflectionFunction*, SlangInt, SlangReflectionType* const*);
using SpecializeTypeSignature = SlangReflectionType* (*)(
    SlangReflection*, SlangReflectionType*, SlangInt, SlangReflectionType* const*, ISlangBlob**);
using SpecializeGenericSignature = SlangReflectionGeneric* (*)(
    SlangReflection*,
    SlangReflectionGeneric*,
    SlangInt,
    SlangReflectionGenericArgType const*,
    SlangReflectionGenericArg const*,
    ISlangBlob**);
using EntryPointIntQuerySignature = int (*)(SlangReflectionEntryPoint*);
using BindlessSpaceIndexSignature = SlangInt (*)(SlangReflection*);

static_assert(std::is_same_v<
              decltype(&spReflectionVariable_GetDefaultValueInt),
              ReflectionDefaultIntSignature>);
static_assert(std::is_same_v<
              decltype(&spReflectionVariable_GetDefaultValueFloat),
              ReflectionDefaultFloatSignature>);
static_assert(std::is_same_v<
              decltype(&spReflectionUserAttribute_GetArgumentValueInt),
              ReflectionAttributeIntSignature>);
static_assert(std::is_same_v<
              decltype(&spReflectionTypeLayout_getPendingDataTypeLayout),
              PendingTypeLayoutSignature>);
static_assert(std::is_same_v<
              decltype(&spReflectionTypeLayout_getSpecializedTypePendingDataVarLayout),
              PendingVariableLayoutFromTypeSignature>);
static_assert(std::is_same_v<
              decltype(&spReflectionVariableLayout_getPendingDataLayout),
              PendingVariableLayoutSignature>);
static_assert(std::is_same_v<
              decltype(&spReflectionFunction_specializeWithArgTypes),
              SpecializeFunctionSignature>);
static_assert(std::is_same_v<decltype(&spReflection_specializeType), SpecializeTypeSignature>);
static_assert(std::is_same_v<
              decltype(&spReflection_specializeGeneric),
              SpecializeGenericSignature>);
static_assert(std::is_same_v<
              decltype(&spReflectionEntryPoint_usesAnySampleRateInput),
              EntryPointIntQuerySignature>);
static_assert(std::is_same_v<
              decltype(&spReflectionEntryPoint_hasDefaultConstantBuffer),
              EntryPointIntQuerySignature>);
static_assert(std::is_same_v<
              decltype(&spReflection_getBindlessSpaceIndex),
              BindlessSpaceIndexSignature>);

int main()
{
    std::printf("Slang ABI probe: pointer=%zu\n", sizeof(void*));
    std::printf("GlobalSessionDesc=%zu/%zu TargetDesc=%zu/%zu SessionDesc=%zu/%zu\n",
                sizeof(SlangGlobalSessionDesc),
                alignof(SlangGlobalSessionDesc),
                sizeof(slang::TargetDesc),
                alignof(slang::TargetDesc),
                sizeof(slang::SessionDesc),
                alignof(slang::SessionDesc));
    std::printf("CompilerOptionValue=%zu/%zu CompilerOptionEntry=%zu/%zu SourceLocation=%zu/%zu\n",
                sizeof(slang::CompilerOptionValue),
                alignof(slang::CompilerOptionValue),
                sizeof(slang::CompilerOptionEntry),
                alignof(slang::CompilerOptionEntry),
                sizeof(slang::SourceLocation),
                alignof(slang::SourceLocation));
    return 0;
}
