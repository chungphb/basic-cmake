cmake_minimum_required(VERSION 3.12)

project(basic-cmake VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

include(cmake/building-simple-targets.cmake)
include(cmake/variables.cmake)
include(cmake/flow-control.cmake)