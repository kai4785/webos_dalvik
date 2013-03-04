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

At this point, your build directory should have a com.kai.dalvikvm directory with a 'bin' and 'lib' directory containing stuff.
I don't have a way to build core.jar yet, so I steal it from an Android Source build. On my machine it's:
<android source dir>/out/target/product/generic/dex_bootjars/system/framework/core.jar
Copy this core.jar file into a new directory com.kai.dalvikvm/framework:
$ mkdir com.kai.dalvikvm/framework
$ cp <android source dir>/out/target/product/generic/dex_bootjars/system/framework/core.jar com.kai.dalvikvm/framework

Don't have one of your own? Here, have one of mine:
$ wget -O com.kai.dalvikvm/framework/core.jar http://kai.gnukai.com/framework_4.0.4/core.jar

Now we need the icu data file: (FIXME This should be done in CMake....)
$ mkdir com.kai.dalvikvm/icu
$ cp <source dir>/external/icu4c/stubdata/icudt46l-all.dat com.kai.dalvikvm/icu/icudt46l.dat

$ palm-package com.kai.dalvikvm
$ palm-install com.kai.dalvikvm*.ipk

With the ipk installed, you're almost ready. First, create a dalvik-cache directory, and cd to the applications directory
# mkdir /media/internal/dalvik-cache

Next, get a jar file to test. Here, have one of mine:
# mkdir /media/internal/android-jars/
# wget -O /media/internal/android-jars/CmdLine.jar http://kai.gnukai.com/CmdLine.jar

Now, cd here to shorten some of the copy-paste text, set a few environmental variables, and fire off the command:
# cd /media/cryptofs/apps/usr/palm/applications
# export ANDROID_ROOT=$PWD/com.kai.dalvikvm
# export ANDROID_DATA=/media/internal
# export LD_LIBRARY_PATH=com.kai.dalvikvm/lib
# export BOOTCLASSPATH=$PWD/com.kai.dalvikvm/framework/core.jar:$PWD/com.kai.dalvikvm/framework/ext.jar:$PWD/com.kai.dalvikvm/framework/framework.jar
# ./com.kai.dalvikvm/bin/dalvikvm -classpath /media/internal/android-jars/CmdLine.jar org.apache.HelloWorld

The first time it runs, it will take a moment to create the dex cache files in /media/internal/dalvik-cache, so don't panic if it takes 3-5 seconds before it does anything.

If all went well, you should be staring at the output:
Hello World!


Next steps:
Teach CMake how to create the java libraries for dalvik (ie core.jar)

Run the dalvik test suite in dalvik/tests on the webOS device. Since there's no sun javac for webOS, we'll probably have to pre-compile all the java files and run them through 'dx' before attempting to run them on the TouchPad.

Zygote
http://coltf.blogspot.com/p/android-os-processes-and-zygote.html
I gutted the zygote cpp file in the dalvik tree because it wouldn't easily compile. Looks like that needs fixing now.

Hello World apk
http://androidcodemonkey.blogspot.com/2010/01/hello-world-your-first-android.html

If you try to run the apk right now, it should be encouraging if you see this output:
# ./com.kai.dalvikvm/bin/dalvikvm -classpath /media/internal/android-jars/Hello\ World.apk com.android.test.HelloWorld
Dalvik VM unable to find static main(String[]) in 'com/android/test/HelloWorld'
W/dalvikvm(15383): threadid=1: thread exiting with uncaught exception (group=0x2b5b21f8)
java.lang.NoSuchMethodError: no static method with name='main' signature='([Ljava/lang/String;)V' in class Lcom/android/test/HelloWorld;
    at dalvik.system.NativeStart.main(Native Method)


Dalvik documentation says you should also include policy.jar and services.jar, but I haven't generated or needed them yet.
# export BOOTCLASSPATH=$PWD/com.kai.dalvikvm/framework/core.jar:$PWD/com.kai.dalvikvm/framework/ext.jar:$PWD/com.kai.dalvikvm/framework/framework.jar:$PWD/com.kai.dalvikvm/android.framework/policy.jar:$PWD/com.kai.dalvikvm/framework/services.jar

