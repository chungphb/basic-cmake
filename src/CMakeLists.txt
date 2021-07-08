message("")
message(">>>> ADD SUBDIRECTORY <<<<")

message("src: CMAKE_SOURCE_DIR         = ${CMAKE_SOURCE_DIR}")
message("src: CMAKE_BINARY_DIR         = ${CMAKE_BINARY_DIR}")
message("src: CMAKE_CURRENT_SOURCE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}")
message("src: CMAKE_CURRENT_BINARY_DIR = ${CMAKE_CURRENT_BINARY_DIR}")

message("src: myVar                    = ${myVar}")
message("src: childVar                 = ${childVar}")
set(myVar "Hello Vietnam!")
set(childVar "Goodbye Vietnam!")
message("src: myVar                    = ${myVar}")
message("src: childVar                 = ${childVar}")

message("src: parentVar                = ${parentVar}")
set(parentVar "I adore you!" PARENT_SCOPE)
message("src: parentVar                = ${parentVar}")

message("")