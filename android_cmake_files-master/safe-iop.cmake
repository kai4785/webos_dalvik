cmake_minimum_required(VERSION 2.8)

set(safe_iop_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include CACHE STRING "" FORCE)

set(LOCAL_C_INCLUDES
    ${safe_iop_INCLUDE_DIR}
)

set(LOCAL_SRC_FILES
	src/safe_iop.c
)
set(LOCAL_MODULE safe_iop)

BUILD_STATIC_LIBRARY()

#android_include(testsuite/Android.cmake)
