###########
# MODULES #
###########

# Notes:
# - Modules are pre-built chunks of CMake code built on top of the core language features.
# - Modules are collected together and provided in a single directory as part of a CMake release.

# - Command: include(module [OPTIONAL] [RESULT_VARIABLE myVar] [NO_POLICY_SCOPE])
# - Usage: Employ a module.
# - Notes:
#   + The include() command will look for a file whose name is the name of the module with .cmake appended.
#   + When looking for a module's file:
#     . CMake first consults the variable CMAKE_MODULE_PATH.
#     . CMake then search in its own internal module directory.
#   + A common pattern is to store module files in a single directory and add it to the CMAKE_MODULE_PATH.
#   + Note: If the file calling include() is inside CMake's own internal module directory, that directory will be searched first.

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules")
include(SampleModule)

# - Command: find_package(PackageName)
# - Usage: Employ a module.
# - Notes:
#   + The behavior is similar to include().
#   + However, CMake will search for a file called FindPackageName.cmake rather than PackageName.cmake.

find_package(SamplePackage)

# 1. Useful development aids
# - Module: CMakePrintHelpers.
# - Usage: Provide two macros which make printing the values of properties and variables more convenient.
# - Commands:
#   cmake_print_properties(
#     [TARGETS target1 [target2...]]
#     [SOURCES source1 [source2...]]
#     [DIRECTORIES dir1 [dir2...]]
#     [TESTS test1 [test2...]]
#     [CACHE_ENTRIES var1 [var2...]]
#     PROPERTIES prop1 [prop2...]
#   )
#   cmake_print_variables(var1 [var2...])

include(CMakePrintHelpers)
cmake_print_properties(TARGETS module PROPERTIES TYPE ALIASED_TARGET)
cmake_print_properties(TARGETS main PROPERTIES TYPE ALIASED_TARGET)

set(var1 1)
set(var2 2)
cmake_print_variables(var1 var2 CMAKE_VERSION)

message(${LINE})

############################################################

# 2. Endianness
# - Module: TestBigEndian.
# - Usage: Provide the test_big_endian() macro which compiles a small program to determine the endianness of the target.
# - Command:
#   test_big_endian(resultVar)

include(TestBigEndian)
test_big_endian(isBigEndian)
message("Is the system big endian: ${isBigEndian}")

message(${LINE})

############################################################

# 3. Checking existence and support
# - Modules: Check<LANG>SourceCompiles.
# - Usage: Compile and link a short test file into an executable and return a success/fail result.
# - Commands:
#   check_c_source_compiles(code resultVar [FAIL_REGEX regex])
#   check_cxx_source_compiles(code resultVar [FAIL_REGEX regex])
#   check_fortran_source_compiles(code resultVar [FAIL_REGEX regex])
# - Notes:
#   + A number of variables of the form CMAKE_REQUIRED_... can be set before calling any of the compilation test macros.
#     . CMAKE_REQUIRED_FLAGS
#     . CMAKE_REQUIRED_DEFINITIONS
#     . CMAKE_REQUIRED_INCLUDES
#     . CMAKE_REQUIRED_LIBRARIES
#     . CMAKE_REQUIRED_QUIET

include(CheckCSourceCompiles)
check_c_source_compiles("
        int main(int argc, char** argv) {
            int var;
            return 0;
        }" noWarnUnused FAIL_REGEX "[Ww]arn")
if(noWarnUnused)
    message("Unused variables do not generate warnings by default")
else()
    message("Compile successfully")
endif()

# - Modules: Check<LANG>SourceRuns.
# - Usage: Test whether C or C++ code can be executed successfully.
# - Commands:
#   check_c_source_runs(code resultVar)
#   check_cxx_source_runs(code resultVar)

include(CheckCSourceRuns)
check_c_source_runs("
        int main(int argc, char** argv) {
            int var;
            return 0;
        }" result)
if(result)
    message("Run successfully")
else()
    message("Run failed")
endif()

# - Modules: Check<LANG>CompilerFlag.
# - Usage: Check compiler flags.
# - Commands:
#   check_c_compiler_flag(flag resultVar)
#   check_cxx_compiler_flag(flag resultVar)
#   check_fortran_compiler_flag(flag resultVar)

# - Modules: CheckSymbolExists/CheckCXXSymbolExists.
# - Usage: Check whether a particular symbol exists as either a pre-processor symbol, a function or a variable.
# - Commands:
#   check_symbol_exists(symbol headers resultVar)
#   check_cxx_symbol_exists(symbol headers resultVar)
# - Notes:
#   + There are limitations on the sort of functions and variables that can be checked by these macros.
#   + More detailed checks are provided by other modules.

include(CheckSymbolExists)
check_symbol_exists(sprintf stdio.h HAVE_SPRINTF)
message("Does stdio.h contain sprintf? ${HAVE_SPRINTF}")

# - Module: CMakePushCheckState
# - Usage: Save and restore the state before and after the checks.
# - Commands:
#   cmake_push_check_state([RESET])
#   cmake_pop_check_state()
#   cmake_reset_check_state()

include(CheckSymbolExists)
include(CMakePushCheckState)

cmake_push_check_state()
cmake_reset_check_state()
set(CMAKE_REQUIRED_FLAGS -Wall)
check_symbol_exists(MODULE_VERSION include/modules/version.h SUBMODULE_ENABLED)

if(SUBMODULE_ENABLED)
    cmake_push_check_state()
    set(CMAKE_REQUIRED_INCLUDES include/modules/submodule.h)
    check_symbol_exists(SUBMODULE_VAR include/modules/submodule.h VAR_DEFINED)
    if(VAR_DEFINED)
        message("Hello world!")
    endif()
    cmake_pop_check_state()
endif()

cmake_pop_check_state()

message(${LINE})

################### RECOMMENDED PRACTICES ###################

# - Use CMAKE_MODULE_PATH instead of hard-coding paths across complex directory structures in include() calls.
# - Use the CMakePushCheckState module wherever possible.