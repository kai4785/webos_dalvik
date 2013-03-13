# Copyright 2006 The Android Open Source Project
#
#FIXME Find a better way to handle android_add_subdirectory for this file
set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR}/src)

# This tool is prebuilt if we're doing an app-only build.
if("${TARGET_BUILD_APPS}" STREQUAL "")

# dx java library
# ============================================================
CLEAR_VARS()

file(GLOB_RECURSE LOCAL_SRC_FILES ${LOCAL_PATH}/*.java)
#set(LOCAL_SRC_FILES $(call all-subdir-java-files))
set(LOCAL_JAR_MANIFEST ${LOCAL_PATH}/../etc/manifest.txt)
set(LOCAL_MODULE_TAGS optional)
set(LOCAL_MODULE dx)

BUILD_HOST_JAVA_LIBRARY()

concat(INTERNAL_DALVIK_MODULES ${LOCAL_INSTALLED_MODULE})

endif() # TARGET_BUILD_APPS

# # the documentation
# # ============================================================
# include $(CLEAR_VARS)
# 
# LOCAL_SRC_FILES := $(call all-subdir-java-files) $(call all-subdir-html-files)
# LOCAL_MODULE_TAGS := optional
# LOCAL_MODULE:= dx
# LOCAL_DROIDDOC_OPTIONS := -hidden
# LOCAL_MODULE_CLASS := JAVA_LIBRARIES
# LOCAL_IS_HOST_MODULE := true
# 
# include $(BUILD_DROIDDOC)
# 
