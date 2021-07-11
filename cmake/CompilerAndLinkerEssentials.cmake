##################################
# COMPILER AND LINKER ESSENTIALS #
##################################

# Notes:
# - As CMake has evolved, the available methods for controlling the compiler and linker behavior have also improved.
# - The focus has shifted:
#   + From a more build-global view to one where the requirements for each individual target can be controlled.
#   + Along with how those requirements should or should not be carried across to any other targets that depend on it.

# 1. Target properties

# 1.1. Compiler flags
# - Notes:
#   + The most fundamental target properties for controlling compiler flags are the following:
#     . INCLUDE_DIRECTORIES:    A list of directories to be used as header search paths.
#     . COMPILE_DEFINITIONS:    A list of definitions to be set on the compile command line.
#     . COMPILE_OPTIONS:        Any compiler flags that are neither header search paths nor symbol definitions.
#   + Each of the three target properties above has a related target property with the same name, only with INTERFACE_ prepended.
#     . Instead of applying to the target itself, they apply to any other target which links directly to it.
#     . The specify compiler flags which consuming targets should inherit.
#   + Initial values:
#     . INCLUDE_DIRECTORIES:    Taken from the directory property of the same name.
#     . COMPILE_DEFINITIONS:    Empty.
#     . COMPILE_OPTIONS:        Taken from the directory property of the same name.
#     . INTERFACE_...:          Empty.
#   + All of the above target properties support generator expressions.
#   + To manipulate compiler flags at the individual source file level, CMake provides the following source file properties:
#     . COMPILE_DEFINITIONS
#     . COMPILE_FLAGS
#     . COMPILE_OPTIONS

# 1.2. Linker flags
# - Notes:
#   + The target properties associated with linker flags have similarities to those for the compiler flags:
#     . LINK_LIBRARIES:         A list of all libraries the target should link to directly.
#     . LINK_FLAGS:             A list of flags to be passed to the linker for targets that are executables, shared libraries and module libraries.
#     . STATIC_LIBRARY_FLAGS:   A list of flags to be passed to the linker for targets that are static libraries.
#   + Initial values and generator expressions support:
#     . LINK_LIBRARIES:         Empty.                  Support generator expressions.
#     . LINK_FLAGS:             Empty.                  Don't support generator expressions.
#     . STATIC_LIBRARY_FLAGS:   Empty.                  Don't support generator expressions.
#   + Only LINK_LIBRARIES has an equivalent interface property, INTERFACE_LINK_LIBRARIES.
#   + The LINK_FLAGS and STATIC_LIBRARY_FLAGS have related configuration-specific properties:
#     . LINK_FLAGS_<CONFIG>
#     . STATIC_LIBRARY_FLAGS_<CONFIG>

# 1.3. Target property commands
# - Notes:
#   + The above target properties are not normally manipulated directly.

# - Command:
#   target_link_Libraries(
#     targetName
#     <PRIVATE|PUBLIC|INTERFACE> item1 [item2 ...]
#     [<PRIVATE|PUBLIC|INTERFACE> item3 [item4 ...]]
#     ...
#   )
# - Usage: Add libraries to the LINK_LIBRARIES and INTERFACE_LINK_LIBRARIES target properties.
# - Notes:
#   + When using the keyword:
#     . PRIVATE:                    Items listed after PRIVATE only affect the behavior of targetName itself.
#     . INTERFACE:                  Items listed after INTERFACE affect on targets that link to targetName.
#     . PUBLIC:                     Is equivalent to combining the effects of PRIVATE and INTERFACE.
#   + This is similar to the behavior of the other target_...() commands.

# - Command:
#   target_include_directories(
#     targetName [BEFORE] [SYSTEM]
#     <PRIVATE|PUBLIC|INTERFACE> dir1 [dir2 ...]
#     [<PRIVATE|PUBLIC|INTERFACE> dir3 [dir4 ...]]
#     ...
#   )
# - Usage: Add header search paths to the INCLUDE_DIRECTORIES and INTERFACE_INCLUDE_DIRECTORIES target properties.
# - Notes:
#   + Each time target_include_directories() is called, the specified directories are appended to the relevant target properties.
#   + If the SYSTEM keyword is specified, the compiler will treat the listed directories as system include paths on some platforms.
#     . This will skip certain compiler warnings or change how the file dependencies are handled.
#     . In general, SYSTEM is intended for paths outside of the project.
#   + Unlike manipulating the target properties directly, projects can specify relative directories, not just absolute directories.
#   + Generator expressions can be used in target_include_directories():
#     . $<BUILD_INTERFACE:...>      Allow different paths to be specified for building.
#     . $<INSTALL_INTERFACE:...>    Allow different paths to be specified for installing.

# - Command:
#   target_compile_definitions(
#     targetName
#     <PRIVATE|PUBLIC|INTERFACE> item1 [item2 ...]
#     [<PRIVATE|PUBLIC|INTERFACE> item3 [item4 ...]]
#     ...
#   )
# - Usage: Add compile definitions to the COMPILE_DEFINITIONS and INTERFACE_COMPILE_DEFINITIONS target properties.
# - Notes:
#   + Each item has the form VAR or VAR=VALUE.
#   + Generator expressions are supported.

# - Command:
#   target_compile_options(
#     targetName [BEFORE]
#     <PRIVATE|PUBLIC|INTERFACE> item1 [item2 ...]
#     [<PRIVATE|PUBLIC|INTERFACE> item3 [item4 ...]]
#     ...
#   )
# - Usage: Add compile definitions to the COMPILE_DEFINITIONS and INTERFACE_COMPILE_DEFINITIONS target properties.
# - Notes:
#   + Each item is treated as a compiler option.
#   + Each item is appended to existing target property values, but the BEFORE keyword can be used to prepend instead.
#   + Generator expressions are supported.

###########################################################

# 2. Directory properties and commands
# - Notes:
#   + [>= CMake 3.0] Target properties are strongly preferred for specifying compiler and linker flags.
#   + [<  CMake 3.0] Target properties were much less prominent are properties were often specified at the directory level instead.

# - Command: include_directories([AFTER | BEFORE] [SYSTEM] dir1 [dir2 ...])
# - Usage: Add header search paths to targets created in the current directory scope and below.
# - Notes:
#   + By default, paths are appended to the existing list of directories.
#     . This default can be changed by setting CMAKE_INCLUDE_DIRECTORIES_BEFORE to ON.
#     . It can also be controlled on a per call basis with the BEFORE and AFTER options.
#   + The paths provided to include_directories() can be relative or absolute.
#   + There are two main effects of calling include_directories():
#     . The listed paths are added to the INCLUDE_DIRECTORIES directory property of the current CMakeLists.txt file.
#     . Any targets created in the current CMakeLists.txt file will also have the paths added to their INCLUDE_DIRECTORIES target property.
#       (Even if those targets were created before the call to include_directories())
#   + If the include_directories() command must be used, prefer to call it early in a CMakeLists.txt file.

# - Commands:
#   add_definitions(-DSomeSymbol /DFoo=Value ...)
#   remove_definitions(-DSomeSymbol /DFoo=Value ...)
# - Usage: Add and remove entries in the COMPILE_DEFINITIONS directory property.
# - Notes:
#   + These two commands affect all targets created in the current CMakeLists.txt file, even those create before the call.
#   + Targets created in child directory scopes will only be affected if created after the call.
#   + It is also possible to specify compiler flags other than definitions with these commands.
#   + Generator expressions are supported, but should only be used for the value part of a definition.
#   + [CMake 3.12] Due to its shortcomings, add_definitions() command is replaced by add_compile_definitions() command.
#     . Command: add_compile_definitions(SomeSymbol Foo=Value ...)
#     . This command still affects all targets created in the same directory scope.

# - Command: add_compile_options(opt1 [opt2 ...])
# - Usage: Provide arbitrary compiler options.
# - Notes:
#   + Unlike the other commands, its behavior is very straightforward and predictable.
#   + Any targets created before the call are not affected.

# - Commands:
#   link_libraries(items1 [item2 ...] [debug | optimized | general | item] ...)
#   link_directories(dir1 [dir2 ...])
# - Usage: Link libraries into other targets.
# - Notes:
#   + They affects all targets created in the current directory scope and below after the commands are called.
#   + When an item is preceded by the keyword:
#     . debug:                      Apply to just the Debug build type.
#     . optimized:                  Apply to all build types except Debug.
#     . general:                    Apply to all build types.
#   + The use of these keywords is strongly discouraged.
#   + The directories added by link_directories() only have an effect when CMake is given a bare library name to link to.

###########################################################

# 3. Compiler and linker variables
# - Notes:
#   + Properties are the main way the projects should seek to influence compiler and linker flags.
#   + However, for situations where the user want to add their own compiler or linker flags, variables are more appropriate.
#   + CMake provided a set of variables that specify compiler and linker flags.
#   + These are normally cache variables, but they can also be set as regular CMake variables.

# - Variables:
#   CMAKE_<LANG>_FLAGS
#   CMAKE_<LANG>_FLAGS_<CONFIG>
# - Usage: Set compiler flags.
# - Notes:
#   + The first variable applied to all build types.
#   + The second variable is only applied to the build type specified by <CONFIG>.
#   + The first project() command encountered will create cache variables for these if they don't already exist.

# - Variables:
#   CMAKE_<TARGET_TYPE>_LINKER_FLAGS
#   CMAKE_<TARGET_TYPE>_LINKER_FLAGS_<CONFIG>
# - Usage: Set linker flags.
# - Notes:
#   + These are specific to a particular type of target. The target type must be one of the following:
#     . EXE
#     . SHARED
#     . STATIC
#     . MODULE

# - Common mistakes:
#   + Compiler/linker variables are single strings, not lists.
#   + Distinguish between cache and non-cache variables.
#     . All of the variables mentioned above are cache variables and can be overridden by non-cache variables.
#     . Problems can arise when a project tries to force updating cache variables.
#     . Projects should prefer to set a non-cache variable rather than the cache variable.
#   + Prefer appending over replacing flags.
#     . Where possible, projects should prefer to append flags to the existing value instead of replacing them.
#     . One exception to this is when a project is required to enforce a mandated set of compiler or linker flags.
#   + Understand when variable values are used.
#     . When a variable is updated multiple times, only the value at the end of processing for that directory scope will get used.
#     . This delayed nature of the compiler and linker variables make them very fragile to work with.

################### RECOMMENDED PRACTICES ###################

# - Use the target_...() commands() to describe relationships between targets and to modify compiler and linker behavior.
# - Avoid the directory property commands.
# - Avoid direct manipulation of the target and directory properties that affect compiler and linker behavior.
# - Avoid modifying the various CMAKE_..._FLAGS variables and their configuration specific counterparts.
# - Become familiar with the concepts of PRIVATE, PUBLIC and INTERFACE relationships.
#   + Start with a dependency as PRIVATE and only make it PUBLIC when the dependency is clearly needed by those linking to the target.
#   + Use INTERFACE keyword:
#     . For imported/interface library targets.
#     . To add missing dependencies to a target defined in a part of the project which the developer may not be allowed to change.