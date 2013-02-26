webos_dalvik
============

Yet another attempt to run the Android Dalvik VM on WebOS 3.0.5 using the offical WebOS PDK.

I am targeting a pretty vanilla Ubuntu 10 install, mostly because I will be
stealing things out of the android source tree (like core.jar) eventually, and
I want to be "officially" building Android correctly.

I'm also only targeting the webOS 3.0.5 PDK, rather than Open webOS for now,
because I think it will be easer to go forward to Open webOS, than backwards
to 3.0.5.

Build with cmake like you would any other project:
$ mkdir <source dir> && cd <source dir>
$ git clone --recursive https://github.com/kai4785/webos_dalvik.git
$ mkdir <build dir> && cd <build dir>
$ cmake -DCMAKE_BUILD_TYPE=Debug <source dir>/webos_dalvik
$ make -j`lscpu | awk '/^CPU\(s/{print $2}'`
$ make DESTDIR=. install
$ palm-package com.kai.dalvikvm
$ palm-install com.kai.dalvikvm*.ipk

With the ipk installed, you can drop to a shell on the device and run it like
this:

# cd /media/cryptofs/apps/usr/palm/applications
# ANDROID_ROOT=$PWD/com.kai.dalvikvm ANDROID_DATA=/media/internal LD_LIBRARY_PATH=com.kai.dalvikvm/lib ./com.kai.dalvikvm/bin/dalvikvm -Xbootclasspath:$PWD/com .kai.dalvikvm/framework/core.jar -classpath ./com.kai.dalvikvm/CmdLine.jar org.apache.HelloWorld

I haven't ironed out the kinks with the icudt46l.dat file to work out of the box yet, and it may complain that /media/internal/dalvik-cache isn't created yet. Hopefully I'll have these issues fixed (or better documented) soon.
