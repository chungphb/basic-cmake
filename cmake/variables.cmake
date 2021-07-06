#############
# VARIABLES #
#############

set(LINE "========================================")

# 1. Variable basics
# - Command:
#   set(varName value... [PARENT_SCOPE])
# - Usage: Define a variable.
# - Notes:
#   + A variable has a specific scope.
#   + All variables are treated as strings.
#   + The value of a variable can be obtained by using ${varName}.
#   + Variables doesn't need to be defined before being used.
#   + Strings are not restricted to be in a single LINE.
#   + [>=3.0] An alternative to quote is using [=[ ]=] with any number of = characters used at both the start and the end.

set(var "Hello world!")             # var = "Hello world"
set(var 1 2 3)                      # var = "1;2;3"

set(var1 "x")                       # var1 = "x"
set(var2 ${var1})                   # var2 = var1 = "x"
set(var3 ${var1} y z)               # var3 = "x;y;z"
set(${var1} var1)                   # x = "var1"

set(str1 "\"If you can love yourself\"")
set(str2 "${str1},
How in the hell you're gonna love somebody else.")
set(str3 [=[
"Can I get an amen up in here?"
]=])

# - Command: unset(varName)
# - Usage: Unset a variable.
# - Notes:
#   + A variable can also be unset by calling set() with no value.

unset(var)
set(var)

############################################################

# 2. Environmental variables
# - Command: set(ENV{varName} value... [PARENT_SET])
# - Usage: Set an environmental variable.
# - Example: set(ENV{PATH} "$ENV{PATH}:~")
# - Notes:
#   + This command only affects the currently running CMake instance.
#   + This command is rarely useful.

############################################################

# 3. Cache variables
# - Command: set(varName value... CACHE type "docstring" [FORCE])
#   + docstring can be empty
#   + type must be BOOL, FILEPATH, PATH, STRING or INTERNAL
# - Usage: Define a cache variable.
# - Notes:
#   + Cache variables are stored in CMakeCache.txt in the build directory.
#   + Cache variables persist between CMake runs.
#   + Cache variables vs. Normal variables:
#     . Cache variables: The set() command will only overwrite a pre-existing value if the FORCE keyword is present.
#     . Normal variables: The set() command will always overwrite a pre-existing value.
#   + A normal variable and a cache variable can have the same name.
#     . Normal variables USUALLY take precedence over cache variables.

set(var "Hello world!" CACHE STRING "A cache variable")

# - Command: option(optVar helpString [initialValue])
#   + initialValue = OFF by default
# - Usage: Define a boolean cache variable.

option(opt "An option" ON)

############################################################

# 4. Setting cache values on the command line
# - Command: cmake -D myVar:type=someValue ...
# - Usage: Define a cache variable on the command line.
# - Notes:
#   + Any previous value of the cache variable will be replaced by the new value.
#   + Multiple -D options can be provided.
#   + The type can be omitted. However, it should be specified when the variable represents some kind of path.
#   + Variables can be removed from the cache with the -U option.

############################################################

# 5. Debugging variables and diagnostics
# - Command: message([mode] msg1 [msg2])
#   + mode can be STATUS, WARNING, AUTHOR_WARNING, SEND_ERROR, FATAL_ERROR or DEPRECATION.
# - Usage: Print out diagnostic messages and variables values during a CMake run.
# - Notes:
#   + Logging with a STATUS mode is not the same as logging with no mode keyword.
#     . With a STATUS mode: The message will be printed correctly ordered with other messages and will be preceded by --.
#     . Without any mode keyword: No -- are prepended.

set(str "Hello world!")
message("str = ${str}")

# - Command: variable_watch(myVar [command])
# - Usage: Log all attempts to read or modify a variable.

variable_watch(str)
set(str "Bye world!")

message(${LINE})

############################################################

# 6. String handling
# - Command: string(FIND inputStr subStr outVar [REVERSE])
# - Usage: Find a substring in an input string and store the index of the found substring.
#   + If the substring appears in the input string, index = the first appearance (default) or the last appearance (REVERSE).
#   + If the substring does not appear in the input string, index = -1.

set(inputStr abcdefabcdefghi)
set(subStr def)
string(FIND ${inputStr} ${subStr} fIndex)
string(FIND ${inputStr} ${subStr} lIndex REVERSE)
message("inputStr = ${inputStr}")
message("subStr = ${subStr}")
message("fIndex = ${fIndex}, lIndex = ${lIndex}")

# - Command: string(REPLACE matchStr replaceWith outVar inputStr [inputStr...])
# - Usage: Replace every occurrence of a string in the input strings and store the result.

set(newSubStr xyz)
string(REPLACE ${subStr} ${newSubStr} outputStr ${inputStr})
message("outputStr (after replacing ${subStr} by ${newSubStr}) = ${outputStr}.")

# - Command: string(REGEX ...)
# - Usage:
#   + Find the first match and store it:    string(REGEX MATCH regex outVar input [input...])
#   + Find all matches and store them:      string(REGEX MATCHALL regex outVar input [input...])
#   + Replace all matches and return:	    string(REGEX REPLACE regex replaceWith outVar input [input...])

string(REGEX MATCHALL "[ace]" matchVar ${inputStr})
message("matchVar = ${matchVar}")

string(REGEX REPLACE "([de])" "+\\1+" replVar ${inputStr})
message("replVar = ${replVar}")

message(${LINE})

# - Command: string(SUBSTRING inputStr index length outVar)
# - Usage: Extract a substring.

set(inputStr "  abCdEfGhI ")
string(SUBSTRING ${inputStr} 2 3 subStr)
message("inputStr = ${inputStr}")
message("subStr = ${subStr}")

# - Command: string(LENGTH inputStr outVar)
# - Usage: Get length of a string.

string(LENGTH ${inputStr} strLen)
message("strLen = ${strLen}")

# - Command: string(TOLOWER inputStr outVar)
# - Usage: Convert a string to lowercase.

string(TOLOWER ${inputStr} lowerStr)
message("lowerStr = ${lowerStr}")

# - Command: string(TOUPPER inputStr outVar)
# - Usage: Convert a string to uppercase.

string(TOUPPER ${inputStr} upperStr)
message("upperStr = ${upperStr}")

# - Command: string(STRIP inputStr outVar)
# - Usage: Strip whitespace from the start and the end of a string.

string(STRIP ${inputStr} stripStr)
message("stripStr = ${stripStr}")

message(${LINE})

############################################################

# 7. Lists
# Notes: For all commands which take an index as input, the index can be negative to indicate counting starts from the end.

set(list a b c)
message("list = ${list}")

# - Command: list(LENGTH listVar outVar)
# - Usage: Count number of items.

list(LENGTH list len)
message("length = ${len}")

# - Command: list(GET listVar index [index...] outVar)
# - Usage: Retrieve one or more items from a list.

list(GET list 0 1 subList)
message("subList = ${subList}")

# - Command: list(APPEND listVar item [item...])
# - Usage: Append items.
# - Notes:
#   + This command modifies the list directly.

list(APPEND list d e f)
message("list (1) = ${list}")

# - Command: list(INSERT listVar index item [item...])
# - Usage: Insert items.
# - Notes:
#   + This command modifies the list directly.

list(INSERT list 2 g h i)
message("list (2) = ${list}")

# - Command: list(FIND listVar value outVar)
# - Usage: Find an item.

list(FIND list b index)
message("index(b) = ${index}")

# - Command: list(REMOVE_ITEM listVar item [item...])
# - Usage: Remove one or more items.
# - Notes:
#   + This command modifies the list directly.

list(REMOVE_ITEM list a c)
message("list(3) = ${list}")

# - Command: list(REMOVE_AT listVar index [index...])
# - Usage: Remove one or more indices.
# - Notes:
#   + This command modifies the list directly.

list(REMOVE_AT list 0)
message("list(4) = ${list}")

# - Command: list(REMOVE_DUPLICATES listVar)
# - Usage: Remove duplicated items.
# - Notes:
#   + This command modifies the list directly.

list(REMOVE_DUPLICATES list)
message("list(5) = ${list}")

# - Command: list(REVERSE listVar)
# - Usage: Reverse a list.
# - Notes:
#   + This command modifies the list directly.

list(REVERSE list)
message("list(6) = ${list}")

# - Command: list(SORT listVar)
# - Usage: Sort a list.
# - Notes:
#   + This command modifies the list directly.

list(SORT list)
message("list(7) = ${list}")

message(${LINE})

############################################################

# 8. Math
# - Command: math(EXPR outVar mathExpr)
# - Usage: Perform basic mathematical evaluation.

set(x 4)
set(y 7)
math(EXPR z "(${x} + ${y}) / 2")
message("(${x} + ${y}) / 2 = ${z}")

################### RECOMMENDED PRACTICES ###################

# - Provide cache variables for controlling instead of using scripts outside of CMake.
# - Avoid relying on environment variables being defined. Pass information through cache variables to CMake wherever possible.
# - Establish a variable naming convention early.
#   + Group related cache variables under a common prefix.
#   + Start a name with the project name or something closely related.
# - Avoid using the same name for none-cache variables and cache variables.
# - Always specify a mode with the message() command.
# - Scan through the all CMake pre-defined variables.