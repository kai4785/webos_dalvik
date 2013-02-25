set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# Enable to be able to use ALOG* with #include "cutils/log.h"
#log_c_includes += system/core/include
#log_shared_libraries := liblog

# These makefiles are here instead of being Android.mk files in the
# respective crypto, ssl, and apps directories so
# that import_openssl.sh import won't remove them.
android_include(Crypto.cmake)
android_include(Ssl.cmake)
#android_include(Apps.cmake)
