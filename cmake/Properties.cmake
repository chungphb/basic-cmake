##############
# PROPERTIES #
##############

# Notes:
# - Properties affect just about all aspects of the build process.
# - A property provides information specific to the entity it is attached to.
# - Properties are sometimes confused with variables.
#   + Variables are not attached to any entity and are typically defined and used by projects.
#   + Properties always apply to a specific entity and are typically well defined and documented by CMake.

# 1. General property commands
# - Command:
#   set_property(
#     entitySpecific
#     [APPEND] [APPEND_STRING]
#     PROPERTY propName [value1 [value2 [...]]]
#   )
# - Usage: Set any property on any type of entity.
# - Notes:
#   + The entity whose property is being set must be one of the following:
#     . GLOBAL
#     . DIRECTORY [dir]
#     . TARGET    [target1 [target2 [...]]]
#     . SOURCE    [source1 [source2 [...]]]
#     . INSTALL   [file1   [file2   [...]]]
#     . TEST      [test1   [test2   [...]]]
#     . CACHE     [var1    [var2    [...]]]
#   + The property name would normally match one of the properties defined in the CMake documentation.
#   + It is also permitted for a project to create new properties apart from those already defined by CMake.
#   + The APPEND and APPEND_STRINGS keywords control how to update the property if it already has a value.
#     . The APPEND keyword appends the value(s) to the existing one to form a list.
#     . The APPEND_STRING keyword also appends the value(s) to the existing one but using string concatenation.

# - Command:
#   get_property(
#     resultVar
#     entitySpecific
#     PROPERTY propName
#     [DEFINED | SET | BRIEF_DOCS | FULL_DOCS]
#   )
# - Usage: Get any property on any type of entity.
# - Notes:
#   + The entity must be one of the following:
#     . GLOBAL
#     . DIRECTORY [dir]
#     . TARGET    target
#     . SOURCE    source
#     . INSTALL   file
#     . TEST      test
#     . CACHE     var
#     . VARIABLE
#   + If none of the optional keywords are given, the value of the property is retrieved.
#   + The optional keywords can be used to retrieve details about the property.
#     . DEFINED:    Retrieve a value indicating whether the property has been defined.
#     . SET:        Retrieve a value indicating whether the property has been set.
#     . BRIEF_DOCS: Retrieve the brief documentation string for the property.
#     . FULL_DOCS:  Retrieve the full documentation string for the property.

# - Command:
#   define_property(
#     entityType
#     PROPERTY propName [INHERITED]
#     BRIEF_DOCS briefDoc [more ...]
#     FULL_DOCS fullDoc [more ...]
#   )
# - Usage: Define a property.
# - Notes:
#   + This command is rarely used.
#   + This command only sets the property's documentation and whether it inherits its value from elsewhere, not the value.
#   + If the INHERITED keyword is used, the get_property() command will chain up to the parent scope if the property is not set in the current scope.
#   + The INHERITED properties only applies to the get_property() command and its variants.
#   + CMake has a large number of pre-defined properties of each type.

############################################################

# 2. Global properties
# - Notes: Global properties relate to the overall build as a whole.

# - Command: get_cmake_property(resultVar prop)
# - Usage: Get global properties.
# - Notes:
#   + The property can by any global property or one of the following PSEUDO properties:
#     . VARIABLES:          Return a list of all non-cache variables.
#     . CACHE_VARIABLES:    Return a list of all cache variables.
#     . COMMANDS:           Return a list of all commands, functions and macros.
#     . MACROS:             Return a list of just defined macros.
#     . COMPONENTS:         Return a list of all components defined by install() commands.

# 3. Directory properties
# - Notes: Directory properties mostly focus on setting default for target properties and overriding global properties.

# - Command: set_directory_property(PROPERTIES prop1 val1 [prop2 val2 ...])
# - Usage: Set directory properties.
# - Notes:
#   + Differences from set_property():
#     . This command can only be used to set or replace a property.
#     . It always applies to the current directory.

# - Commands:
#   get_directory_property(resultVar [DIRECTORY dir] prop)
#   get_directory_property(resultVar [DIRECTORY dir] DEFINITION var)
# - Usage: Get directory properties.
#   + The 1st form: Get the value of a property from a particular directory.
#   + The 2nd form: Retrieve the value of a variable from a particular directory.
# - Notes:
#   + The 2nd form should only be used for debugging.

############################################################

# 4. Target properties
# - Notes: Target properties are where many details about how to turn source files into binaries are collected and applied.

# - Commands:
#   set_target_properties(
#     target1 [target2 ...]
#     PROPERTIES
#     prop1 val1
#     [prop2 val2 ...]
#   )
#   get_target_properties(resultVar target prop)
# - Usage: Set and get target properties.
# - Notes:
#   + set_target_properties() lacks the flexibility of set_property() but provides a simpler syntax.
#   + get_target_properties() is the simplified version of get_property().
#   + CMake also has other commands which modify target properties, such as the family of target_...() commands.

############################################################

# 5. Source properties
# - Notes:
#   + Source properties enable fine-grained manipulation of compiler flags on a file-by-file basis.
#   + Project should rarely need to query or modify source file properties.

# - Commands:
#   set_source_properties(
#     file1 [file2 ...]
#     PROPERTIES
#     prop1 val1
#     [prop2 val2 ...]
#   )
#   get_target_properties(resultVar sourceFile prop)
# - Usage: Set and get source file properties.
# - Notes:
#   + Source properties are only visible to targets defined in the same directory scope.
#   + Any source properties that are set should make sense for all targets the source is added to.
#   + Changing the source's compiler flags will still result in all the target's sources being rebuilt.

############################################################

# 6. Cache variable properties
# - Notes:
#   + Each cache has a type. This type can be obtained using the get_property() command with the TYPE property.
#   + A cache variable can be marked as advanced with the mark_as_advanced() command, which is really setting the ADVANCED property.
#   + The help string of a cache variable can be modified or read using the HELPSTRING property.
#   + If a cache variable is of type STRING, the CMake GUI will look for the STRINGS property to present it as a combo box.

############################################################

# 7. Other property types
# - Commands:
#   set_test_properties(
#     test1 [test2 ...]
#     PROPERTIES
#     prop1 val1
#     [prop2 val2 ...]
#   )
#   get_test_properties(resultVar test prop)
# - Usage: Set and get test properties.
# - Notes:
#   + The other type of property CMake supports is for installed files.

################### RECOMMENDED PRACTICES ###################

# - Use the generic set_property() command to manipulate all but the special global pseudo properties.
# - Use the various target_...() commands to manipulate the associated target properties.
# - Be aware of some undesirable impacts on the build behavior when using source properties to manipulate compiler options.