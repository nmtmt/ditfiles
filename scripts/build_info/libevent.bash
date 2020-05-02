#!/usr/bin/env bash
ver="2.1.8"
url=https://github.com/libevent/libevent/releases/download/release-$ver-stable/libevent-$ver-stable.tar.gz
pkg_tarname=libevent-$ver.tar.gz
pkg_dirname=libevent-$ver
commands(){
    ./configure --prefix=$HOME/.local
    make -j4 && make install
}
