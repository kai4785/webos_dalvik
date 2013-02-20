webos_dalvik
============

Yet another attempt to run the Android Dalvik VM on WebOS 3.0.5 using the offical WebOS PDK.

Build with cmake like you would any other project:
]$ mkdir <source dir> && cd <source dir>
]$ git clone --recursive https://github.com/kai4785/webos_dalvik.git
]$ mkdir <build dir> && cd <build dir>
]$ cmake -DCMAKE_BUILD_TYPE=Debug <source dir>/webos_dalvik
]$ make -j`lscpu | awk '/^CPU\(s/{print $2}'`

We still have unresolved symbols by the end, but lots and lots of byte code is actually generated. Hurray!

I am targeting a pretty vanilla Ubuntu 10 install, mostly because I will be
stealing things out of the android source tree (like core.jar) eventually, and
I want to be "officially" building Android correctly.

I'm also only targeting the webOS 3.0.5 PDK, rather than Open webOS for now,
because I think it will be easer to go forward to Open webOS, than backwards
to 3.0.5.
