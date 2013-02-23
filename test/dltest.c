#include <stdio.h>
#include <dlfcn.h>

int main(int argc, char **argv, char** envp)
{
    int i;
    char** env;
    int err = 0;
    printf("%s:\n", argv[0]);
    for(i = 1; i < argc; ++i)
    {
        printf("[%d]  %s\n", i, argv[i]);    
    }
    for (env = envp; *env != 0; env++)
    {
        char* thisEnv = *env;
        printf("%s\n", thisEnv);    
    }
    for(i = 1; i < argc; ++i)
    {
        printf("dlopen(%s)\n", argv[i]);
        void *handle = dlopen(argv[i], RTLD_NOW | RTLD_GLOBAL);
        printf("dlerror: %s\n", dlerror());
        if(handle)
            dlclose(handle);
    }
    return err;
}
