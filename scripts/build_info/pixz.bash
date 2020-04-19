#!/usr/bin/env bash
ver="1.0.6"
url=https://github.com/vasi/pixz/releases/download/v$ver/pixz-$ver.tar.gz
pkg_tarname=pixz-$ver.tar.gz
pkg_dirname=pixz-$ver
commands(){
    ./configure --prefix=$HOME/.local CFLAGS="-I$HOME/.local/include" \
    LDFLAGS="-L$HOME/.local/lib -Wl,--rpath=$HOME/.local/lib" \
    PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig; 
    make -j4 PREFIX=$HOME/.local && make install PREFIX=$HOME/.local
}
