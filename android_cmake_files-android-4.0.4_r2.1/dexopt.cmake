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
# dexopt, the DEX file optimizer.  This is fully integrated with the VM,
# so it must be linked against the full VM shared library.
#
set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})

set(local_src_files
		OptMain.cpp)

set(local_c_includes
		${dalvik_INCLUDE_DIR} 
		${dalvik_INCLUDE_DIR}/libdex 
		${dalvik_INCLUDE_DIR}/vm 
		${JNI_H_INCLUDE}
        )

set(local_shared_libraries
		ssl
		dvm 
		crypto 
		icuuc 
		icui18n
        )

CLEAR_VARS()
if(${TARGET_CPU_SMP})
    concat(LOCAL_CFLAGS -DANDROID_SMP=1)
else()
    concat(LOCAL_CFLAGS -DANDROID_SMP=0)
endif()

set(LOCAL_SRC_FILES ${local_src_files})
set(LOCAL_C_INCLUDES ${local_c_includes})
set(LOCAL_SHARED_LIBRARIES ${local_shared_libraries} cutils expat log nativehelper z)
set(LOCAL_MODULE_TAGS optional)
set(LOCAL_MODULE dexopt)

#LOCAL_C_INCLUDES += external/stlport/stlport bionic/ bionic/libstdc++/include
#LOCAL_SHARED_LIBRARIES += libstlport

BUILD_EXECUTABLE()

# ifeq ($(WITH_HOST_DALVIK),true)
#     include $(CLEAR_VARS)
#     LOCAL_SRC_FILES := $(local_src_files)
#     LOCAL_C_INCLUDES := $(local_c_includes)
#     LOCAL_SHARED_LIBRARIES := $(local_shared_libraries)
#     LOCAL_STATIC_LIBRARIES :=  libcutils libexpat liblog libnativehelper libz
#     LOCAL_LDLIBS += -ldl -lpthread
#     LOCAL_CFLAGS += -DANDROID_SMP=1
#     LOCAL_MODULE_TAGS := optional
#     LOCAL_MODULE := dexopt
#     include $(BUILD_HOST_EXECUTABLE)
# endif
# 
