#!/usr/bin/env bash
ver="3.4.2"
url=https://www.libarchive.org/downloads/libarchive-$ver.tar.gz
pkg_tarname=libarchive-$ver.tar.gz
pkg_dirname=libarchive-$ver
commands(){
    ./configure --prefix=$HOME/.local --enable-shared --enable-static CFLAGS="-I$HOME/.local/include" LDFLAGS="-L$HOME/.local/lib"
    make -j4 PREFIX=$HOME/.local INCLUDES=-I$HOME/.local/include && make install PREFIX=$HOME/.local
}
