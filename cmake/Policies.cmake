############
# POLICIES #
############

# 1. Policy control
# - Command: cmake_policy(VERSION major[.minor[.patch[.tweak]]])
# - Usage: Provide more fine-grained control over policies than what cmake_minimum_required() command provides.
# - Notes:
#   + cmake_policy() is usually used to enforce a particular version's behavior for a section of the project.

cmake_policy(VERSION 3.12)

# - Command: cmake_policy(VERSION major[.minor[.patch[.tweak]]]...major[.minor[.patch[.tweak]]])
# - Usage: Allow projects to specify a version range rather than a single version (CMake 3.12).

cmake_policy(VERSION 3.7...3.12)

# - Commands:
#   cmake_policy(SET CMPxxxx NEW)
#   cmake_policy(SET CMPxxxx OLD)
# - Usage: Control each behavior change individually.
# - Notes:
#   + A project relying on old behavior could continue to do so by setting the associated policy to OLD.
#   + The need for setting a policy to NEW is less common.

cmake_policy(SET CMP0045 OLD)
get_target_property(resultVar nonexistent COMPILE_DEFINITIONS)
if(resultVar)
    message("Target exists")
else()
    message("Target not exists")
endif()

# - Command: cmake_policy(GET CMPxxxx resultVar)
# - Usage: Get the current state of a particular policy.

cmake_policy(GET CMP0045 resultVar)
message("CMP0045: ${resultVar}")

# - Notes:
#   + CMake may warn if it detects that the project is doing something that either:
#     . Relies on the old behavior.
#     . Conflicts with the new behavior.
#     . Whose behavior is ambiguous.
#   + Sometimes the policy warnings could be undesirable. This could be handled by:
#     . Explicitly setting the policy to the desired behavior.
#     . Setting the CMAKE_POLICY_DEFAULT_CMPxxxx and CMAKE_POLICY_WARNING_CMPxxxx variables.

set(CMAKE_POLICY_WARNING_CMP0045 OLD)
message("CMP0045: ${resultVar}")

###########################################################

# 2. Policy Scope
# - Commands:
#   cmake_policy(PUSH)
#   cmake_policy(POP)
# - Usage: Save and restore the state of all policies.
# - Notes:
#   + Some commands implicitly push a new policy state onto the stack and pop it again at a well defined point later.
#     . add_subdirectory()
#     . include()
#     . find_package()
#   + The include() and find_package() commands also support a NO_POLICY_SCOPE option.

cmake_policy(PUSH)

cmake_policy(SET CMP0060 OLD)

cmake_policy(GET CMP0060 resultVar)
message("CMP0060 (inner): ${resultVar}")

cmake_policy(POP)

cmake_policy(GET CMP0060 resultVar)
message("CMP0060 (outer): ${resultVar}")

################### RECOMMENDED PRACTICES ###################

# - Work with policies at the CMake version level rather than manipulating specific policies.
# - Choose cmake_policy() over cmake_minimum_required() except for:
#   + The start of the project's top level CMakeLists.txt file.
#   + At the top of a module file that could be re-used across multiple projects.
# - Use if(POLICY...) rather than testing the CMAKE_VERSION variable to check whether a policy is available.
# - Use cmake_policy(PUSH) and cmake_policy(POP) to separate sections with different set of policies.
# - Avoid using the NO_POLICY_SCOPE keyword of include() and find_package().
# - Avoid modifying policy settings inside a function.
# - Use CMAKE_POLICY_DEFAULT_CMPxxxx and CMAKE_POLICY_WARNING_CMPxxxx variables to work around some specific policy-related situations.