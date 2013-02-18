project(dalvikvm)
write_file(${CMAKE_CURRENT_BINARY_DIR}/dalvikvm.c "#include <stdio.h>
int main(int argc, char **argv, char** envp)
{
    char** env;
    for (env = envp; *env != 0; env++)
    {
        char* thisEnv = *env;
        printf(\"%s\\n\", thisEnv);    
    }
}"
)

add_executable(${PROJECT_NAME}
    ${CMAKE_CURRENT_BINARY_DIR}/dalvikvm.c
    )
install(TARGETS ${PROJECT_NAME}
    DESTINATION .
    )
