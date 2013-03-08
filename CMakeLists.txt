cmake_minimum_required(VERSION 2.8)

if(CMAKE_TOOLCHAIN_FILE)
    message("Building with toolchain file ${CMAKE_TOOLCHAIN_FILE}")
elseif(FOR_HOST)
    message(WARNING "You should consider calling cmake with CFLAGS=-m32 CXXFLAGS=-m32 variables set")
    SET(CMAKE_ASM_COMPILE_OBJECT
            "<CMAKE_ASM_COMPILER> <FLAGS> <DEFINES> -c -o <OBJECT> <SOURCE>")
    set(TARGET_ARCH x86)
    set(TARGET_ARCH_VARIANT x86)
    set(TARGET_OS linux)
    #set(TARGET_GLOBAL_CFLAGS "-m32")
    #set(TARGET_GLOBAL_CFLAGS "-m32")
    #set(TARGET_GLOBAL_LDFLAGS "-m32")
else()
    message(STATUS "Setting up WebOS 3.0.5 PDK toolchain")
    include(webos-toolchain.cmake) #Must be done before the first "project" call
endif()

enable_language(ASM-ATT)
enable_language(ASM)

if(NOT GIT_TAG)
    #libnative helper was moved to ${CMAKE_SOURCE_DIR} in 4.1
    set(GIT_TAG android-4.0.4_r2.1)
    #set(GIT_TAG master)
endif()
option(GIT_CLEAN "Clean out changes to git submodules" On)

set(submodules external/expat external/fdlibm external/icu4c external/openssl external/safe-iop external/zlib system/core libcore libnativehelper dalvik)
#FIXME Figure out how to make this work. Probably custom target so we can set CWD
foreach(module ${submodules})
    execute_process(COMMAND cd ${CMAKE_SOURCE_DIR} && git submodule foreach git clean -f -d)
    execute_process(COMMAND cd ${CMAKE_SOURCE_DIR} && git submodule foreach git checkout .)
    execute_process(COMMAND cd ${CMAKE_SOURCE_DIR} && git submodule foreach git checkout ${GIT_TAG})
endforeach()

project(webos_dalvik)

# TODO: Not sure what other options we have here
set(HOST_OS "linux")
# Not sure how to do this just yet. Probably with a make DESTIR=com.appname.something
set(CMAKE_INSTALL_PREFIX /com.kai.dalvikvm)

# Some Global variables
#set(JNI_H_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/dalvik/libnativehelper/include/nativehelper CACHE STRING "" FORCE)
set(JNI_H_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/libnativehelper/include/nativehelper CACHE STRING "" FORCE)

# Configure the "always included" configuration file
include(webOSConfig.cmake)

# Some options
option(DEBUG_DALVIK_VM "Debug Dalvik?" On)
option(VERBOSE_CONFIG "Verbose configuration messages" Off)
option(FOR_HOST "Build for the host, not a target" Off)
option(TEST "Build a dltest executable" Off)

include(targets.cmake)
include(webos-package.cmake)
set(system_INCLUDE_DIR ${CMAKE_BINARY_DIR}/include)
configure_file(${CMAKE_SOURCE_DIR}/cpu-features.h.in ${CMAKE_BINARY_DIR}/include/machine/cpu-features.h)

# And we're off!
if(TEST)
    add_subdirectory(test)
endif()
add_subdirectory(external)
add_subdirectory(system)
if(${GIT_TAG} STREQUAL master)
    android_add_subdirectory(libnativehelper)
endif()
android_add_subdirectory(libcore)
android_add_subdirectory(dalvik)
if(WORK_IN_PROGRESS)
    android_add_subdirectory(frameworks/base/core/jni)
    android_add_subdirectory(frameworks/base/cmds/app_process)
endif()
if(WEBOS_RUNTIME)
    android_add_subdirectory(frameworks/base/libs/utils)
    android_add_subdirectory(frameworks/base/libs/binder)
    add_subdirectory(webos_runtime)
endif()
