# CMakeLists.txt for FAS package. It creates a library with dictionary and a main program
cmake_minimum_required(VERSION 4.0 FATAL_ERROR)
project(Glauber)

# You need to tell CMake where to find the ROOT installation. This can be done
# in a number of ways:
#   - ROOT built with classic configure/make use the provided
#   $ROOTSYS/etc/cmake/FindROOT.cmake
#   - ROOT built with CMake. Add in CMAKE_PREFIX_PATH the installation prefix
#   for ROOT
list(APPEND CMAKE_PREFIX_PATH $ENV{ROOTSYS})

#---Locate the ROOT package and defines a number of variables (e.g. ROOT_INCLUDE_DIRS)
find_package(ROOT REQUIRED COMPONENTS MathCore MathMore RIO Hist Tree Net)

include(${ROOT_USE_FILE})

set(INCLUDE_DIRECTORIES
  ${CMAKE_SOURCE_DIR}
  ${ROOT_INCLUDE_DIRS}
)

include_directories(${INCLUDE_DIRECTORIES})
#---set (CMAKE_CXX_STANDARD 11)
add_definitions(${ROOT_CXX_FLAGS})

set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2")

#---Generate dictionary
ROOT_GENERATE_DICTIONARY(G__Glauber
  runglauber_v3.2.h
  LINKDEF LinkDef.h)

#---Create a shared library
add_library(Glauber SHARED runglauber_v3.2.C G__Glauber.cxx)
target_link_libraries(Glauber ${ROOT_LIBRARIES})

add_executable(runGlauber runGlauber.cpp)
target_link_libraries(runGlauber Glauber)
