set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})
CLEAR_VARS()

set(LOCAL_ARM_MODE arm)

set(LOCAL_SRC_FILES
	jcapimin.c jcapistd.c jccoefct.c jccolor.c jcdctmgr.c jchuff.c 
	jcinit.c jcmainct.c jcmarker.c jcmaster.c jcomapi.c jcparam.c 
	jcphuff.c jcprepct.c jcsample.c jctrans.c jdapimin.c jdapistd.c 
	jdatadst.c jdatasrc.c jdcoefct.c jdcolor.c jddctmgr.c jdhuff.c 
	jdinput.c jdmainct.c jdmarker.c jdmaster.c jdmerge.c jdphuff.c 
	jdpostct.c jdsample.c jdtrans.c jerror.c jfdctflt.c jfdctfst.c 
	jfdctint.c jidctflt.c jidctfst.c jidctint.c jidctred.c jquant1.c 
	jquant2.c jutils.c jmemmgr.c armv6_idct.S
    )

# use ashmem as libjpeg decoder's backing store
# concat(LOCAL_CFLAGS -DUSE_ANDROID_ASHMEM)
# concat(LOCAL_SRC_FILES
# 	jmem-ashmem.c
#     )

# the original android memory manager.
# use sdcard as libjpeg decoder's backing store
concat(LOCAL_SRC_FILES
	jmem-android.c
    )

concat(LOCAL_CFLAGS -DAVOID_TABLES )
concat(LOCAL_CFLAGS -O3 -fstrict-aliasing -fprefetch-loop-arrays)
#LOCAL_CFLAGS += -march=armv6j

# enable tile based decode
concat(LOCAL_CFLAGS -DANDROID_TILE_BASED_DECODE)

# enable armv6 idct assembly
concat(LOCAL_CFLAGS -DANDROID_ARMV6_IDCT)

set(LOCAL_MODULE jpeg)

set(LOCAL_SHARED_LIBRARIES
	cutils
    )

BUILD_SHARED_LIBRARY()
