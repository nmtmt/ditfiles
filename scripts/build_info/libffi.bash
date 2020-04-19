#!/bin/bash
ver="3.2.1"
url=https://sourceware.org/ftp/libffi/libffi-$ver.tar.gz 
pkg_tarname=libffi-$ver.tar.gz
pkg_dirname=libffi-$ver
commands(){
    ./configure --prefix=$HOME/.local
    make -j4
    make install
}

