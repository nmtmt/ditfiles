#!/bin/bash
ver="1.2.11"
url=https://www.zlib.net/zlib-$ver.tar.gz
pkg_tarname=zlib-$ver.tar.gz
pkg_dirname=zlib-$ver
commands(){
    ./configure --prefix=$HOME/.local
    make -j4 && make install
}
