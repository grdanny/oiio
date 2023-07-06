# Copyright Contributors to the OpenImageIO project.
# SPDX-License-Identifier: BSD-3-Clause and Apache-2.0
# https://github.com/OpenImageIO/oiio

# - Try to find libjpeg-turbo
# Once done, this will define
#
#  JPEG_FOUND - system has libjpeg-turbo
#  JPEG_INCLUDE_DIRS - the libjpeg-turbo include directories
#  JPEG_LIBRARIES - link these to use libjpeg-turbo
#

include (FindPackageHandleStandardArgs)

find_path(JPEG_INCLUDE_DIR turbojpeg.h
          HINTS /usr/local/opt/jpeg-turbo/include
          PATH_SUFFIXES include)
set(JPEG_NAMES ${JPEG_NAMES} jpeg libjpeg turbojpeg libturbojpeg)

find_library(JPEG_LIBRARY NAMES ${JPEG_NAMES}
             HINTS ${JPEG_INCLUDE_DIR}/..
                   /usr/local/opt/jpeg-turbo
                   /opt/libjpeg-turbo
             PATH_SUFFIXES lib lib64
             NO_DEFAULT_PATH)
if (NOT JPEG_LIBRARY)
    find_library(JPEG_LIBRARY NAMES ${JPEG_NAMES}
                 HINTS ${JPEG_INCLUDE_DIR}/..
                       /usr/local/opt/jpeg-turbo
                 PATH_SUFFIXES lib lib64)
endif ()

if (JPEG_INCLUDE_DIR AND JPEG_LIBRARY)
  set (JPEG_INCLUDE_DIRS ${JPEG_INCLUDE_DIR} CACHE PATH "JPEG include dirs")
  set (JPEG_LIBRARIES ${JPEG_LIBRARY} CACHE STRING "JPEG libraries")
  file(STRINGS "${JPEG_INCLUDE_DIR}/jconfig.h"
                jpeg_lib_version REGEX "^#define[\t ]+JPEG_LIB_VERSION[\t ]+.*")
  if (jpeg_lib_version)
      string(REGEX REPLACE "^#define[\t ]+JPEG_LIB_VERSION[\t ]+([0-9]+).*"
              "\\1" JPEG_VERSION "${jpeg_lib_version}")
  endif ()
endif ()

# handle the QUIETLY and REQUIRED arguments and set JPEG_FOUND to TRUE if
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(JPEG DEFAULT_MSG JPEG_LIBRARIES JPEG_INCLUDE_DIRS)

if (JPEG_FOUND)
    set (JPEGTURBO_FOUND true)

    # Use an intermediary target named "JPEG::JPEG" to match libjpeg's export
    if(NOT TARGET JPEG::JPEG)
      add_library(JPEG::JPEG INTERFACE IMPORTED)
      target_link_libraries(JPEG::JPEG INTERFACE ${JPEG_LIBRARY})
    endif()
endif ()

mark_as_advanced(JPEG_LIBRARIES JPEG_INCLUDE_DIRS )

