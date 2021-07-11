########################
# FUNCTIONS AND MACROS #
########################

# 1. The basics
# - Command:
#   function(name [arg1 [arg2 [...]]])
#     # Function body
#   endfunction()
# - Usage: Similar to function in C/C++.

function(func)
    message("Hello world!")
endfunction()

func()

# - Command:
#   macro(name [arg1 [arg2 [...]]])
#     # Macro body
#   endmacro()
# - Usage: Similar to #define macro in C/C++.

macro(macr)
    message("Goodbye world!")
endmacro()

macr()

############################################################

# 2. Argument handling essentials
# - Notes:
#   + For functions, each argument is a CMake variable and has all the usual behaviors of a CMake variable.
#   + For macros, if an argument is used in an if() command, it would be treated as a string.

function(func arg)
    if(DEFINED arg)
        message("Function arg is defined")
    else()
        message("Function arg is not defined")
    endif()
endfunction()

macro(macr arg)
    if(DEFINED arg)
        message("Macro arg is defined")
    else()
        message("Macro arg is not defined")
    endif()
endmacro()

set(var)
func(var)
macr(var)

# - Notes: Aside from that, functions and macros both support the same features when it comes to argument processing.

function(func arg)
    message("Hello ${arg}!")
endfunction()

macro(macr arg)
    message("Hello ${arg}!")
endmacro()

set(var "world")
func(${var})
macr(${var})

# - Notes:
#   + Functions and macros also come with a set of automatically defined variables.
#     . ARGC: The number of arguments passed to the function.
#     . ARGV: A list of arguments passed to the function.
#     . ARGN: A list of unnamed arguments passed to the function.
#   + Each individual argument can be referenced with ARG# where # is the number of the argument (including the named ones).
#   + ARG# variables are typically used to implement a command which can take an arbitrary number of items to be processed.

function(add_library lib)
    # add_library(${lib} ${ARGN})
    message("Library ${lib}: ${ARGN}")
endfunction()

add_library(sample sample1.cpp sample2.cpp sample3.cpp)

# - Notes:
#   + The ARGN used by macros might refer to the one in the scope from which they are called, not their own ARGN.
#   + In such cases, consider making the macro a function instead.

macro(macr)
    foreach(arg IN LISTS ARGN)
        message("Argument: ${arg}")
    endforeach()
endmacro()

function(func)
    macr(1 2 3 4)
endfunction()

func(5 6 7 8)

############################################################

# 3. Keyword arguments
# - Command:
#   include(CMakeParseArguments)
#   cmake_parse_arguments(
#     prefix
#     noValueKeywords
#     singleValueKeywords
#     multiValueKeywords
#     argsToParse
#   )
# - Usage: Support multiple optional or variable sets of arguments.
# - Notes:
#   + For every keyword, a corresponding variable will be available whose name follows the "prefix_[keyword]" format.
#   + The advantages of cmake_parse_arguments() are numerous.
#     . The calling site has improved readability.
#     . The caller gets to choose the order.
#     . The caller can omit unneeded arguments.
#     . It is very clear what the arguments the function supports.
#     . Argument passing bugs are virtually eliminated.

function(func)
    set(prefix          ARG)
    set(noValues        ENABLE_LOG)
    set(singleValues    VALUE)
    set(multiValues     LIST)

    include(CMakeParseArguments)
    cmake_parse_arguments(${prefix} "${noValues}" "${singleValues}" "${multiValues}" ${ARGN})

    if(${${prefix}_ENABLE_LOG})
        message("ENABLE_LOG is enabled")
        foreach(arg IN LISTS singleValues multiValues)
            message("${arg} = ${${prefix}_${arg}}")
        endforeach()
    else()
        message("ENABLE_LOG is disabled")
    endif()
endfunction()

func(ENABLE_LOG VALUE 0 LIST 1 2 3 4)

############################################################

# 4. Scope
# - Notes:
#   + Functions introduce a new variable scope, while macros do not.
#   + CMake functions and macros do not support returning a value directly.
#   + However, the approach discussed for add_directory() using the PARENT_SCOPE keyword can also be used for functions.

function(func res1 res2)
    set(${res1} "Hello" PARENT_SCOPE)
    set(${res2} "World" PARENT_SCOPE)
endfunction()

func(var1 var2)
message("var1 = ${var1}")
message("var2 = ${var2}")

# - Notes:
#   + Macros can use the same approach. However, the PARENT_SCOPE keyword should not be used within the macro.

macro(macr res1 res2)
    set(${res1} "Goodbye")
    set(${res2} "World")
endmacro()

macr(var1 var2)
message("var1 = ${var1}")
message("var2 = ${var2}")

###########################################################

# 5. Overriding commands
# - Notes:
#   + If a command defined by function() or macro() already exists, the old command can be accessed using "_[command]".
#   + However, if the command is overridden again, the original command is no longer accessible.
#   + Therefore, defining a command using its previous implementation could result in an infinity loop.
#   + Overall, overriding a function or macro is fine as long as it does not try to call the previous implementation.

function(func)
    message("Hello world!")
endfunction()

function(func)
    if("Goodbye" STRGREATER "Hello")
        message("Goodbye world!")
    else()
        _func()
    endif()
endfunction()

func()

message(${LINE})

################### RECOMMENDED PRACTICES ###################

# - Use functions instead of macros, only use macros where their contents do need to be executed within the caller scope.
# - Use the keyword-based argument handling provided by cmake_parse_arguments() in all but very trivial functions or macros.
# - Nominate a particular directory where various XXX.cmake files can be collected.
# - Do not define or call a function or macro with a name that starts with _.
# - Do not override any builtin CMake command.