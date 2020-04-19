#!/usr/bin/env bash
ver="1.2.3"
url=https://ftp.x.org/pub/individual/lib/libSM-$ver.tar.gz
pkg_tarname=libSM-$ver.tar.gz
pkg_dirname=libSM-$ver
commands(){
    ./configure --prefix=$HOME/.local --enable-shared --enable-static --with-libuuid \
    LDFLAGS="-L$HOME/.local/lib" CFLAGS="-I$HOME/.local/include" PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig"
    make && make install
}
