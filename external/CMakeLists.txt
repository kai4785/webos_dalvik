cmake_minimum_required(VERSION 2.8)
android_add_subdirectory(safe-iop)
android_add_subdirectory(fdlibm)
set(expat_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/expat CACHE STRING "" FORCE)
android_add_subdirectory(expat)

# WebOS 3.0.5 has incompatible zlib built-in
set(zlib_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/zlib CACHE STRING "" FORCE)
set(zconf_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/zlib CACHE STRING "" FORCE)
android_add_subdirectory(zlib)

set(icu4c_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/icu4c CACHE STRING "" FORCE)
android_add_subdirectory(icu4c)

# WebOS 3.0.5 does not have some of the symbols required, namely:
# SSL_authentication_method
# SSL_get_certificate_chain
# SSL_SESSION_get_version
# SSL_set_cipher_lists
# SSL_set_session_creation_enabled
# SSL_use_certificate_chain
set(openssl_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/openssl CACHE STRING "" FORCE)
android_add_subdirectory(openssl)
