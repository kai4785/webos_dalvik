set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})

CLEAR_VARS()

set(LOCAL_C_INCLUDES
    ${JNI_H_INCLUDE}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/frameworks/base/include
    ${libnativehelper_INCLUDE_DIR}/include
    )

set(LOCAL_SRC_FILES
    android_os_SystemProperties.cpp
    android_util_Log.cpp
    android_internal_os_ZygoteInit.cpp
    android_net_LocalSocketImpl.cpp
    webOSRuntime.cpp
    )

set(LOCAL_SHARED_LIBRARIES
    )

set(LOCAL_LDFLAGS -L/opt/PalmPDK/device/lib)

set(LOCAL_MODULE webos_runtime)

BUILD_SHARED_LIBRARY()

CLEAR_VARS()

set(LOCAL_C_INCLUDES
    ${JNI_H_INCLUDE}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/frameworks/base/include
    )

set(LOCAL_SRC_FILES
	app_main.cpp
    )

set(LOCAL_SHARED_LIBRARIES
	cutils 
	utils 
	binder 
    dvm
    webos_runtime
    )

concat(LOCAL_LDLIBS -lgcc_s)

set(LOCAL_MODULE app_process)

BUILD_EXECUTABLE()

