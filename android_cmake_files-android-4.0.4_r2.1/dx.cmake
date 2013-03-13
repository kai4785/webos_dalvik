# Copyright 2006 The Android Open Source Project
#
set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# We use copy-file-to-new-target so that the installed
# script files' timestamps are at least as new as the
# .jar files they wrap.

# This tool is prebuilt if we're doing an app-only build.
if("${TARGET_BUILD_APPS}" STREQUAL "")

# the dx script
# ============================================================
CLEAR_VARS()
set(LOCAL_IS_HOST_MODULE true)
set(LOCAL_MODULE_CLASS EXECUTABLES)
set(LOCAL_MODULE_TAGS optional)
set(LOCAL_MODULE dx)

#include $(BUILD_SYSTEM)/base_rules.mk
set(LOCAL_INSTALLED_MODULE ${LOCAL_MODULE})

# depends on dx.jar
#$(LOCAL_BUILT_MODULE): $(LOCAL_PATH)/etc/dx | $(ACP)
	#@echo "Copy: $(PRIVATE_MODULE) ($@)"
	#$(copy-file-to-new-target)
	#$(hide) chmod 755 $@
install(PROGRAMS etc/dx
    DESTINATION bin
    )
concat(INTERNAL_DALVIK_MODULES ${LOCAL_INSTALLED_MODULE})

endif() # TARGET_BUILD_APPS

# # the jasmin script
# # ============================================================
# include $(CLEAR_VARS)
# LOCAL_IS_HOST_MODULE := true
# LOCAL_MODULE_CLASS := EXECUTABLES
# LOCAL_MODULE_TAGS := optional
# LOCAL_MODULE := jasmin
# 
# include $(BUILD_SYSTEM)/base_rules.mk
# 
# $(LOCAL_BUILT_MODULE): $(HOST_OUT_JAVA_LIBRARIES)/jasmin.jar
# $(LOCAL_BUILT_MODULE): $(LOCAL_PATH)/etc/jasmin | $(ACP)
# 	@echo "Copy: $(PRIVATE_MODULE) ($@)"
# 	$(copy-file-to-new-target)
# 	$(hide) chmod 755 $@
# 
# INTERNAL_DALVIK_MODULES += $(LOCAL_INSTALLED_MODULE)
# 
# # the jasmin lib
# # ============================================================
# include $(CLEAR_VARS)
# LOCAL_IS_HOST_MODULE := true
# LOCAL_MODULE_CLASS := JAVA_LIBRARIES
# LOCAL_MODULE_TAGS := optional
# LOCAL_MODULE := jasmin.jar
# 
# include $(BUILD_SYSTEM)/base_rules.mk
# 
# $(LOCAL_BUILT_MODULE): $(LOCAL_PATH)/etc/jasmin.jar | $(ACP)
# 	@echo "Copy: $(PRIVATE_MODULE) ($@)"
# 	$(copy-file-to-target)
# 	$(hide) chmod 644 $@
# 
# INTERNAL_DALVIK_MODULES += $(LOCAL_INSTALLED_MODULE)
# 
# # the other stuff
# # ============================================================
# subdirs := $(addprefix $(LOCAL_PATH)/,$(addsuffix /Android.mk, \
# 		src \
# 	))
# 
android_include(dx_src.cmake)
