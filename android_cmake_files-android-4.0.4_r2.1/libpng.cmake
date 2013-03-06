set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# We need to build this for both the device (as a shared library)
# and the host (as a static library for tools to use).

set(common_SRC_FILES
	png.c 
	pngerror.c 
	pnggccrd.c 
	pngget.c 
	pngmem.c 
	pngpread.c 
	pngread.c 
	pngrio.c 
	pngrtran.c 
	pngrutil.c 
	pngset.c 
	pngtrans.c 
	pngvcrd.c 
	pngwio.c 
	pngwrite.c 
	pngwtran.c 
	pngwutil.c
    )

set(common_CFLAGS -fvisibility=hidden) ## -fomit-frame-pointer

# ifeq ($(HOST_OS),windows)
#   ifeq ($(USE_MINGW),)
#     # Case where we're building windows but not under linux (so it must be cygwin)
#     # In this case, gcc cygwin doesn't recognize -fvisibility=hidden
#     $(info libpng: Ignoring gcc flag $(common_CFLAGS) on Cygwin)
#     common_CFLAGS := 
#   endif
# endif

#common_C_INCLUDES += 

set(common_COPY_HEADERS_TO libpng)
set(common_COPY_HEADERS png.h pngconf.h pngusr.h)

# # For the host
# # =====================================================
# 
# CLEAR_VARS()
# 
# set(LOCAL_SRC_FILES ${common_SRC_FILES})
# concat(LOCAL_CFLAGS ${common_CFLAGS}
# concat(LOCAL_C_INCLUDES ${common_C_INCLUDES} external/zlib)
# 
# set(LOCAL_MODULE png)
# 
# set(LOCAL_COPY_HEADERS_TO ${common_COPY_HEADERS_TO})
# set(LOCAL_COPY_HEADERS ${common_COPY_HEADERS})
# 
# BUILD_HOST_STATIC_LIBRARY()


# For the device
# =====================================================

CLEAR_VARS()

concat(LOCAL_SRC_FILES ${common_SRC_FILES})
concat(LOCAL_CFLAGS ${common_CFLAGS})
concat(LOCAL_C_INCLUDES ${common_C_INCLUDES}
	${CMAKE_SOURCE_DIR}/external/zlib
    )
set(LOCAL_SHARED_LIBRARIES
	z
    )

set(LOCAL_MODULE png)

set(LOCAL_COPY_HEADERS_TO ${common_COPY_HEADERS_TO})
set(LOCAL_COPY_HEADERS ${common_COPY_HEADERS})

BUILD_STATIC_LIBRARY()



