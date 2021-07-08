################
# FLOW CONTROL #
################

set(LINE "========================================")

# 1. if()
# - Command:
#   if(expression1)
#     # commands...
#   elseif(expression2)
#     # commands...
#   else()
#     # commands...
#   endif()
# - Usage: If
# - Notes:
#   + The expression in if() and elseif() commands can take various forms.

# 1.1. Basic expressions
# - Command: if(value)
# - Notes:
#   + For a single unquoted constant:
#     . If value is 1, ON, YES, TRUE, Y or a non-zero member
#         ----> TRUE
#     . If value is 0, OFF, NO, FALSE, N, IGNORE, NOTFOUND, an empty string or a string that ends in -NOTFOUND
#         ----> FALSE
#     . Else
#         ----> A variable name (or possibly a string)
#   + For a quoted constant: A quoted string

if(YES)
    message(YES)
endif()

if(0)
    message(0)
endif()

if(FALSE)
    message(FALSE)
endif()

set(x NO)
if(x)
    message(${x})
endif()

set(y 4)
if(y)
    message(${y})
endif()

if(someStr)
    message(someStr)
endif()

if("someStr")
    message("someStr")
endif()

# 1.2. Logic operators
# - Command:
#   if(NOT expression)
#   if(expression1 AND expression2)
#   if(expression1 OR expression2)

if(NOT FALSE)
    message("NOT FALSE")
endif()

# 1.3. Comparison tests
# - Command:
#   if(value1 OPERATOR value2)

set(val1 5)
set(val2 12)

if(val1 EQUAL val2)
    message("${val1} = ${val2}")
endif()

if(val1 LESS val2)
    message("${val1} < ${val2}")
endif()

if(val1 GREATER val2)
    message("${val1} > ${val2}")
endif()

if(val1 LESS_EQUAL val2)
    message("${val1} <= ${val2}")
endif()

if(val1 GREATER_EQUAL val2)
    message("${val1} >= ${val2}")
endif()

set(str1 "Hello")
set(str2 "World")

if(str1 STREQUAL str2)
    message("${str1} = ${str2}")
endif()

if(str1 STRLESS str2)
    message("${str1} < ${str2}")
endif()

if(str1 STRGREATER str2)
    message("${str1} > ${str2}")
endif()

if(str1 STRLESS_EQUAL str2)
    message("${str1} <= ${str2}")
endif()

if(str1 STRGREATER_EQUAL str2)
    message("${str1} >= ${str2}")
endif()

set(ver1 1.25.10)
set(ver2 1.5.12)

if(ver1 VERSION_EQUAL ver2)
    message("${ver1} = ${ver2}")
endif()

if(ver1 VERSION_LESS ver2)
    message("${ver1} < ${ver2}")
endif()

if(ver1 VERSION_GREATER ver2)
    message("${ver1} > ${ver2}")
endif()

if(ver1 VERSION_LESS_EQUAL ver2)
    message("${ver1} <= ${ver2}")
endif()

if(ver1 VERSION_GREATER_EQUAL ver2)
    message("${ver1} >= ${ver2}")
endif()

# - Command:
#   if(value MATCHES regex)
# - Usage: Test a string against a regular expression.
# - Notes:
#   + Support basic regex syntax only.
#   + Use parentheses to capture parts of the matched value.
#   + The variables CMAKE_MATCH_<n> where <n> is the group to match will be set.

set(val "world")
if("The ${val}" MATCHES "The (world|ocean|space)")
    message("Hello ${CMAKE_MATCH_1}!")
endif()

# 1.4. File system tests
# - Command:
#   if(EXISTS pathToFileOrDir)
#   if(IS_DIRECTORY pathToDir)
#   if(IS_SYMLINK fileName)
#   if(IS_ABSOLUTE path)
#   if(file1 IS_NEWER_THAN file2)

set(dirPath "${CMAKE_CURRENT_SOURCE_DIR}/include/module")

if(EXISTS ${dirPath})
    message("${dirPath} exists")
endif()

if(IS_DIRECTORY ${dirPath})
    message("${dirPath} is a directory")
endif()

if(IS_SYMLINK ${dirPath})
    message("${dirPath} is a symbolic link")
endif()

if(IS_ABSOLUTE ${dirPath})
    message("${dirPath} is an absolute path")
endif()

set(file1 "${CMAKE_CURRENT_SOURCE_DIR}/include/module/module.h")
set(file2 "${CMAKE_CURRENT_SOURCE_DIR}/include/module/util.h")

if(${file1} IS_NEWER_THAN ${file2})
    message("${file1} is newer than ${file2}")
else()
    message("${file2} is newer than ${file1}")
endif()

# 1.5. Existence tests
# - Command:
#   if(DEFINED name)
#   if(COMMAND name)
#   if(POLICY name)
#   if(TARGET name)
#   if(TEST name)

if(DEFINED val)
    message("Variable val is defined")
else()
    message("Variable val is not defined")
endif()

if(COMMAND func)
    message("Function/Macro func is defined")
else()
    message("Function/Macro func is not defined")
endif()

if(POLICY CMP0512)
    message("Policy CMP0512 is defined")
else()
    message("Policy CMP0512 is not defined")
endif()

set(trg "main")
if(TARGET ${trg})
    message("Target ${trg} is defined")
else()
    message("Target ${trg} is not defined")
endif()

set(tst "test")
if(TARGET ${tst})
    message("Test ${tst} is defined")
else()
    message("Test ${tst} is not defined")
endif()

# - Command:
#   if(value IN_LIST listVar)

set(val 1)
set(lst 1 2 3)
if(val IN_LIST lst)
    message("Value ${val} is in list ${lst}")
else()
    message("Value ${val} is not in list ${lst}")
endif()

# 1.6. Common examples

if(MSVC)
    message("MSVC compiler")
else()
    message("Generic compiler")
endif()

if(CMAKE_GENERATOR STREQUAL "Xcode")
    message("Xcode generator")
else()
    message("Other CMake generators")
endif()

message(${LINE})

############################################################

# 2. Looping

# 2.1. foreach()
# - Command:
#   foreach(loopVar arg1 arg2 ...)
#     # ...
#   endforeach()
# - Usage: For loop.

message("Valid elements:")
foreach(i 1 2 3)
    message(${i})
endforeach()

# - Command:
#   foreach(loopVar IN [LISTS listVar1 ...] [ITEMS item1 ...])
#     # ...
#   endforeach()
# - Usage: For loop.

set(lst1 H e l l o)
set(lst2 w o r l d)
set(val !)
message("Valid elements:")
foreach(i IN LISTS lst1 lst2 ITEMS ${val})
    message(${i})
endforeach()

# - Command:
#   foreach(loopVar RANGE start stop [step])
#     # ...
#   endforeach()
# - Usage: For loop.

message("Valid elements:")
foreach(i RANGE 5 12 2)
    message(${i})
endforeach()

# - Command:
#   foreach(loopVar RANGE value)
#     # ...
#   endforeach()
# - Usage: For loop.

message("Valid elements:")
foreach(i RANGE 4)
    message(${i})
endforeach()

# 2.2. while()
# - Command:
#   while(condition)
#     # ...
#   endwhile()
# - Usage: While loop.

message("Valid elements:")
set(val 0)
while(val LESS 5)
    message(${val})
    math(EXPR val "${val} + 1")
endwhile()

# 2.3. Interrupting loops
# - Command:
#   break()
# - Usage: Exit a loop.

message("Valid elements:")
set(val 0)
while(val LESS 12)
    math(EXPR val "${val} + 1")
    math(EXPR tmp "${val} % 4")
    if(tmp EQUAL 0)
        break()
    endif()
    message(${val})
endwhile()

# - Command:
#   continue()
# - Usage: Skip to the next iteration.

message("Valid elements:")
set(val 0)
while(val LESS 12)
    math(EXPR val "${val} + 1")
    math(EXPR tmp "${val} % 4")
    if(tmp EQUAL 0)
        continue()
    endif()
    message(${val})
endwhile()

message(${LINE})

################### RECOMMENDED PRACTICES ###################

# - Don't let strings be unintentionally interpreted as variables. Avoid unary expressions with quotes.
# - Store the CMAKE_MATH_<n> match results in ordinary variables as soon as possible.
# - Specify both the start and end values when using the RANGE form of foreach().
# - Use the IN LISTS or IN ITEMS forms rather than the bare form of foreach().