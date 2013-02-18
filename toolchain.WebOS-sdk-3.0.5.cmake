# How is this better/different than setting _CMAKE_TOOLCHAIN_PREFIX ???
# this one is important
SET(CMAKE_SYSTEM_NAME Linux)
#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)

# specify the cross compiler
SET(CMAKE_C_COMPILER   /opt/PalmPDK/arm-gcc/bin/arm-none-linux-gnueabi-gcc)
SET(CMAKE_CXX_COMPILER /opt/PalmPDK/arm-gcc/bin/arm-none-linux-gnueabi-g++)
SET(CMAKE_ASM_COMPILER /opt/PalmPDK/arm-gcc/bin/arm-none-linux-gnueabi-gcc)
SET(CMAKE_RANLIB       /opt/PalmPDK/arm-gcc/bin/arm-none-linux-gnueabi-ranlib)

SET(CMAKE_ASM_COMPILE_OBJECT
    "<CMAKE_ASM_COMPILER> <FLAGS> <DEFINES> -c -o <OBJECT> <SOURCE>")

# where is the target environment 
SET(CMAKE_FIND_ROOT_PATH /opt/PalmPDK /opt/PalmPDK/device /opt/PalmPDK/arm-gcc)

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Special values for dalvik
set(TARGET_OS linux)
set(TARGET_CPU_SMP false)
set(TARGET_ARCH arm)
set(TARGET_ARCH_VARIANT armv7-a-neon)

set(TARGET_GLOBAL_CFLAGS "-mfpu=neon -mfloat-abi=softfp")
