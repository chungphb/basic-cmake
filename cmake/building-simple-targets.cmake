###########################
# BUILDING SIMPLE TARGETS #
###########################

# - Command: add_library(targetName [STATIC | SHARED | MODULE] [EXCLUDE_FROM_ALL] source1 [source2...])
#   + STATIC: Specify a static library or an archive. (.lib on Windows and .a on Unix-like platforms)
#   + SHARED: Specify a shared or dynamically linked library. (.dll on Windows, .dylib on Apple platforms and .so on Unix-like platforms)
# - Usage: Generate a library and creates a CMake target.

add_library(module ${CMAKE_CURRENT_SOURCE_DIR}/src/module.cpp)

# - Command:
#   target_include_directories(targetName
#	  <PUBLIC | PRIVATE | INTERFACE> item1 [item2...]
#	  <PUBLIC | PRIVATE | INTERFACE> item3 [item4...]
#     ...
#   )
#   + PRIVATE:
#     . Specify that library A uses library B in its internal implementation.
#     . Anything else that links to library A doesn't need to know about B.
#   + PUBLIC:
#     . Specify that not only does library A use library B internally, it also uses B in its interface.
#     . Anything else that links to library A doesn't need to know about B.
#   + INTERFACE:
# - Usage: Add an include directory to a target.

target_include_directories(module PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

# - Command: add_executable(targetName [WIN32] [MACOSX_BUNDLEX] [EXCLUDE_FROM_ALL] source1 [source2...])
#   + WIN32: Build a Windows GUI application.
#   + MACOSX_BUNDLE: Build an app bundle on Apple platform.
#   + EXCLUDE_FROM_ALL: Exclude the target from the default ALL target.
# - Usage: Generate an executable file and create a CMake target.

add_executable(main ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp)

# - Command:
#   target_link_libraries(targetName
#	  <PUBLIC | PRIVATE | INTERFACE> item1 [item2...]
#	  [<PUBLIC | PRIVATE | INTERFACE> item3 [item4...]]
#     ...
#   )
# - Usage: Adds
#   + A dependency if the target is given, or
#   + A link to a library if no target of that name exists, or
#   + A full path to a library, or
#   + A linker flag

target_link_libraries(main PUBLIC module)

################### RECOMMENDED PRACTICES ###################

# - Target names should not be related to the project name.
# - Avoid starting or ending a library target name with "lib".
# - Avoid specifying the STATIC or SHARED keyword for a library unless needed.
# - Always specify PRIVATE, PUBLIC or INTERFACE keywords when calling the target_link_libraries() command.