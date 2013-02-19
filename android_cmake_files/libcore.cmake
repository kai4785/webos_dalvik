# -*- mode: makefile -*-
# Copyright (C) 2009 The Android Open Source Project
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

set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(libcore_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE STRING "" FORCE)


#
# Include the definitions to build the Java code.
#

android_include(JavaLibrary.cmake)


#
# Include the definitions to build the native code.
#

android_include(NativeCode.cmake)

#
# Include the definitions for the Certificate Authority (CA) certificates
#

#TODO: Do we need this?
#include $(LOCAL_PATH)/CaCerts.mk

#
# Disable test modules if LIBCORE_SKIP_TESTS environment variable is set.
#

# ifneq ($(LIBCORE_SKIP_TESTS),)
# $(info ********************************************************************************)
# $(info * libcore tests are skipped because environment variable LIBCORE_SKIP_TESTS=$(LIBCORE_SKIP_TESTS))
# $(info ********************************************************************************)
# endif
# 
# 
# #
# # "m dalvik-host" for quick minimal host build
# #
# 
# ifeq ($(WITH_HOST_DALVIK),true)
#     .PHONY: dalvik-host
#     dalvik-host: \
#         dalvik \
#         $(HOST_OUT)/bin/dalvikvm \
#         $(HOST_OUT)/bin/dexopt \
#         $(HOST_OUT)/lib/libjavacore.so \
#         cacerts-host \
#         core-hostdex \
#         bouncycastle-hostdex \
#         apache-xml-hostdex \
#         apache-harmony-tests-hostdex \
#         $(call intermediates-dir-for,JAVA_LIBRARIES,core-tests,,COMMON)/classes.jar
# endif
# 
