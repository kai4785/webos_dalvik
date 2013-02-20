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

project(webos_dalvik)

# TODO: Not sure what other options we have here
set(HOST_OS "linux")
set(system_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/webos-system/usr/include)
# Not sure how to do this just yet. Probably with a make DESTIR=com.appname.something
set(CMAKE_INSTALL_PREFIX /com.kai.dalvikvm)

# Some Global variables
#set(JNI_H_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/dalvik/libnativehelper/include/nativehelper CACHE STRING "" FORCE)
set(JNI_H_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/libnativehelper/include/nativehelper CACHE STRING "" FORCE)

# Some Global C defines, perhaps this goes in the CMAKE_TOOLCHAIN_FILE, or some conditional variables?
add_definitions(-D_GNU_SOURCE -DOS_SHARED_LIB_FORMAT_STR="lib%s.so" -D_FILE_OFFSET_BITS=64)
add_definitions(-D_WebOS)

# Check for system header files. If these are missing, then we have to get them from external
include(CheckIncludeFiles)
check_include_files ("sched.h" HAVE_SCHED_H)
check_include_files ("sys/uio.h" HAVE_SYS_UIO_H)
check_include_files ("endian.h" HAVE_ENDIAN_H)
check_include_files ("pthread.h" HAVE_PTHREADS)
check_include_files ("sys/socket.h" HAVE_SOCKETH)
if(HAVE_SCHED_H)
    add_definitions(-DHAVE_SCHED_H)
endif()
if(HAVE_SYS_UIO_H)
    add_definitions(-DHAVE_SYS_UIO_H)
endif()
if(HAVE_ENDIAN_H)
# ./dalvik/vm/Common.h is using stupid HAVE_*_ENDIAN macro, instead of #if __BYTE_ORDER == __LITTLE_ENDIAN -- so we have to be dumb too
    add_definitions(-DHAVE_ENDIAN_H -DHAVE_LITTLE_ENDIAN)
endif()
if(HAVE_PTHREADS)
    add_definitions(-DHAVE_PTHREADS)
endif()
if(HAVE_SOCKETH)
    add_definitions(-DHAVE_SYS_SOCKET_H)
endif()

# Some options
option(DEBUG_DALVIK_VM "Debug Dalvik?" On)
option(VERBOSE_CONFIG "Verbose configuration messages" Off)
option(FOR_HOST "Build for the host, not a target" Off)
option(DUMMY_PACKAGE "Build a dummy package for WebOS 3.0.5" Off)

include(targets.cmake)
include(webos-package.cmake)
configure_file(${CMAKE_SOURCE_DIR}/cpu-features.h.in ${CMAKE_BINARY_DIR}/include/machine/cpu-features.h)

# And we're off!
if(DUMMY_PACKAGE)
    add_subdirectory(test)
else()
    add_subdirectory(external)
    add_subdirectory(system)
    android_add_subdirectory(libnativehelper)
    android_add_subdirectory(libcore)
    android_add_subdirectory(dalvik)
endif()

#message("Make sure you clean externals like so: 
#for proj in \
#external/expat external/fdlibm external/icu4c external/openssl external/safe-iop external/zlib system/core libcore libnativehelper dalvik; do \
#    pushd $proj; git clean -f -d; git checkout .; git status; popd;
#done
#")
