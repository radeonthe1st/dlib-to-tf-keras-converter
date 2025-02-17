# - Find Dlib
# This script locates the Dlib library and its headers.
# It searches common paths, virtual environments, and allows manual overrides.
#
# If Dlib is not found automatically, you can manually set the following:
#   - DLIB_INCLUDE_DIR: Path to the Dlib include directory (where dlib/data_io.h is located)
#   - DLIB_LIBRARY: Path to the Dlib shared library (libdlib.so)
#
# Example of manual override when running CMake:
#   cmake -DDLIB_INCLUDE_DIR=/path/to/dlib/include -DDLIB_LIBRARY=/path/to/dlib.so ..
#
#  DLIB_INCLUDE_DIR - where to find dlib headers, etc.
#  DLIB_LIBRARIES   - List of libraries when using dlib.
#  DLIB_FOUND       - True if dlib is found.

include(FindPackageHandleStandardArgs)

find_package(X11 REQUIRED)
find_package(BLAS REQUIRED)
find_package(JPEG REQUIRED)
find_package(PNG REQUIRED)
find_package(LAPACK REQUIRED)
# on some systems it is installed (or gettting installed) and if present then
# dlib uses it and hence we need to include its library as well in the linking
# part. 
find_package(GIF)   # this is an optional package and will set GIF_LIBRARY

# Look for headers
find_path(DLIB_INCLUDE_DIR
          NAMES dlib/data_io.h
          HINTS $ENV{DLIB_INCLUDE_DIR}          # Check environment variable
                ${CMAKE_PREFIX_PATH}/include    # Look in CMAKE_PREFIX_PATH
                ${Python3_SITEARCH}/dlib       # Python-specific locations
                ${Python3_SITELIB}/dlib
                /usr/local/include             # Common system-wide paths
                /usr/include
          DOC "Path to Dlib include directory")
mark_as_advanced(DLIB_INCLUDE_DIR)

find_library(DLIB_LIBRARY
             NAMES dlib libdlib.so
             HINTS $ENV{DLIB_LIBRARY}            # Check environment variable
                   ${CMAKE_PREFIX_PATH}/lib     # Look in CMAKE_PREFIX_PATH
                   ${Python3_SITEARCH}          # Python-specific locations
                   ${Python3_SITELIB}
                   /usr/local/lib              # Common system-wide paths
                   /usr/lib
             DOC "Path to Dlib library")
mark_as_advanced(DLIB_LIBRARIES)

if (DLIB_INCLUDE_DIR AND DLIB_LIBRARY)
    message(STATUS "Found Dlib: include=${DLIB_INCLUDE_DIR}, lib=${DLIB_LIBRARY}")
else()
    message(FATAL_ERROR "Dlib not found. Set DLIB_INCLUDE_DIR and DLIB_LIBRARY manually if needed.")
endif()

# Marks these variables as advanced so they do not clutter the CMake GUI.
mark_as_advanced(DLIB_INCLUDE_DIR DLIB_LIBRARY)

if (GIF_FOUND)
set (DLIB_LIBRARIES ${DLIB_LIBRARIES} ${GIF_LIBRARY})
endif()

if(DLIB_FOUND AND NOT TARGET dlib::dlib)
    add_library(dlib::dlib INTERFACE IMPORTED)
    set_property(TARGET dlib::dlib PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${DLIB_INCLUDE_DIR})
    set_property(TARGET dlib::dlib PROPERTY INTERFACE_LINK_LIBRARIES ${DLIB_LIBRARIES} ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES} ${PNG_LIBRARIES} ${JPEG_LIBRARIES} ${X11_LIBRARIES})    
endif()
