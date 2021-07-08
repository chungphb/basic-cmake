########################
# USING SUBDIRECTORIES #
########################

# Notes:
# - Two fundamental CMake commands in any multi-directory project are add_subdirectory() and include().
# - These commands allow the build logic to be distributed across the directory hierarchy.
# - With these commands:
#   + Build logic is localized.
#   + Builds can be composed of subcomponents which are defined independently from the top level project.
#   + Parts of the build can be turned on or off simply by choosing whether to add in that directory.

set(LINE "========================================")

# 1. add_subdirectory()
# - Command: add_subdirectory(sourceDir [binaryDir] [EXCLUDE_FROM_ALL])
# - Usage: Allow a project to bring another directory into the build.
# - Notes:
#   + If the binary directory is omitted, CMake creates in the build tree a directory with the same name as the source directory.
#   + The optional EXCLUDE_FROM_ALL keyword controls whether targets defined in the subdirectory being added should be included in the ALL target.

message(">>>> BEFORE <<<<")

# 1.1. Source and binary directory variables
# - Variable: CMAKE_SOURCE_DIR
# - Usage: The top-most directory of the source tree.

message("top: CMAKE_SOURCE_DIR         = ${CMAKE_SOURCE_DIR}")

# - Variable: CMAKE_BINARY_DIR
# - Usage: The top-most directory of the build tree.

message("top: CMAKE_BINARY_DIR         = ${CMAKE_BINARY_DIR}")

# - Variable: CMAKE_CURRENT_SOURCE_DIR
# - Usage: The directory of the CmakeLists.txt file currently being processed by CMake.

message("top: CMAKE_CURRENT_SOURCE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}")

# - Variable: CMAKE_CURRENT_BINARY_DIR
# - Usage: The build directory corresponding to the CMakeLists.txt file currently being processed by CMake.

message("top: CMAKE_CURRENT_BINARY_DIR = ${CMAKE_CURRENT_BINARY_DIR}")

# 1.2. Scope
# - Notes:
#   + Calling add_subdirectory() creates a new scope for processing that directory CMakeLists.txt file.
#     . All variables defined in the calling scope will be visible to the child scope.
#     . Any new variable created in the child scope will not be visible to the calling scope.
#     . Any change to a variable in the child scope is local to that child scope.
#   + The child scope receives a copy of all of the variables defined in the calling scope up to that point.

set(myVar "Hello world!")
message("top: myVar                    = ${myVar}")
message("top: childVar                 = ${childVar}")

# - Notes:
#   + Sometimes, it is desirable for a variable change made in an added directory to be visible to the caller.
#   + This is the purpose of the PARENT_SCOPE keyword in the set() command.
#   + IMPORTANT: The PARENT_SCOPE keyword does not set the variable in both the parent and the current scope, only in the parent scope.

set(parentVar "I love you!")
message("top: parentVar                = ${parentVar}")

add_subdirectory(src)

message(">>>> AFTER <<<<")
message("top: CMAKE_CURRENT_SOURCE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}")
message("top: CMAKE_CURRENT_BINARY_DIR = ${CMAKE_CURRENT_BINARY_DIR}")
message("top: myVar                    = ${myVar}")
message("top: childVar                 = ${childVar}")
message("top: parentVar                = ${parentVar}")

message(${LINE})

############################################################

# 2. include()
# - Command:
#   include(fileName [OPTIONAL] [RESULT_VARIABLE myVar] [NO_POLICY_SCOPE])
# - Usage: Allow a project to bring another directory into the build.
# - Notes:
#   + Differences from add_subdirectory():
#     . include() expects a file (typically has the extension .cmake), add_subdirectory() expects a directory.
#     . include() does not introduce a new variable scope.
#     . include() can be told not to introduce a new policy scope.
#     . include() does not change the value of CMAKE_CURRENT_SOURCE_DIR and CMAKE_CURRENT_BINARY_DIR variables.
#   + The included file can determine the directory in which it resides and its own name by using an additional set of variables:
#     . CMAKE_CURRENT_LIST_DIR
#     . CMAKE_CURRENT_LIST_FILE
#     . CMAKE_CURRENT_LIST_LINE

include(src/sample.cmake)

############################################################

# 3. Ending processing early
# - Command: return()
# - Usage: Stop processing the remainder of the current file and return control back to the caller.

include(src/sample2.cmake)
include(src/sample2.cmake)
include(src/sample2.cmake)

# - Command: include_guard()
# - Usage: Similar to #pragma once of C/C++.

################### RECOMMENDED PRACTICES ###################

# - Use the add_subdirectory() command instead of the include() command in simple projects.
# - Use the CMAKE_CURRENT_LIST_DIR variable instead of the CMAKE_CURRENT_SOURCE_DIR variable.
# - Use the include_guard() command over an explicit if-endif block.