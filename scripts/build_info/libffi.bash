#!/bin/bash
ver="3.3"
url=https://sourceware.org/ftp/libffi/libffi-$ver.tar.gz 
pkg_tarname=libffi-$ver.tar.gz
pkg_dirname=libffi-$ver
commands(){
    ./configure --prefix=$HOME/.local --libdir=$HOME/.local/lib --disable-multi-os-directory
    make -j4
    make install
}

