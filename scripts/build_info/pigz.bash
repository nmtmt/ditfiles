#!/usr/bin/env bash
ver="2.4"
url=https://zlib.net/pigz/pigz-$ver.tar.gz
pkg_tarname=pigz-$ver.tar.gz
pkg_dirname=pigz-$ver
commands(){
    make CFLAGS="-I$HOME/.local/include" LDFLAGS="-L$HOME/.local/lib"
    cp pigz unpigz $HOME/.local/bin
}
