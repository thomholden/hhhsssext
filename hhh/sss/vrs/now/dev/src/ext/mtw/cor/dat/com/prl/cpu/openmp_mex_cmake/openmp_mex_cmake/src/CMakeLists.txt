cmake_minimum_required(VERSION 2.8)
project(OPENMPMEX)

set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake) # add FindMatlab module

add_definitions(/DMATLAB_MEX_FILE) #define matlab macros
add_definitions(/DMX_COMPAT_32)

find_package(Matlab REQUIRED)
find_package(OpenMP)

IF(MATLAB_FOUND AND OPENMP_FOUND)
    message(STATUS "OpenMP Found, OpenMP MEX will be compiled.")
    add_subdirectory(openmpmex)
ELSE(MATLAB_FOUND AND OPENMP_FOUND)
    MESSAGE("MATLAB or OpenMP not found...nothing will be built.")
ENDIF(MATLAB_FOUND AND OPENMP_FOUND)
