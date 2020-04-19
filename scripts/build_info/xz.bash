#!/usr/bin/env bash
ver="5.2.5"
url=https://sourceforge.net/projects/lzmautils/files/xz-$ver.tar.gz
pkg_tarname=xz-$ver.tar.gz
pkg_dirname=xz-$ver
commands(){
    ./configure --prefix=$HOME/.local --enable-shared --enable-static
    make -j4 && make install
}
