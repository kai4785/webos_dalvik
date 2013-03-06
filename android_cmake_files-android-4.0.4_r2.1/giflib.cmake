set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})
CLEAR_VARS()

set(LOCAL_SRC_FILES
	dgif_lib.c 
	gifalloc.c 
	gif_err.c
    )

concat(LOCAL_CFLAGS -Wno-format -DHAVE_CONFIG_H)

set(LOCAL_MODULE gif)

BUILD_STATIC_LIBRARY()
