set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})
CLEAR_VARS()

# measurements show that the ARM version of ZLib is about x1.17 faster
# than the thumb one...
set(LOCAL_ARM_MODE arm)

set(zlib_files
	src/adler32.c 
	src/compress.c 
	src/crc32.c 
	src/deflate.c 
	src/gzclose.c 
	src/gzlib.c 
	src/gzread.c 
	src/gzwrite.c 
	src/infback.c 
	src/inflate.c 
	src/inftrees.c 
	src/inffast.c 
	src/trees.c 
	src/uncompr.c 
	src/zutil.c
    )

set(LOCAL_MODULE libz)
set(LOCAL_MODULE_TAGS optional)
concat(LOCAL_CFLAGS -O3 -DUSE_MMAP)
set(LOCAL_SRC_FILES ${zlib_files})
if(${TARGET_ARCH} STREQUAL arm)
  set(LOCAL_SDK_VERSION 9)
endif()
BUILD_SHARED_LIBRARY()

CLEAR_VARS()

set(LOCAL_ARM_MODE arm)
set(LOCAL_MODULE libz_static)
set(LOCAL_MODULE_TAGS optional)
concat(LOCAL_CFLAGS -O3 -DUSE_MMAP)
set(LOCAL_SRC_FILES ${zlib_files})
if(${TARGET_ARCH} STREQUAL arm)
  set(LOCAL_SDK_VERSION 9)
endif()
BUILD_STATIC_LIBRARY()

# include $(CLEAR_VARS)
# 
# LOCAL_ARM_MODE := arm
# LOCAL_MODULE := libz
# LOCAL_MODULE_TAGS := optional
# LOCAL_CFLAGS += -O3 -DUSE_MMAP
# LOCAL_SRC_FILES := $(zlib_files)
# include $(BUILD_HOST_STATIC_LIBRARY)
# 
# 
# include $(CLEAR_VARS)
# 
# LOCAL_ARM_MODE := arm
# LOCAL_MODULE := libz-host
# LOCAL_MODULE_TAGS := optional
# LOCAL_CFLAGS += -O3 -DUSE_MMAP
# LOCAL_SRC_FILES := $(zlib_files)
# include $(BUILD_HOST_SHARED_LIBRARY)



# libunz used to be an unzip-only subset of libz. Only host-side tools were
# taking advantage of it, though, and it's not a notion supported by zlib
# itself. This caused trouble during the 1.2.6 upgrade because libunz ended
# up needing to drag in most of the other files anyway. So this is a first
# step towards killing libunz. If you're reading this in the K release or
# later, please see if you can get a bit further in removing libunz...

# include $(CLEAR_VARS)
# LOCAL_SRC_FILES := $(zlib_files)
# LOCAL_MODULE:= libunz
# LOCAL_ARM_MODE := arm
# include $(BUILD_HOST_STATIC_LIBRARY)
# 
CLEAR_VARS()
set(LOCAL_SRC_FILES ${zlib_files})
set(LOCAL_MODULE libunz)
set(LOCAL_ARM_MODE arm)
if(${TARGET_ARCH} STREQUAL arm)
  set(LOCAL_SDK_VERSION 9)
endif()
BUILD_STATIC_LIBRARY()

CLEAR_VARS()

set(LOCAL_SRC_FILES
	src/test/minigzip.c)

set(LOCAL_MODULE gzip)

set(LOCAL_SHARED_LIBRARIES libz)

BUILD_EXECUTABLE()

# include $(CLEAR_VARS)
# 
# LOCAL_SRC_FILES:=        
# 	src/test/minigzip.c
# 
# LOCAL_MODULE:= minigzip
# 
# LOCAL_STATIC_LIBRARIES := libz
# 
# include $(BUILD_HOST_EXECUTABLE)
# 
