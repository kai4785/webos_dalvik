# This file will configure our webOSConfig.h file, that gets include in every single C/C++ file by virtue of '-include webOSConfig.h'
# We are using cmake to create this config file on the fly, detecting what is actually present, rather than statically setting them.
include(CheckIncludeFiles)
include(CheckFunctionExists)
include(CheckSymbolExists)
include(CheckLibraryExists)
include(CheckTypeSize)
include(CheckStructHasMember)
check_include_files(pthread.h HAVE_PTHREADS)
check_function_exists(pthread_setname_np HAVE_ANDROID_PTHREAD_SETNAME_NP)
check_symbol_exists(SYS_futex syscall.h HAVE_FUTEX)
set(HAVE_FUTEX_WRAPPERS) # We aren't compiling against bionic
check_function_exists(fork HAVE_FORK)
check_function_exists(execl HAVE_EXEC)
if(HAVE_FORK AND HAVE_EXEC)
    set(HAVE_FORKEXEC True)
endif()
set(HAVE_OOM_ADJ True) # We have /proc/<pid>/oom_adj
check_function_exists(semget HAVE_SYSV_IPC)
set(HAVE_ANDROID_IPC False)
check_include_files(sys/mman.h HAVE_POSIX_FILEMAP)
check_include_files(termio.h HAVE_TERMIO_H)
check_include_files(sys/sendfile.h HAVE_SYS_SENDFILE_H)
check_include_files (sys/uio.h HAVE_SYS_UIO_H)
set(HAVE_SYMLINKS True) # Will this ever be false?
check_function_exists(ioctl HAVE_IOCTL)
check_library_exists(rt clock_gettime "" HAVE_POSIX_CLOCKS)
check_library_exists(pthread pthread_cond_timedwait_monotonic "" HAVE_TIMEDWAIT_MONOTONIC)
check_include_files(sys/epoll.h HAVE_EPOLL)
check_include_files (endian.h HAVE_ENDIAN_H)
set(HAVE_LITTLE_ENDIAN True) # Always true?
check_type_size(off64_t HAVE_OFF64_T) # We could if we could set -D_FILE_OFFSET_BITS=64 correctly
check_type_size(loff_t HAVE_LOFF_T)
check_function_exists(backtrace HAVE_BACKTRACE)
check_function_exists(dladdr HAVE_DLADDR)
check_include_files(cxxabi.h HAVE_CXXABI) # This should be found in /opt/PalmPDK/arm-gcc/arm-none-linux-gnueabi/include/c++/4.3.3/cxxabi.h
check_symbol_exists(SYS_gettid syscall.h HAVE_GETTID) # gettid() actually doesn't exist by itself, one must call syscall(SYS_gettid); instead
check_function_exists(sched_setscheduler HAVE_SCHED_SETSCHEDULER)
check_include_files(malloc.h HAVE_MALLOC_H)
set(HAVE_ANDROID_OS False) # What's the impact of setting this to True?
check_include_files(sys/inotify.h HAVE_INOTIFY)
check_symbol_exists(madvise sys/mman.h HAVE_MADVISE)
check_struct_has_member(tm tm_gmtoff time.h HAVE_TM_GMTOFF) # FIXME: We can fix this, I think
check_struct_has_member(dent d_type dirent.h HAVE_DIRENT_D_TYPE) #FIXME: We can fix this
set(HAVE_LIBC_SYSTEM_PROPERTIES False) # Probably false, right?
check_function_exists(__memcmp16 HAVE__MEMCMP16)
check_symbol_exists(SA_NOCLDWAIT signal.h HAVE_SA_NOCLDWAIT)
check_include_files (sys/socket.h HAVE_SYS_SOCKET_H)
check_function_exists(strlcpy HAVE_STRLCPY)
check_function_exists(funopen HAVE_FUNOPEN)
check_function_exists(prctl HAVE_PRCTL)
check_function_exists(writev HAVE_WRITEV)
check_include_files(stdint.h HAVE_STDINT_H)
check_include_files(stdbool.h HAVE_STDBOOL_H)
check_include_files(sched.h HAVE_SCHED_H)
check_function_exists(pread HAVE_PREAD)
check_struct_has_member(stat st_mtim sys/stat.h HAVE_STAT_ST_MTIM)
set(HAVE_PRINTF_ZD False) # How do we detect this? Custom Try Compile I suppose

#add_definitions(-D_WebOS)

configure_file(${CMAKE_SOURCE_DIR}/webOSConfig.h.in ${CMAKE_BINARY_DIR}/include/webOSConfig.h)
