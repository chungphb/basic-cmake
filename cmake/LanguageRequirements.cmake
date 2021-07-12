#########################
# LANGUAGE REQUIREMENTS #
#########################

# Notes
# - There are two main methods for specifying language requirements:
#   + To set the language requirement directly.
#   + To allow projects to specify the language features they need and let CMake select the appropriate language standard.

# 1. Setting the language standard directly
# - Notes:
#   + The simplest way to control the language standards used by a build is to set them directly.
#   + This approach ensures that the same standard is used throughout a project.
#   + There are 3 target properties related to specifying the standard:
#     . <LANG>_STANDARD
#         Specifies the language standard the project wants to use for the specified target.
#     . <LANG>_STANDARD_REQUIRED
#         Determines whether the language standard is treated as a minimum requirement or as just a "use if available" guideline.
#     . <LANG>_EXTENSIONS
#         Controls whether compiler extensions are enabled for the specified target.
#   + Projects should set the variables that provide the defaults for the above target properties rather than the target properties directly.
#   + Projects should set all three properties/variables rather than just some of them.
#   + For example:
#     # Require C++11 and disable extensions for all targets
#     set(CMAKE_CXX_STANDARD            11)
#     set(CMAKE_CXX_STANDARD_REQUIRED   ON)
#     set(CMAKE_CXX_EXTENSIONS          OFF)
#     # Use C++14 if available and allow compiler extensions for all targets
#     set(CMAKE_CXX_STANDARD            14)
#     set(CMAKE_CXX_STANDARD_REQUIRED   OFF)
#     set(CMAKE_CXX_EXTENSIONS          ON)

###########################################################

# 2. Setting the language standard by feature requirements
# - Notes:
#   + Developers may prefer to state which language features their code uses and leave CMake to select the appropriate language standard.
#   + Compile feature requirements are controlled by the target properties COMPILE_FEATURES and INTERFACE_COMPILE_FEATURES.
#   + However, these properties are typically populated using the target_compile_features() command.

# - Command:
#   target_compile_features(targetName
#     <PRIVATE|PUBLIC|INTERFACE> feature1 [feature2 ...]
#     <PRIVATE|PUBLIC|INTERFACE> feature3 [feature4 ...]
#     ...
#   )
# - Usage: Add compile feature requirements to the COMPILE_FEATURES and INTERFACE_COMPILE_FEATURES target properties.
# - Notes:
#   + Each feature must be one of the features supported by the underlying compiler. There are two lists of known features:
#     . CMAKE_<LANG>_KNOWN_FEATURES     Contains all known features for the language.
#     . CMAKE_<LANG>_COMPILE_FEATURES   Contains only those features supported by the compiler.
#   + Not all functionality provided by a particular language version can be explicitly specified.
#   + [>= CMake 3.8] A per language meta-feature is available to indicate a particular language standard rather than a specific compile feature.
#     For example: target_compile_features(targetName PUBLIC cxx_std_14)
#   + When a target has both its <LANG>_STANDARD property set and compile features specified, CMake will enforce the stronger standard requirement.

# 2.1. Detection and use of optional language features
# - Notes:
#   + Generator expressions can be used to conditionally set compiler defines or include directories based on the availability of a compiler feature.
#   + For example:
#     # CMakeLists.txt
#     add_library(foo ...)
#     target_compile_features(foo PUBLIC
#       $<$<COMPILE_FEATURES:cxx_override>:cxx_override>
#     )
#     target_compile_definitions(foo PUBLIC
#       $<$<COMPILE_FEATURES:cxx_override>:-Dfoo_OVERRIDE=override>
#       $<$<NOT:$<COMPILE_FEATURES:cxx_override>>:-Dfoo_OVERRIDE>
#     )
#
#     # C++ source file
#     class Foo : public Base {
#     public:
#       void func() foo_OVERRIDE;
#     }
#   + A number of other features can also have a similar conditionally defined symbol.
#   + CMake covers the supported and unsupported cases for multiple features through its module system.

# - Command:
#   write_compiler_detection_header(
#     FILE          fileName
#     PREFIX        prefix
#     COMPILERS     compiler1 [compiler2 ...]
#     FEATURES      feature1 [feature2 ...]
#   )
# - Module: WriteCompilerDetectionHeader.
# - Usage: Produces a header file that the project's sources can #include to pick up appropriately specified compiler defines.
# - Notes:
#   + For example:
#     # CMakeLists.txt
#     include(WriteCompilerDetectionHeader)
#     write_compiler_detection_header(
#       FILE        foo_compiler_detection.h
#       PREFIX      foo
#       COMPILERS   GNU Clang MSVC Intel
#       FEATURES    cxx_override cxx_final cxx_nullptr cxx_rvalue_references
#     )
#
#     # C++ source file
#     #include "foo_compiler_detection.h"
#     class Foo foo_FINAL : public Base {
#     public:
#     #if foo_COMPILER_CXX_RVALUE_REFERENCES
#       Foo(Foo&& foo);
#     #endif
#       void func1() foo_OVERRIDE;
#       void func2(int* ptr = foo_NULLPTR);
#     }

################### RECOMMENDED PRACTICES ###################

# - Avoid setting compiler and linker flags directly to control the language standard used.
# - To control language standard requirements:
#   + Use the CMAKE_<LANG>_STANDARD, CMAKE_<LANG>_STANDARD_REQUIRED and CMAKE_<LANG>_EXTENSIONS variables.
#   + Always set three variables together.
# - To enforce language standard for some targets and not others:
#   + Use the <LANG>_STANDARD, <LANG>_STANDARD_REQUIRED and <LANG>_EXTENSIONS target properties.
#   + Prefer using the variables unless the project has a need for different language standard behavior for different targets.
# - [>= CMake 3.8] Use compile features to specify the desired language standard on a per target basis.
#   + Enforce a language requirement transitively on other targets via PUBLIC and INTERFACE relationships.
#   + Still need to use CMAKE_<LANG>_EXTENSIONS or <LANG>_EXTENSIONS to control whether or not compiler extensions are allowed.
# - Use the variables or properties to set the language requirements at a high level for better maintainability and robustness.
# - Or, use a compile meta feature like cxx_std_11 to avoid many problems of setting individual features.
# - Use features supporting detecting available compile features as a transition path when updating an older code base.