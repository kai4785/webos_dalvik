webos_dalvik
============

Yet another attempt to run the Android Dalvik VM on WebOS 3.0.5 using the offical WebOS PDK.

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
# LD_LIBRARY_PATH=./com.kai.dalvikvm/lib ./com.kai.dalvikvm/bin/dalvikvm

It currently executes with the following error:
./com.kai.dalvikvm/bin/dalvikvm: error while loading shared libraries: ./com.kai.dalvikvm/lib/libcrypto.so: unexpected reloc type 0x03

If you run it with LD_DEBUG=all (you'll have to wait a bit), you end up seeing these lines:
     14262: symbol=OPENSSL_armcap_P;  lookup in file=./com.kai.dalvikvm/lib/liblog.so [0]
     14262:    symbol=OPENSSL_armcap_P;  lookup in file=./com.kai.dalvikvm/lib/libcrypto.so [0]
     14262:   binding file ./com.kai.dalvikvm/lib/libcrypto.so [0] to ./com.kai.dalvikvm/lib/libcrypto.so [0]: normal symbol `OPENSSL_armcap_P'

I can't tell if the issue is with the symbol OPENSSL_armcap_P, or with whatever it is going to try to do next. Looking online, it seems like it's a symbol with static linkage instead of dynamic.



I am targeting a pretty vanilla Ubuntu 10 install, mostly because I will be
stealing things out of the android source tree (like core.jar) eventually, and
I want to be "officially" building Android correctly.

I'm also only targeting the webOS 3.0.5 PDK, rather than Open webOS for now,
because I think it will be easer to go forward to Open webOS, than backwards
to 3.0.5.
