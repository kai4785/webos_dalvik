#Simple tool-chain selection for WebOS 3.0.5 PDK
set(_CMAKE_TOOLCHAIN_PREFIX /opt/PalmPDK/arm-gcc/bin/arm-none-linux-gnueabi-)
set(CMAKE_FIND_ROOT_PATH /opt/PalmPDK /opt/PalmPDK/device /opt/PalmPDK/arm-gcc)
set(CMAKE_ASM_COMPILER ${_CMAKE_TOOLCHAIN_PREFIX}gcc)
#set(CMAKE_ASM_COMPILE_OBJECT
    #"<CMAKE_ASM_COMPILER> <FLAGS> <DEFINES> -c -o <OBJECT> <SOURCE>")
set(ASM_DIALECT "-ATT")
    set(CMAKE_ASM${ASM_DIALECT}_COMPILE_OBJECT "<CMAKE_ASM${ASM_DIALECT}_COMPILER> <FLAGS> -o <OBJECT> <SOURCE> -c")
set(ASM_DIALECT)
set(CMAKE_ASM${ASM_DIALECT}_COMPILE_OBJECT "<CMAKE_ASM${ASM_DIALECT}_COMPILER> <FLAGS> -o <OBJECT> <SOURCE> -c")
# Special values for dalvik
set(TARGET_OS linux)
#FIXME: Fix (Error: selected processor does not support `dmb') if set to true
#FIXME: Fix (Error: bad barrier type -- `dmb st') if set to true
set(TARGET_CPU_SMP false)
set(TARGET_ARCH arm)
set(TARGET_ARCH_VARIANT armv7-a-neon)
set(TARGET_GLOBAL_CFLAGS "-march=armv7-a -mfpu=neon -mfloat-abi=softfp")
