# -*- mode: makefile -*-
# Copyright (C) 2007 The Android Open Source Project
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
# Definitions for building the native code needed for the core library.
#

#
# Common definitions for host and target.
#

# These two definitions are used to help sanity check what's put in
# sub.mk. See, the "error" directives immediately below.
set(core_magic_local_target ...//::default:://...)
set(core_local_path ${CMAKE_CURRENT_SOURCE_DIR})

# Include a submakefile, resolve its source file locations,
# and stick them on core_src_files.  The submakefiles are
# free to append to LOCAL_SRC_FILES, LOCAL_C_INCLUDES,
# LOCAL_SHARED_LIBRARIES, or LOCAL_STATIC_LIBRARIES, but nothing
# else. All other LOCAL_* variables will be ignored.
#
# $(1): directory containing the makefile to include
#define include-core-native-dir
#    LOCAL_SRC_FILES :=
#    include $(LOCAL_PATH)/$(1)/sub.mk
#    ifneq ($$(LOCAL_MODULE),$(core_magic_local_target))
#        $$(error $(LOCAL_PATH)/$(1)/sub.mk should not include CLEAR_VARS \
#            or define LOCAL_MODULE)
#    endif
#    ifneq ($$(LOCAL_PATH),$(core_local_path))
#        $$(error $(LOCAL_PATH)/$(1)/sub.mk should not define LOCAL_PATH)
#    endif
#    core_src_files += $$(addprefix $(1)/,$$(LOCAL_SRC_FILES))
#    LOCAL_SRC_FILES :=
#endef
macro(include_core_native_dir)
    # TODO: Make this more like the above. I don't have a good solution yet, so
    # we'll just hard code stuff
    #libcore/luni/src/test/native/sub.mk
    #libcore/luni/src/main/native/sub.mk
    #libcore/dalvik/src/main/native/sub.mk
    android_include(libcore_luni_sub.cmake)
    set(DIR "${core_local_path}/luni/src/main/native")
    foreach(src_file ${LOCAL_SRC_FILES})
        concat(core_src_files "${DIR}/${src_file}")
    endforeach()
    set(LOCAL_SRC_FILES )

    android_include(libcore_dalvik_sub.cmake)
    set(DIR "${core_local_path}/dalvik/src/main/native")
    foreach(src_file ${LOCAL_SRC_FILES})
        concat(core_src_files "${DIR}/${src_file}")
    endforeach()
    set(LOCAL_SRC_FILES )
endmacro()

# Skip the test library.....
# # Set up the default state. Note: We use CLEAR_VARS here, even though
# # we aren't quite defining a new rule yet, to make sure that the
# # sub.mk files don't see anything stray from the last rule that was
# # set up.
# 
# # Set up the test library first
# ifeq ($(LIBCORE_SKIP_TESTS),)
# include $(CLEAR_VARS)
# LOCAL_MODULE := $(core_magic_local_target)
# core_src_files :=
# 
# # Include the sub.mk files.
# $(foreach dir, \
#     luni/src/test/native, \
#     $(eval $(call include-core-native-dir,$(dir))))
# 
# # This is for the test library, so rename the variable.
# test_src_files := $(core_src_files)
# core_src_files :=
# 
# # Extract out the allowed LOCAL_* variables. Note: $(sort) also
# # removes duplicates.
# test_c_includes := $(sort libcore/include $(LOCAL_C_INCLUDES) $(JNI_H_INCLUDE))
# test_shared_libraries := $(sort $(LOCAL_SHARED_LIBRARIES))
# test_static_libraries := $(sort $(LOCAL_STATIC_LIBRARIES))
# endif # LIBCORE_SKIP_TESTS
# 
# 
CLEAR_VARS()
set(LOCAL_MODULE ${core_magic_local_target})
#LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/NativeCode.mk
set(core_src_files )

# Include the sub.mk files.
include_core_native_dir()
#$(foreach dir, \
    #dalvik/src/main/native luni/src/main/native, \
    #$(eval $(call include-core-native-dir,$(dir))))

# Extract out the allowed LOCAL_* variables. Note: $(sort) also
# removes duplicates.
set(core_c_includes ${libcore_INCLUDE_DIR}/include ${LOCAL_C_INCLUDES} ${JNI_H_INCLUDE})
set(core_shared_libraries ${LOCAL_SHARED_LIBRARIES})
set(core_static_libraries ${LOCAL_STATIC_LIBRARIES})
set(core_cflags -fvisibility=hidden -fvisibility-inlines-hidden)
#FIXME: What horrible quote problems!
concat(core_cflags "'-DGCC_HIDDEN=__attribute__((visibility(\"hidden\")))'")


#
# Build for the target (device).
#

CLEAR_VARS()

#concat(LOCAL_CFLAGS -Wall -Wextra -Werror)
concat(LOCAL_CFLAGS ${core_cflags})
#ifeq ($(TARGET_ARCH),arm)
# Ignore "note: the mangling of 'va_list' has changed in GCC 4.4"
#concat(LOCAL_CFLAGS += -Wno-psabi
#endif

# Define the rules.
set(LOCAL_SRC_FILES ${core_src_files})
set(LOCAL_C_INCLUDES ${core_c_includes})
set(LOCAL_SHARED_LIBRARIES ${core_shared_libraries})
set(LOCAL_STATIC_LIBRARIES ${core_static_libraries})
set(LOCAL_MODULE_TAGS optional)
set(LOCAL_MODULE javacore)

#concat(LOCAL_C_INCLUDES external/stlport/stlport bionic/ bionic/libstdc++/include)
#concat(LOCAL_SHARED_LIBRARIES libstlport)

BUILD_STATIC_LIBRARY()

# #
# # Build for the host.
# #
# 
# ifeq ($(WITH_HOST_DALVIK),true)
#     include $(CLEAR_VARS)
#     # Define the rules.
#     LOCAL_SRC_FILES := $(core_src_files)
#     LOCAL_CFLAGS += $(core_cflags)
#     LOCAL_C_INCLUDES := $(core_c_includes)
#     LOCAL_SHARED_LIBRARIES := $(core_shared_libraries)
#     LOCAL_STATIC_LIBRARIES := $(core_static_libraries)
#     LOCAL_MODULE_TAGS := optional
#     LOCAL_MODULE := libjavacore-host
#     include $(BUILD_HOST_STATIC_LIBRARY)
# endif
