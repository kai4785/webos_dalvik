set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})
CLEAR_VARS()

set(LOCAL_C_INCLUDES
    ${JNI_H_INCLUDE}
    ${CMAKE_CURRENT_SOURCE_DIR}
    )

set(LOCAL_SRC_FILES
	app_main.cpp
    )

set(LOCAL_SHARED_LIBRARIES
	cutils 
	utils 
	#binder 
	#android_runtime
    )

set(LOCAL_MODULE app_process)

BUILD_EXECUTABLE()

