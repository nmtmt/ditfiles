#!/usr/bin/env bash
ver="1.0.8"
url=https://sourceware.org/pub/bzip2/bzip2-$ver.tar.gz
pkg_tarname=bzip2-$ver.tar.gz
pkg_dirname=bzip2-$ver
commands(){
    make -j4 PREFIX=$HOME/.local CFLAGS="-fPIC" && make install PREFIX=$HOME/.local
    echo "Building shared library..."
    make clean && make -f Makefile-libbz2_so CFLAGS="-fPIC"
    cp *.so* $HOME/.local/lib/
}
