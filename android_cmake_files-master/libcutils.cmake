#
# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})
CLEAR_VARS()

if(${TARGET_CPU_SMP})
    set(targetSmpFlag -DANDROID_SMP=1)
else()
    set(targetSmpFlag -DANDROID_SMP=0)
endif()
set(hostSmpFlag := -DANDROID_SMP=0)

set(commonSources
	array.c 
	hashmap.c 
	atomic.c #.arm 
	native_handle.c 
	buffer.c 
	socket_inaddr_any_server.c 
	socket_local_client.c 
	socket_local_server.c 
	socket_loopback_client.c 
	socket_loopback_server.c 
	socket_network_client.c 
	sockets.c 
	config_utils.c 
	cpu_info.c 
	load_file.c 
	list.c 
	open_memstream.c 
	strdup16to8.c 
	strdup8to16.c 
	record_stream.c 
	process_name.c 
	properties.c 
	qsort_r_compat.c 
	threads.c 
	sched_policy.c 
	iosched_policy.c 
	str_parms.c 
    )

set(commonHostSources
        ashmem-host.c
        )

# TODO: Somebody else can fix the Windows build...
# some files must not be compiled when building against Mingw
# they correspond to features not used by our host development tools
# which are also hard or even impossible to port to native Win32
#WINDOWS_HOST_ONLY :=
#ifeq ($(HOST_OS),windows)
#    ifeq ($(strip $(USE_CYGWIN)),)
#        WINDOWS_HOST_ONLY := 1
#    endif
#endif
## USE_MINGW is defined when we build against Mingw on Linux
#ifneq ($(strip $(USE_MINGW)),)
#    WINDOWS_HOST_ONLY := 1
#endif
#
#ifeq ($(WINDOWS_HOST_ONLY),1)
#    commonSources += 
#        uio.c
#else
    concat(commonSources
        abort_socket.c 
        fs.c 
        selector.c 
        multiuser.c 
        zygote.c
        )
#endif


# # Static library for host
# # ========================================================
# LOCAL_MODULE := libcutils
# LOCAL_SRC_FILES := $(commonSources) $(commonHostSources) dlmalloc_stubs.c
# LOCAL_LDLIBS := -lpthread
# LOCAL_STATIC_LIBRARIES := liblog
# LOCAL_CFLAGS += $(hostSmpFlag)
# include $(BUILD_HOST_STATIC_LIBRARY)


# # Static library for host, 64-bit
# # ========================================================
# include $(CLEAR_VARS)
# LOCAL_MODULE := lib64cutils
# LOCAL_SRC_FILES := $(commonSources) $(commonHostSources) dlmalloc_stubs.c
# LOCAL_LDLIBS := -lpthread
# LOCAL_STATIC_LIBRARIES := lib64log
# LOCAL_CFLAGS += $(hostSmpFlag) -m64
# include $(BUILD_HOST_STATIC_LIBRARY)


# Shared and static library for target
# ========================================================

# This is needed in LOCAL_C_INCLUDES to access the C library's private
# header named <bionic_time.h>
#
#set(libcutils_c_includes bionic/libc/private)

CLEAR_VARS()
set(LOCAL_MODULE cutils_static)
#FIXME: Fix the need to include the PDK reboot.h for LINUX_REBOOT_MAGIC* values in android_reboot.c
#concat(LOCAL_CFLAGS "-include /opt/PalmPDK/arm-gcc/sysroot/usr/include/linux/reboot.h")
set(LOCAL_SRC_FILES ${commonSources}
        #android_reboot.c # NOTE: I don't think we need this for dalivkvm
        #ashmem-dev.c 
        ashmem-host.c #TODO: Port ashmem to webOS
        debugger.c 
        klog.c 
        mq.c 
        partition_utils.c 
        qtaguid.c 
        uevent.c
        )
#FIXME: Fix dlmalloc to actually work properly please.
concat(LOCAL_SRC_FILES dlmalloc_stubs.c)

if(${TARGET_ARCH} STREQUAL arm)
    concat(LOCAL_SRC_FILES arch-arm/memset32.S)
else()  # !arm
    #TODO: Somebody care about this later
    #ifeq ($(TARGET_ARCH_VARIANT),x86-atom)
    #    LOCAL_CFLAGS += -DHAVE_MEMSET16 -DHAVE_MEMSET32
    #    LOCAL_SRC_FILES += arch-x86/android_memset16.S arch-x86/android_memset32.S memory.c
    #else() # !x86-atom
    #    LOCAL_SRC_FILES += memory.c
    #endif() # !x86-atom
endif() # !arm
#For strlcpy:
concat(LOCAL_CFLAGS -DHAVE_MEMSET16 -DHAVE_MEMSET32)
concat(LOCAL_SRC_FILES memory.c)

set(LOCAL_C_INCLUDES ${libcutils_c_includes}) # For ashmem-dev.c $(KERNEL_HEADERS)
#set(LOCAL_STATIC_LIBRARIES log_static)
concat(LOCAL_CFLAGS ${targetSmpFlag})
# Save build time, skip _static
#BUILD_STATIC_LIBRARY()

#include $(CLEAR_VARS)
set(LOCAL_MODULE cutils)
#LOCAL_WHOLE_STATIC_LIBRARIES := libcutils
set(LOCAL_SHARED_LIBRARIES log)
#LOCAL_CFLAGS += $(targetSmpFlag)
#LOCAL_C_INCLUDES := $(libcutils_c_includes)
set(LOCAL_LDLIBS -lpthread)
BUILD_SHARED_LIBRARY()

# Don't care right now
#include $(CLEAR_VARS)
#LOCAL_MODULE := tst_str_parms
#LOCAL_CFLAGS += -DTEST_STR_PARMS
#LOCAL_SRC_FILES := str_parms.c hashmap.c memory.c
#LOCAL_SHARED_LIBRARIES := liblog
#LOCAL_MODULE_TAGS := optional
#include $(BUILD_EXECUTABLE)

# These are test make files, don't care right now
#include $(call all-makefiles-under,$(LOCAL_PATH))

