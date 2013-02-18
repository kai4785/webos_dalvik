cmake_minimum_required(VERSION 2.8)
android_add_subdirectory(safe-iop)
android_add_subdirectory(fdlibm)
# add_subdirectory(expat)
# 
# # WebOS 3.0 needs zlib
# set(zlib_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/zlib CACHE STRING "" FORCE)
# set(zconf_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/zlib CACHE STRING "" FORCE)
# add_subdirectory(zlib)
# 
# add_subdirectory(icu4c)
# 
# WebOS 3.0 does not have some of the symbols required, namely:
# SSL_authentication_method
# SSL_get_certificate_chain
# SSL_SESSION_get_version
# SSL_set_cipher_lists
# SSL_set_session_creation_enabled
# SSL_use_certificate_chain
# android_add_subdirectory(openssl)
