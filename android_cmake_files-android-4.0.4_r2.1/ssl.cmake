set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})

set(local_c_includes
	${openssl_INCLUDE_DIR} 
	${openssl_INCLUDE_DIR}/include 
	${openssl_INCLUDE_DIR}/crypto
    )

set(local_src_files
	s2_meth.c 
	s2_srvr.c 
	s2_clnt.c 
	s2_lib.c 
	s2_enc.c 
	s2_pkt.c 
	s3_meth.c 
	s3_srvr.c 
	s3_clnt.c 
	s3_lib.c 
	s3_enc.c 
	s3_pkt.c 
	s3_both.c 
	s23_meth.c 
	s23_srvr.c 
	s23_clnt.c 
	s23_lib.c 
	s23_pkt.c 
	t1_meth.c 
	t1_srvr.c 
	t1_clnt.c 
	t1_lib.c 
	t1_enc.c 
	t1_reneg.c 
	ssl_lib.c 
	ssl_err2.c 
	ssl_cert.c 
	ssl_sess.c 
	ssl_ciph.c 
	ssl_stat.c 
	ssl_rsa.c 
	ssl_asn1.c 
	ssl_txt.c 
	ssl_algs.c 
	bio_ssl.c 
	ssl_err.c 
	kssl.c
    )

#######################################
# target static library
# Save build time, skip _static
# CLEAR_VARS()
# android_include(webos-config.cmake)
# 
# #ifneq (,$(TARGET_BUILD_APPS))
# #LOCAL_SDK_VERSION := 9
# #endif
# 
# concat(LOCAL_SRC_FILES ${local_src_files})
# concat(LOCAL_C_INCLUDES ${local_c_includes})
# set(LOCAL_SHARED_LIBRARIES ${log_shared_libraries})
# set(LOCAL_MODULE_TAGS optional)
# set(LOCAL_MODULE ssl_static)
# set(LOCAL_ADDITIONAL_DEPENDENCIES := ${local_additional_dependencies})
# BUILD_STATIC_LIBRARY()

#######################################
# target shared library
CLEAR_VARS()
android_include(webos-config.cmake)

#ifneq ($(TARGET_ARCH),x86)
#LOCAL_NDK_VERSION := 5
#LOCAL_SDK_VERSION := 9
#endif

concat(LOCAL_SRC_FILES ${local_src_files})
concat(LOCAL_C_INCLUDES ${local_c_includes})
concat(LOCAL_SHARED_LIBRARIES crypto)
set(LOCAL_MODULE_TAGS optional)
set(LOCAL_MODULE ssl)
BUILD_SHARED_LIBRARY()

# #######################################
# # host shared library
# include $(CLEAR_VARS)
# include $(LOCAL_PATH)/android-config.mk
# LOCAL_SRC_FILES += $(local_src_files)
# LOCAL_C_INCLUDES += $(local_c_includes)
# LOCAL_SHARED_LIBRARIES += libcrypto $(log_shared_libraries)
# LOCAL_MODULE_TAGS := optional
# LOCAL_MODULE:= libssl
# LOCAL_ADDITIONAL_DEPENDENCIES := $(local_additional_dependencies)
# include $(BUILD_HOST_SHARED_LIBRARY)
# 
# #######################################
# # ssltest
# include $(CLEAR_VARS)
# include $(LOCAL_PATH)/android-config.mk
# LOCAL_SRC_FILES:= ssl/ssltest.c
# LOCAL_C_INCLUDES += $(local_c_includes)
# LOCAL_SHARED_LIBRARIES := libssl libcrypto $(log_shared_libraries)
# LOCAL_MODULE:= ssltest
# LOCAL_MODULE_TAGS := optional
# LOCAL_ADDITIONAL_DEPENDENCIES := $(local_additional_dependencies)
# include $(BUILD_EXECUTABLE)
# 
