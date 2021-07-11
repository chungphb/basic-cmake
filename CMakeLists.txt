cmake_minimum_required(VERSION 3.12)

project(basic-cmake VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

include(cmake/Util.cmake)

# Fundamentals
include(cmake/BuildingSimpleTargets.cmake)
include(cmake/Variables.cmake)
include(cmake/FlowControl.cmake)
include(cmake/UsingSubdirectories.cmake)
include(cmake/FunctionsAndMacros.cmake)
include(cmake/Properties.cmake)
include(cmake/GeneratorExpressions.cmake)
include(cmake/Modules.cmake)
include(cmake/Policies.cmake)

# Builds in depth
include(cmake/BuildType.cmake)
include(cmake/CompilerAndLinkerEssentials.cmake)