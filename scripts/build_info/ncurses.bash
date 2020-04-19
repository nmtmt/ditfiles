#!/usr/bin/env bash
ver="6.1"
url=https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$ver.tar.gz
pkg_tarname=ncurses-$ver.tar.gz
pkg_dirname=ncurses-$ver
commands(){
    ./configure --prefix=$HOME/.local/ncurses-$ver --with-shared --with-pkg-config-libdir=$HOME/.local/ncurses-$ver/lib/pkgconfig --enable-pc-files
    make -j4 && make install
}
