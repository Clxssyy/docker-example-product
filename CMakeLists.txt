# Build for Decompressor program

cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

project(Decompressor)

# decompressor
add_executable(decompressor)
target_sources(decompressor PRIVATE decompressor.cpp)
target_compile_features(decompressor PRIVATE cxx_std_17)
target_compile_options(decompressor PRIVATE -Wall -Werror -O3)

# libarchive
find_package(LibArchive REQUIRED)
target_link_libraries(decompressor PRIVATE LibArchive::LibArchive)

# run
add_custom_target(run
    COMMENT "Decompressor"
    COMMAND $<TARGET_FILE:decompressor> < ${CMAKE_CURRENT_SOURCE_DIR}/demo.zip.gz
    DEPENDS decompressor
    USES_TERMINAL
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

add_custom_target(check
    COMMENT "Decompressor Check"
    COMMAND ${CMAKE_COMMAND} -E echo "Running Decompressor Check"
    COMMAND ${CMAKE_COMMAND} -E remove -f ${CMAKE_CURRENT_BINARY_DIR}/output.txt
    COMMAND ./decompressor ${CMAKE_CURRENT_SOURCE_DIR}/../demo.zip.gz > ${CMAKE_CURRENT_BINARY_DIR}/output.txt
    COMMAND ${CMAKE_COMMAND} -E compare_files ${CMAKE_CURRENT_SOURCE_DIR}/expected_output.txt ${CMAKE_CURRENT_BINARY_DIR}/output.txt
    DEPENDS decompressor
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)