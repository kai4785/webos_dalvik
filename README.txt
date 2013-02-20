webos_dalvik
============

Yet another attempt to run the Android Dalvik VM on WebOS 3.0.5 using the offical WebOS PDK.

Build with cmake like you would any other project:
]$ mkdir <source dir> && cd <source dir>
]$ git clone https://github.com/kai4785/webos_dalvik.git
]$ mkdir <build dir> && cd <build dir>
]$ cmake -DCMAKE_BUILD_TYPE=Debug <source dir>/webos_dalvik
]$ make -j`lscpu | awk '/^CPU\(s/{print $2}'`

We still have unresolved symbols by the end, but lots and lots of byte code is actually generated. Hurray!
