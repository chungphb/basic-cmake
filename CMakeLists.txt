cmake_minimum_required(VERSION 3.12)

project(basic-cmake VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

########################
# BUILD SIMPLE TARGETS #
########################

# - Structure: add_library(targetName [STATIC | SHARED | MODULE] [EXCLUDE_FROM_ALL] source1 [source2...])
#   + STATIC: Specifies a static library or archive (.lib on Windows and .a on Unix-like platforms)
#   + SHARED: Specifies a shared or dynamically linked library (.dll on Windows, .dylib on Apple platforms and .so on Unix-like platforms)
# - Functionality: Generates a library and creates a CMake target

add_library(module module.cpp include/module/module.h include/module/util.h)

# - Structure: 
# target_include_directories(targetName
#	<PUBLIC | PRIVATE | INTERFACE> item1 [item2...]
#	<PUBLIC | PRIVATE | INTERFACE> item3 [item4...]
#   ...
# )
#   + PRIVATE:
#     . Specifies that library A uses library B in its internal implementation
#     . Anything else that links to library A doesn't need to know about B
#   + PUBLIC:
#     . Specifies that not only does library A use library B internally, it also uses B in its interface
#     . Anything else that links to library A doesn't need to know about B
#   + INTERFACE: 
# - Functionality: Adds an include directory to a target


target_include_directories(module PUBLIC include)

# - Structure: add_executable(targetName [WIN32] [MACOSX_BUNDLEX] [EXCLUDE_FROM_ALL] source1 [source2...])
#   + WIN32: Builds the executable as a Windows GUI application
#   + MACOSX_BUNDLE: Builds an app bundle when building on Apple platform
#   + EXCLUDE_FROM_ALL: Excludes the target from the default ALL target built when no target is specified at build time
# - Functionality: Generates an executable file and create a CMake target

add_executable(main main.cpp)

# Adds:
# - A dependency if the target is given, or 
# - A link to a library if no target of that name exists, or
# - A full path to a library, or
# - A linker flag

target_link_libraries(main PUBLIC module)

#############
# VARIABLES #
#############

# 1. Variable basics
# - Structure: set(varName value... [PARENT_SCOPE])

set(var "Hello world!") # var = "Hello world"
set(var 1 2 3) # var = "1;2;3"

set(var1 "x") # var1 = "x"
set(var2 ${var1}) # var2 = var1 = "x"
set(var3 ${var1} y z) # var3 = "x;y;z"
set(${var1} var1) # x = "var1"

set(str1 "\"If you can love yourself\"")
set(str2 "${str1}, how in the hell you're gonna love somebody else.
Can I get an amen up in here?")
set(str3 [[
Shantay, you stay
Sashay away
]])

set(var)
unset(var)

# 2. Environmental variables
# - Structure: set(ENV{varName} value... [PARENT_SET])
# - Example: set(ENV{PATH} "$ENV{PATH}:~")

# 3. Cache variables
# - Structure: set(varName value... CACHE type "docstring" [FORCE])
#   + docstring can be empty
#   + type must be BOOL, FILEPATH, PATH, STRING or INTERNAL
# - For BOOL variables: option(optVar helpString [initialValue])
#   + Default: initialValue = OFF
#   + Equivalent: set(optVar initialValue CACHE BOOL helpString)
# - Cache variables vs. Normal variables:
#   + For cache variables: The set() command will only a pre-existing value if the FORCE keyword is present
#   + For normal variables: The set() command will always overwrite a pre-existing value
# - Normal variables USUALLY take precendence over cache variables.

set(var "Hello world!" CACHE STRING "A cache variable")
option(opt "An option" ON)

# 4. Set cache values on the command line
# - Structure: cmake -D myVar:type=someValue ...
#   + The docString is empty
#   + The type can be ommited
# - Remove variables from cache: cmake -U myVar

# 5. Debugging variables and diagnostics
# - Structure: message([mode] msg1 [msg2])
#   + [mode] can be STATUS, WARNING, AUTHOR_WARNING, SEND_ERROR, FATAL_ERROR or DEPRECATION

set(str "Hello world!")
message("str = ${str}")

# - Other mechanism: variable_watch(myVar [command])
#   + When a variable is watched, all attempts to read or modify it are logged

variable_watch(str)
set(str "Bye world!")

message("========================================")

# 6. String handling
# - Structure: string(FIND inputStr subStr outVar [REVERSE])
#   + Functionality: Find subStr in inputStr, store the index of the found subStr int outVar
#   + If subStr appears in inputStr, outVar = the first appearance (default) or the last appearance (REVERSE)
#   + If subStr does not appear in inputStr, outVar = -1

set(inputStr abcdefabcdefghi)
set(subStr def)
string(FIND ${inputStr} ${subStr} fIndex)
string(FIND ${inputStr} ${subStr} lIndex REVERSE)
message("inputStr = ${inputStr}")
message("subStr = ${subStr}")
message("fIndex = ${fIndex}, lIndex = ${lIndex}")

# - Structure: string(REPLACE matchStr replaceWith outVar inputStr [inputStr...])
#   + Functionality: Replace a substring

set(newSubStr xyz)
string(REPLACE ${subStr} ${newSubStr} outputStr ${inputStr})
message("outputStr (after replacing ${subStr} by ${newSubStr}) = ${outputStr}.")

# - Structure: string(REGEX ...)
#   + First match: string(REGEX MATCH regex outVar input [input...])
#   + All matches: string(REGEX MATCHALL regex outVar input [input...])
#   + Replace:	   string(REGEX REPLACE regex replaceWith outVar input [input...])

string(REGEX MATCHALL "[ace]" matchVar ${inputStr})
message("matchVar = ${matchVar}")

string(REGEX REPLACE "([de])" "+\\1+" replVar ${inputStr})
message("replVar = ${replVar}")

message("========================================")

# - Structure: string(SUBSTRING inputStr index length outVar)
#   + Functionality: Extract a substring

set(inputStr "  abCdEfGhI ")
string(SUBSTRING ${inputStr} 2 3 subStr)
message("inputStr = ${inputStr}")
message("subStr = ${subStr}")

# - Structure: string(LENGTH inputStr outVar)
#   + Functionality: Get length of a string
# - Structure: string(TOLOWER inputStr outVar)
#   + Functionality: Convert a string to lowercase
# - Structure: string(TOUPPER inputStr outVar)
#   + Functionality: Convert a string to uppercase
# - Structure: string(STRIP inputStr outVar)
#   + Functionality: Strip whitespace from the start and the end of a string

string(LENGTH ${inputStr} strLen)
message("strLen = ${strLen}")
string(TOLOWER ${inputStr} lowerStr)
message("lowerStr = ${lowerStr}")
string(TOUPPER ${inputStr} upperStr)
message("upperStr = ${upperStr}")
string(STRIP ${inputStr} stripStr)
message("stripStr = ${stripStr}")

message("========================================")

# 7. Lists
# - Structure: list(LENGTH listVar outVar)
#   + Functionality: Count number of items
# - Structure: list(GET listVar index [index...] outVar)
#   + Functionality: Retrieve one or more items from list

set(list a b c)
message("list = ${list}")
list(LENGTH list len)
message("length = ${len}")
list(GET list 0 1 subList)
message("subList = ${subList}")

# - Structure: list(APPEND listVar item [item...])
#   + Functionality: Append items
# - Structure: list(INSERT listVar index item [item...])
#   + Functionality: Insert items

list(APPEND list d e f)
message("list (1) = ${list}")
list(INSERT list 2 g h i)
message("list (2) = ${list}")

# - Structure: list(FIND listVar value outVar)
#   + Functionality: Find an item

list(FIND list b index)
message("index(b) = ${index}")

# - Structure: list(REMOVE_ITEM listVar item [item...])
#   + Functionality: Remove one or more items
# - Structure: list(REMOVE_AT listVar index [index...])
#   + Functionality: Remove one or more indices
# - Structure: list(REMOVE_DUPLICATES listVar)
#   + Functionality: Remove duplicated items

list(REMOVE_ITEM list a c)
message("list(3) = ${list}")
list(REMOVE_AT list 0)
message("list(4) = ${list}")
list(REMOVE_DUPLICATES list)
message("list(5) = ${list}")

# - Structure: list(REVERSE listVar)
#   + Functionality: Reverse a list
# - Structure: list(SORT listVar)
#   + Functionality: Sort a list

list(REVERSE list)
message("list(6) = ${list}")
list(SORT list)
message("list(7) = ${list}")

message("========================================")

# 8. Math
# - Structure: math(EXPR outVar mathExpr)
#   + Functionality: Perform basic mathetical evaluation

set(x 4)
set(y 7)
math(EXPR z "(${x} + ${y}) / 2")
message("(${x} + ${y}) / 2 = ${z}")