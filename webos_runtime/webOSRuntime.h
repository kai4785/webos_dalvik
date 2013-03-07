#define LOGE(...) {do{} while(0);}
namespace webos {
    class webOSRuntime
    {
        public:
            webOSRuntime();
            virtual ~webOSRuntime();
            /** return a new string corresponding to 'className' with all '.'s replaced by '/'s. */
            static char* toSlashClassName(const char* className);
    };
};
