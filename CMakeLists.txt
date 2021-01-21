cmake_minimum_required(VERSION 3.12)

project(basic-cmake VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Generates a library and creates a CMake target
add_library(module module.cpp include/module/module.h include/module/util.h)

# Adds an include directory to the target
# For a library:
# - PUBLIC: Both the current target and all of its dependencies need the include directory
# - PRIVATE: Only the current target need the include directory
# - INTERFACE: Only the dependencies need the include directory
target_include_directories(module PUBLIC include)

# Generates an executable file and creates a CMake target
add_executable(main main.cpp)

# Adds:
# - A dependency if the target is given, or 
# - A link to a library if no target of that name exists, or
# - A full path to a library, or
# - A linker flag
target_link_libraries(main PUBLIC module)


