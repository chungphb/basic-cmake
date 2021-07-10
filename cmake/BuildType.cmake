##############
# BUILD TYPE #
##############

# 1. Build type basics
# - Notes:
#   + The build type affects almost everything about the build.
#   + The default build types provided by CMake:
#     . Debug:              No optimizations and full debug information.
#     . Release:            Full optimizations and no debug information.
#     . RelWithDebInfo:     Most optimizations and most debug information.
#     . MinSizeRel:         Used for constrained resource environments such as embedded devices.
#   + Each build type result in results in a different set of compiler and linker flags.

# 1.1. Single configuration generators
# - Notes:
#   + Some generators, like Makefiles and Ninja, support only a single build type per build directory.
#   + The build type has to be chosen by setting the CMAKE_BUILD_TYPE cache variable.
#   + For example:
#     cmake -G Ninja -DCMAKE_BUILD_TYPE:STRING=Debug ../src
#     cmake --build .
#   + Different build directories should be set up for each build type instead of switching between different build types.

# 1.2. Multiple configuration generators
# - Notes:
#   + Some generators, like XCode and Visual Studio, support multiple configurations in a single build directory.
#   + The build type has to be chosen at build time (the CMAKE_BUILD_TYPE cache variable will be ignored).
#   + For example:
#     cmake -G XCode ../src
#     cmake --build . --config Debug
#   + Switching between builds doesn't cause constant rebuilds.

###########################################################

# 2. Common errors
# - Notes:
#   + Any logic based on CMAKE_BUILD_TYPE within a project is questionable.
#   + Instead of referring to CMAKE_BUILD_TYPE, use other techniques like generator expressions based on $<CONFIG:...>.
#   + When scripting builds, the build type should be specified at both compile time and build time. For example:
#     mkdir build
#     cd build
#     cmake -G Ninja -DCMAKE_BUILD_TYPE=Release ../src
#     cmake --build . --config Release
#   + For single configuration generators, if CMAKE_BUILD_TYPE is not set, the build type is empty.
#     . An empty build type is its own unique, nameless build type.
#     . The behavior is determined by the compiler's and linker's own default behavior.

###########################################################

# 3. Custom build types
# - Notes:
#   + A project may want to limit the set of build types or want to add other custom build types.
#   + There are two main places where a set of build types may be needed:
#     . A drop down-list in the IDE environment when using multi configuration generators.
#     . A combo box of valid choices in CMake GUI application.
#   + For multi configuration generators:
#     . The set of build types is controlled by the CMAKE_CONFIGURATION_TYPES cache variable.
#     . To determine whether a multi configuration generator was being used:
#       [<  CMake 3.9] Check if CMAKE_CONFIGURATION_TYPES is empty (still a prevalent pattern).
#       [>= CMake 3.9] Check if GENERATOR_IS_MULTI_CONFIG is true.
#     . For better robustness, CMake 3.11 should be used for if custom build types are going to be defined.
#     . Developers may add their own types to the CMAKE_CONFIGURATION_TYPES cache variable and/or remove some other ones.
#   + For single configuration generators:
#     . There is one build type and it is specified by the CMAKE_BUILD_SYSTEM cache variables.
#     . Cache variables can have their STRINGS property defined to hold a set of valid values.
#       set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release Profile)
#     . Setting the STRINGS property of a cache variable does not guarantee that the cache variable will hold one of the defined values.
#   + To allow a custom build type to be selected:
#     cmake_minimum_required(3.11)
#     project(foo)
#     if(CMAKE_CONFIGURATION_TYPES)
#       if(NOT "Policies" IN_LIST CMAKE_CONFIGURATION_TYPES)
#         list(APPEND CMAKE_CONFIGURATION_TYPES Profile)
#       endif()
#     else()
#       set(allowableBuildTypes Debug Release Profile)                              # Profile is a custom build type
#       set_property(CMAKE CACHE_BUILD_TYPE PROPERTY STRINGS "${allowableBuildTypes}")
#       if(NOT CMAKE_BUILD_TYPE)
#         set(CMAKE_BUILD_TYPE Debug CACHE STRING "" FORCE)
#       elseif(NOT CMAKE_BUILD_TYPE IN_LIST allowableBuildTypes)
#         message(FATAL_ERROR "Invalid build type: ${CMAKE_BUILD_TYPE}")
#       endif()
#     endif()
#     + Fundamentally, when a build type is selected:
#       . It specifies which configuration-specific variables CMake should use.
#       . It affects any generator expressions whose logic depends on the current configuration.
#     + The following two families of variables are of primary interest:
#       . CMAKE_<LANG>_FLAGS_<CONFIG>
#       . CMAKE_<TARGET_TYPE>_LINKER_FLAGS_<CONFIG>
#     + These can be used to add additional compiler and linker flags over the default set.
#         set(CMAKE_C_FLAGS_PROFILE                 "-p -g -O2" CACHE STRING "")    # Profile is a custom build type
#         set(CMAKE_CXX_FLAGS_PROFILE               "-p -g -O2" CACHE STRING "")    # Profile is a custom build type
#         set(CMAKE_EXE_LINKER_FLAGS_PROFILE        "-p -g -O2" CACHE STRING "")    # Profile is a custom build type
#         set(CMAKE_SHARED_LINKER_FLAGS_PROFILE     "-p -g -O2" CACHE STRING "")    # Profile is a custom build type
#         set(CMAKE_STATIC_LINKER_FLAGS_PROFILE     "-p -g -O2" CACHE STRING "")    # Profile is a custom build type
#         set(CMAKE_MODULE_LINKER_FLAGS_PROFILE     "-p -g -O2" CACHE STRING "")    # Profile is a custom build type
#     + An alternative is to base the compiler and linker flags on one of the other build types and add the extra flags needed.
#         set(CMAKE_C_FLAGS_PROFILE
#           "${CMAKE_C_FLAGS_RELWITHDEBINFO} -p" CACHE STRING "")                   # Profile is a custom build type
#         set(CMAKE_CXX_FLAGS_PROFILE
#           "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -p" CACHE STRING "")                 # Profile is a custom build type
#         set(CMAKE_EXE_LINKER_FLAGS_PROFILE
#           "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} -p" CACHE STRING "")          # Profile is a custom build type
#         set(CMAKE_SHARED_LINKER_FLAGS_PROFILE
#           "${CMAKE_SHARED_FLAGS_RELWITHDEBINFO} -p" CACHE STRING "")              # Profile is a custom build type
#         set(CMAKE_STATIC_LINKER_FLAGS_PROFILE
#           "${CMAKE_STATIC_FLAGS_RELWITHDEBINFO} -p" CACHE STRING "")              # Profile is a custom build type
#         set(CMAKE_MODULE_LINKER_FLAGS_PROFILE
#           "${CMAKE_MODULE_FLAGS_RELWITHDEBINFO} -p" CACHE STRING "")              # Profile is a custom build type
#     + The CMAKE_<CONFIG>_POSTFIX variable can be defined for a custom build type to append a postfix to the file name of the targets.
#         set(CMAKE_PROFILE_POSTFIX _profile)                                       # Profile is a custom build type
#     + The items passed to the target_link_libraries() command can be prefixed with the debug or optimized keywords.

################### RECOMMENDED PRACTICES ###################

# - Don't assume a particular CMake generator is being used.
# - For single configuration generators like Makefiles or Ninja:
#   + Consider using multiple build directories, one for each build type.
#   + Consider setting CMAKE_BUILD_TYPE to a better default value if it is empty.
#   + Avoid creating logic based on CMAKE_BUILD_TYPE unless it is known that a single configuration generator is being used.
# - For multi configuration generators like Makefiles or Ninja:
#   + Only modify the CMAKE_CONFIGURATION_TYPES variable if:
#     . It is known that a multi configuration generator is being used, or
#     . It already exists.
#   + Modify the regular variable instead of the cache variable of the same name when adding/removing a custom build type.
#   + Add/remove individual items rather than completely replacing the list.
# - Use the GENERATOR_IS_MULTI_CONFIG global property to definitively query the generator type for CMake 3.9 or later.
# - To work out a target's output file name, use generator expressions like $<TARGET_FILE:...> instead of querying the LOCATION target property.