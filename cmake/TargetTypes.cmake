################
# TARGET TYPES #
################

# 1. Executables
# - Commands:
#   add_executable(
#     targetName [WIN32] [MACOSX_BUNDLE]
#     [EXCLUDE_FROM_ALL]
#     source1 [source2 ...]
#   )
#   add_executable(targetName IMPORTED [GLOBAL])
#   add_executable(aliasName ALIAS targetName)
# - Usage:
#   + 1st: Generate an executable file and create a CMake target.
#   + 2nd: Create a CMake target for an existing executable rather than one build by the project.
#   + 3rd: Create an ALIAS target.
# - Notes:
#   + IMPORTED
#     . Other parts of the project can treat the imported target like it would any other executable target that the project built itself.
#     . Certain target properties need to be set before it can be useful.
#       IMPORTED_LOCATION
#       IMPORTED LOCATION_<CONFIG>
#     . Without GLOBAL keyword, an imported target will only be visible in the current directory scope and below.
#   + ALIAS
#     . An ALIAS target is just a read-only way to refer to another target within CMake.
#     . Aliases can only point to real targets and they cannot be installed or exported.
#     . [<  CMake 3.11] Imported targets could not be aliased.
#     . [>= CMake 3.11] Imported targets with global visibility could be aliased.

###########################################################

# 2. Libraries
# - Command:
#   add_library(
#     targetName [STATIC | SHARED | MODULE | OBJECT]
#     [EXCLUDE_FROM_ALL]
#     source1 [source2 ...]
#   )
# - Usage: Generate a library and create a CMake target.
# - Notes:
#   + The add_library() command can be used to define object libraries which are just a collection of object files.
#   + [<  CMake 3.12] Object libraries cannot be linked like other library types, they require using a generator expression.
#   + [>= CMake 3.12] Object libraries behave more like other types of libraries, but with some caveats.
#     . Object libraries can be used with target_link_libraries().
#     . However, object files are only added to a target that links directly to the object library, not transitively beyond that.
#   + When there is a choice, static libraries will typically be the convenient choice in CMake projects.

# - Command:
#   add_library(
#     targetName (STATIC | SHARED | MODULE | OBJECT | UNKNOWN)
#     IMPORTED [GLOBAL]
#   )
# - Usage: Create a CMake target for an existing library rather than one build by the project.
# - Notes:
#   + The library type must be given immediately after the target name.
#   + The location on the filesystem that the imported target represents needs to be specified.
#     . General:                IMPORTED_LOCATION, IMPORTED_LOCATION_<CONFIG>
#     . For Windows:            IMPORTED_LOCATION, IMPORTED_IMPLIB
#     . For object libraries:   IMPORTED_OBJECTS
#   + Imported libraries also support a number of other target properties.
#   + The GLOBAL keyword can be given to make them have global visibility instead, just like other regular targets.
#   + For example:
#     add_library(myObjLib OBJECT IMPORTED)
#     set_target_properties(myObjLib PROPERTIES
#       IMPORTED_OBJECTS /some/path/obj1.obj /some/path/obj2.obj
#     )
#     add_executable(myExe $<TARGET_SOURCES:myObjLib>)

# - Command: add_library(targetName INTERFACE [IMPORTED [GLOBAL]])
# - Usage: Create an interface library.
# - Notes:
#   + Interface libraries do not usually represent a physical library.
#     . They serve as a collect usage requirements and dependencies to be applied to anything that links to them (E.g. Header-only libraries).
#     . For example:
#       add_library(myHeaderOnlyLib INTERFACE)
#       target_include_directories(myHeaderOnlyLib
#         INTERFACE /some/path/include
#       )
#       target_compile_definitions(myHeaderOnlyLib
#         INTERFACE SOME_FEATURE=1 $<$<COMPILE_FEATURES:cxx_std_11>:HAVE_CXX11>
#       )
#       add_executable(myExe ...)
#       target_link_libraries(myExe PRIVATE myHeaderOnlyLib)
#   + Another use of interface libraries is to provide a convenience for linking in a larger set of libraries.
#     . For example:
#       add_library(myLib1 ...)
#       add_library(myLib2 ...)
#       add_library(myLibAll INTERFACE)
#       target_link_libraries(myLibAll INTERFACE myLib1 $<$<BOOL:${ENABLE_LIB_2}>:myLib2>)
#       add_executable(myExe ...)
#       target_link_libraries(myExe PRIVATE myLibAll)
#     . This is an example of using an interface to abstract away details of what is actually going to be linked, defined etc.
#   + An INTERFACE IMPORTED library is an INTERFACE library exported or installed for use outside of the project.

# - Command: add_library(aliasName ALIAS otherTarget)
# - Usage: Act as a read-only way to refer to another library but does not create a new build target.
# - Notes:
#   + For each library, a matching alias library with a name of the form projNamespace:targetName should also be created.
#     . Motivation
#       When the project is installed and something else links to the imported targets created by the installed/packaged config files.
#       These config files would define imported libraries with the namespaced names rather than the bare original names.
#       The consuming project would then link against the namespaced names.
#     . For example:
#       find_package(myPackage REQUIRED)
#       add_executable(myExe ...)
#       target_link_libraries(myExe PRIVATE myPackage::myLib)
#   + CMake always treated names having a double-colon (::) as the name of an alias or imported target.
#   + Projects should always define namespaced aliases at least for all targets that are intended to be installed/packaged.

###########################################################

# 3. Promoting imported targets
# - Notes:
#   + Imported targets are mainly used as part of a Find module or package config file.
#   + Anything defined by a Find module or package config file is generally expected to have local visibility.
#   + There are situations where imported targets need to be created with global visibility.
#     . Adding the GLOBAL keyword when creating the imported library achieve this.
#     . However, the project may not be in control of the command that does the creation.
#   + [CMake 3.11] An imported target can be promoted to global visibility by setting its IMPORTED_GLOBAL property to true.
#     . This is a one-way transition.
#     . For example:
#       add_library(someLibBuiltElsewhere STATIC IMPORTED)
#       set_target_properties(someLibBuiltElsewhere
#         IMPORTED_LOCATION /path/to/libSomething.a
#       )
#       set_target_properties(someLibBuiltElsewhere PROPERTIES
#         IMPORTED_GLOBAL TRUE
#       )
#   + An imported target can only be promoted if it is defined in exactly the same scope as the promotion.

################### RECOMMENDED PRACTICES ###################

# - Become familiar with interface libraries.
#   + Use them to represent the details of header-only libraries, collections of resources and many other scenarios .
#   + Strongly prefer using them over trying to achieve the same result with variables or directory-level commands alone.
# - Become familiar with using imported targets.
#   + Try to understand all the ins and outs of how they are defined when wring Find modules or manually creating config files for a package.
#   + Refer to an external tool or library through an imported target if one is available.
# - Prefer defining static libraries over object libraries.
# - Don't use target names that are too generic.
# - Consider adding an alias namespace::... target for each target that is not private to the project.
# - Use an alias target to provide an old name for a renamed target.
# - When splitting up a library, define an interface library with the old name and have it define link dependencies to the new libraries.