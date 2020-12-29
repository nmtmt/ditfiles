#!/usr/bin/env bash
ver="1.07"
url=https://ftp.gnu.org/gnu/bc/bc-${ver}.tar.gz
pkg_tarname=bc-$ver.tar.gz
pkg_dirname=bc-$ver
commands(){
    ./configure --prefix=$HOME/.local
    make -j4 && make install
}
