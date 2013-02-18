macro(android_add_subdirectory dir)
    if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/CMakeLists.txt)
        file(COPY ${CMAKE_SOURCE_DIR}/android_cmake_files/${dir}.cmake
            DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/${dir}
            )
        file(RENAME ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/${dir}.cmake
            ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/CMakeLists.txt
        )
    endif()
    add_subdirectory(${dir})
endmacro()

macro(concat var)
    list(APPEND ${var} ${ARGN})
endmacro()

macro(link_all_libs)
    unset(LINK_LIBS)
    list(APPEND LINK_LIBS ${LOCAL_SHARED_LIBRARIES} ${LOCAL_STATIC_LIBRARIES} ${LOCAL_WHOLE_STATIC_LIBRARIES})
    if(VERBOSE_CONFIG)
        message(STATUS "   target_link_libraries:(${LOCAL_MODULE}) ${LINK_LIBS}")
    endif()
    if(NOT "${LINK_LIBS}" STREQUAL "")
        target_link_libraries(${LOCAL_MODULE} ${LINK_LIBS})
    endif()
endmacro()
macro(set_flags)
    # Setup C flags if we can find any
    foreach(FLAGS ${LOCAL_CFLAGS})
        set(ALL_CFLAGS "${ALL_CFLAGS} ${FLAGS}")
    endforeach()
    if(VERBOSE_CONFIG)
        message(STATUS "   set_target COMPILE_FLAGS:(${LOCAL_MODULE}) ${ALL_CFLAGS}")
    endif()
    if(NOT "${ALL_CFLAGS}" STREQUAL "")
        set_target_properties(${LOCAL_MODULE} PROPERTIES COMPILE_FLAGS ${ALL_CFLAGS})
    endif()
    # Setup LD flags if we can find any
    foreach(FLAGS ${LOCAL_LDLIBS})
        set(ALL_LDFLAGS "${ALL_LDFLAGS} ${FLAGS}")
    endforeach()
    foreach(FLAGS ${LOCAL_LDFLAGS})
        set(ALL_LDFLAGS "${ALL_LDFLAGS} ${FLAGS}")
    endforeach()
    if(VERBOSE_CONFIG)
        message(STATUS "   set_target LINK_FLAGS:(${LOCAL_MODULE}) ${ALL_LDFLAGS}")
    endif()
    if(NOT "${ALL_LDFLAGS}" STREQUAL "")
        set_target_properties(${LOCAL_MODULE} PROPERTIES LINK_FLAGS ${ALL_LDFLAGS})
    endif()
endmacro()
macro(set_include_directories)
    include_directories(${LOCAL_C_INCLUDES}
        ${core_INCLUDE_DIR}
        ${system_INCLUDE_DIR}
    )
    if(VERBOSE_CONFIG)
        message(STATUS "   include_directories:(${LOCAL_MODULE}) ${LOCAL_C_INCLUDES}")
    endif()
endmacro()

macro(BUILD_STATIC_LIBRARY)
    message(STATUS "Configuring Static Library ${LOCAL_MODULE}")
    project(${LOCAL_MODULE})
    set_include_directories()
    add_library(${LOCAL_MODULE}
        STATIC
        ${LOCAL_SRC_FILES}
    )
    set_flags()
    link_all_libs()
endmacro()

macro(BUILD_SHARED_LIBRARY)
    message(STATUS "Configuring Shared Library ${LOCAL_MODULE}")
    project(${LOCAL_MODULE} ${ARGN})
    cmake_policy(SET CMP0018 OLD) # With out this, assembly source files don't get added to the project....
    set_include_directories()
    add_library(${LOCAL_MODULE}
        SHARED
        ${LOCAL_SRC_FILES}
    )
    set_flags()
    link_all_libs()
    install(TARGETS ${LOCAL_MODULE}
        LIBRARY
        DESTINATION lib
    )
endmacro()

macro(BUILD_EXECUTABLE)
    message(STATUS "Configuring Executable ${LOCAL_MODULE}")
    project(${LOCAL_MODULE})
    set_include_directories()
    add_executable(${LOCAL_MODULE}
        ${LOCAL_SRC_FILES}
    )
    set_flags()
    link_all_libs()
    install(TARGETS ${LOCAL_MODULE}
        RUNTIME
        DESTINATION bin
    )
endmacro()

macro(CLEAR_VARS)
    unset(LOCAL_MODULE)
    unset(LOCAL_C_INCLUDES)
    set(LOCAL_CFLAGS ${TARGET_GLOBAL_CFLAGS})
    unset(LOCAL_SRC_FILES)
    unset(LOCAL_SHARED_LIBRARIES)
    unset(LOCAL_STATIC_LIBRARIES)
    set(LOCAL_LDFLAGS ${TARGET_GLOBAL_LDFLAGS})
endmacro()
