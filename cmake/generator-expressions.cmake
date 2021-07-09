#########################
# GENERATOR EXPRESSIONS #
#########################

# Notes:
# - There are two quite when running CMake.
#   + The configure step:
#     . Read in and process the CMakeLists.txt file at the top of the source tree.
#     . Execute commands, functions, etc. to create an internal representation of the project.
#   + The generation step:
#     . Create the build tool's project files using the internal representation built up in the configure step.
# - There are situations where understanding the differences between the two is important.
# - Generator expressions allow to encode some logic which is not evaluated at the configure time but delayed until the generation time.
# - Generator expressions cannot be used everywhere, but they are supported in many places.

# 1. Simple boolean logic
# - Expressions:
#   + Expressions:
#       $<1:...>            The result will be the ... part.
#       $<0:...>            The result is an empty string, the ... part will be ignored.
#       $<BOOL:...>         Converts anything CMake recognizes as a boolean false value into 0 and everything else to 1.
#   + Logical operations:
#       $<AND:expr[,expr...]>
#       $<OR:expr[,expr...]>
#       $<NOTE:expr>
#   + If-then-else:
#       $<IF:expr,val1,val0>                # CMake 3.8 or later
#       $<expr:val1>$<$<NOTE:expr>:val0>    # Before CMake 3.8
#   + Strings, numbers and versions testing:
#       $<OPERATOR:val1,val2>
#   + Build type testing:
#       $<CONFIG:arg>
# - Notes:
#   + CMake offers more conditional tests based on things like platform and compiler details.

############################################################

# 2. Target details
# - Expressions:
#   $<TARGET_PROPERTY:target,property>
#   $<TARGET_PROPERTY:property>
# - Usage: Provide information about targets.
#   + The 1st form: Provide the value of the property from the specified target.
#   + The 2nd form: Retrieve the property from the target on which the generator expression is being used.
# - Notes:
#   + CMake also provides other expressions which give details about the directory and file name of a target's build binary.
#   + The most general of these is the TARGET_FILE set of general expressions:
#     . TARGET_FILE
#     . TARGET_FILE_NAME
#     . TARGET_FILE_DIR
#   + These expressions are very useful when defining custom build rules for copying files around in post build steps.

# - Expression: $<TARGET_OBJECTS:...>
# - Usage: Allow a library target to be defined as an object library.

############################################################

# 3. General information
# - Expression: $<CONFIG>
# - Usage: Evaluate to the build type.

# - Expression: $<PLATFORM_ID>
# - Usage: Identify the platform for which the target is being built.

# - Expressions: $<C_COMPILER_VERSION>, $<CXX_COMPILER_VERSION>
# - Usage: Support adding content if the compiler version is older or newer than some particular version.

# - Expressions: $<LOWER_CASE:...>, $<UPPER_CASE:...>
# - Usage: Convert content to lower or upper case.

################### RECOMMENDED PRACTICES ###################

# Become familiar with the capabilities that general expressions provide.
# Use general expressions to handle content which changes depending on the target or the build type.
# Favor clarity over cleverness.