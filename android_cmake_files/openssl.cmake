set(openssl_INCLUDED_DIR ${CURRENT_CMAKE_SOURCE_DIR} CACHE STRING "" FORCE)
android_include(Crypto.cmake)
android_include(Ssl.cmake)
android_include(Apps.cmake)
