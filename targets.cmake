set(android_dir android_cmake_files-${GIT_TAG})

macro(android_add_subdirectory dir)
    get_filename_component(base ${dir} NAME)
    execute_process(
        COMMAND ln -sf ${CMAKE_SOURCE_DIR}/${android_dir}/${base}.cmake ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/CMakeLists.txt
    )
    if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/CMakeLists.txt)
        message(FATAL_ERROR "android_add_subdirectory failed! ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/CMakeLists.txt")
    endif()
    add_subdirectory(${dir})
endmacro()
macro(android_include path)
    get_filename_component(file ${path} NAME)
    execute_process(
        COMMAND ln -sf ${CMAKE_SOURCE_DIR}/${android_dir}/${file} ${CMAKE_CURRENT_SOURCE_DIR}/${path}
    )
    if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${path})
        message(FATAL_ERROR "android_include failed to copy!  ${CMAKE_CURRENT_SOURCE_DIR}/${path}")
    endif()
    include(${file})
endmacro()

macro(concat var)
    list(APPEND ${var} ${ARGN})
endmacro()

macro(copy_headers headers_to headers)
    foreach(header ${headers})
        if(VERBOSE_CONFIG)
            message("copy_headers: ${CMAKE_CURRENT_SOURCE_DIR}/${header} -> ${CMAKE_BINARY_DIR}/include/${headers_to}/")
        endif()
        file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/${header}
            DESTINATION ${CMAKE_BINARY_DIR}/include/${headers_to}/
        )
    endforeach()
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
    if(NOT "${LOCAL_COPY_HEADERS_TO}" STREQUAL "")
        copy_headers(${LOCAL_COPY_HEADERS_TO} "${LOCAL_COPY_HEADERS}")
    endif()
    project(${LOCAL_MODULE} ${ARGN})
    # Apparently 2.8.0 doesn't have this, but 2.8.6 does.
    #cmake_policy(SET CMP0018 OLD) # With out this, assembly source files don't get added to the project....
    set_include_directories()
    add_library(${LOCAL_MODULE}
        SHARED
        ${LOCAL_SRC_FILES}
    )
    #concat(LOCAL_CFLAGS -fPIC)
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

macro(BUILD_HOST_JAVA_LIBRARY)
    message(STATUS "Configuring Host Java Library ${LOCAL_MODULE}")
    set(${LOCAL_MODULE}_jar ${CMAKE_CURRENT_BINARY_DIR}/${LOCAL_MODULE}.jar CACHE STRING "" FORCE)
    add_custom_command(OUTPUT ${${LOCAL_MODULE}_jar}
        COMMAND javac -s . -d . ${LOCAL_JAVACFLAGS} ${LOCAL_SRC_FILES}
        COMMAND find . -name *.class | xargs jar cvfm ${LOCAL_MODULE}.jar ${LOCAL_JAR_MANIFEST}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )
    add_custom_target(${LOCAL_MODULE}
        SOURCES ${LOCAL_SRC_FILES}
        DEPENDS ${${LOCAL_MODULE}_jar}
        )
    install(FILES ${${LOCAL_MODULE}_jar}
        DESTINATION framework
        )
endmacro()

macro(BUILD_JAVA_LIBRARY)
    message(STATUS "Configuring Java Library ${LOCAL_MODULE}")
    message(STATUS "LOCAL_SRC_FILES: ${LOCAL_SRC_FILES}")
    set(${LOCAL_MODULE}_jar ${CMAKE_CURRENT_BINARY_DIR}/${LOCAL_MODULE}.jar CACHE STRING "" FORCE)
    add_custom_command(OUTPUT ${${LOCAL_MODULE}_jar}
        COMMAND javac -s . -d . ${LOCAL_JAVACFLAGS} ${LOCAL_SRC_FILES}
        COMMAND find . -name *.class | xargs java -jar ${dx_jar} --dex ${LOCAL_DX_FLAGS} --output=${LOCAL_MODULE}.jar ${LOCAL_JAR_MANIFEST}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )
    add_custom_target(${LOCAL_MODULE}
        SOURCES ${LOCAL_SRC_FILES}
        DEPENDS ${dx_jar}
        DEPENDS ${${LOCAL_MODULE}_jar}
        )
    add_dependencies(${LOCAL_MODULE} dx)
    install(FILES ${${LOCAL_MODULE}_jar}
        DESTINATION framework
        )
endmacro()

macro(CLEAR_VARS)
    unset(LOCAL_MODULE)
    #GCC normally runs from the source dir in the Android project, but not so
    #with cmake, so we'll add the source dir to the LOCAL_C_INCLUDES every time
    set(LOCAL_C_INCLUDES
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_BINARY_DIR}/include
        )
    #set(LOCAL_CFLAGS ${TARGET_GLOBAL_CFLAGS})
    set(LOCAL_CFLAGS)
    unset(LOCAL_SRC_FILES)
    unset(LOCAL_SHARED_LIBRARIES)
    unset(LOCAL_STATIC_LIBRARIES)
    set(LOCAL_LDFLAGS ${TARGET_GLOBAL_LDFLAGS})
    unset(LOCAL_COPY_HEADERS_TO)
    unset(LOCAL_COPY_HEADERS)
endmacro()
