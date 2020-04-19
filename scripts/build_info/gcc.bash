#!/usr/bin/env 
ver="9.3.0"
url=http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-$ver/gcc-$ver.tar.gz
pkg_tarname=gcc-$ver.tar.gz
pkg_dirname=gcc-$ver
commands(){
    ./contrib/download_prerequisites
    if [ ! -e ./build ]; then
        rm -rf ./build
    fi
    mkdir build && cd build
    ../configure --enable-shared --enable-languages=c,c++ --prefix=$HOME/.local --disable-bootstrap --disable-multilib
    make -j4
    make install
}
