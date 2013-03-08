#include <stdlib.h>
#include <jni.h>
#include "utils/Errors.h"
#include "utils/Vector.h"
#include "utils/threads.h"
namespace webos {
    class webOSRuntime
    {
        public:
            webOSRuntime();
            virtual ~webOSRuntime();

            enum StartMode {
                Zygote,
                SystemServer,
                Application,
                Tool,
            };

            /**
             * Register a set of methods in the specified class.
             */
            static int registerNativeMethods(JNIEnv* env,
                    const char* className, const JNINativeMethod* gMethods, int numMethods);

            /**
             * Call a class's static main method with the given arguments,
             */
            android::status_t callMain(const char* className, jclass clazz, int argc,
                    const char* const argv[]);

            /**
             * Find a class, with the input either of the form
             * "package/class" or "package.class".
             */
            static jclass findClass(JNIEnv* env, const char* className);

            int addVmArguments(int argc, const char* const argv[]);

            void start(const char *classname, const char* options);

            static webOSRuntime* getRuntime();

            /**
             * This gets called after the VM has been created, but before we
             * run any code. Override it to make any FindClass calls that need
             * to use CLASSPATH.
             */
            virtual void onVmCreated(JNIEnv* env);

            /**
             * This gets called after the JavaVM has initialized.  Override it
             * with the system's native entry point.
             */
            virtual void onStarted() = 0;

            /**
             * This gets called after the JavaVM has initialized after a Zygote
             * fork. Override it to initialize threads, etc. Upon return, the
             * correct static main will be invoked.
             */
            virtual void onZygoteInit() {};


            /**
             * Called when the Java application exits.  The default
             * implementation calls exit(code).
             */
            virtual void onExit(int code);

            /** create a new thread that is visible from Java */
            static android_thread_id_t createJavaThread(const char* name, void (*start)(void *),
                    void* arg);

            /** return a pointer to the VM running in this process */
            static JavaVM* getJavaVM() { return mJavaVM; }

            /** return a pointer to the JNIEnv pointer for this thread */
            static JNIEnv* getJNIEnv();

            /** return a new string corresponding to 'className' with all '.'s replaced by '/'s. */
            static char* toSlashClassName(const char* className);

        private:
            static int startReg(JNIEnv* env);
            void parseExtraOpts(char* extraOptsBuf);
            int startVm(JavaVM** pJavaVM, JNIEnv** pEnv);

            android::Vector<JavaVMOption> mOptions;

            /* JNI JavaVM pointer */
            static JavaVM* mJavaVM;

            /*
             * Thread creation helpers.
             */
            static int javaCreateThreadEtc(
                    android_thread_func_t entryFunction,
                    void* userData,
                    const char* threadName,
                    int32_t threadPriority,
                    size_t threadStackSize,
                    android_thread_id_t* threadId);
            static int javaThreadShell(void* args);
    };
};
