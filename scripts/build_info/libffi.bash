#!/bin/bash
ver="3.3"
url=https://sourceware.org/ftp/libffi/libffi-$ver.tar.gz 
pkg_tarname=libffi-$ver.tar.gz
pkg_dirname=libffi-$ver
commands(){
    case $OSTYPE in
        darwin*)
            ./configure --prefix=$HOME/.local --libdir=$HOME/.local/lib --disable-multi-os-directory LDFLAGS="-L/usr/local/opt/ice/lib";;
        *)
            ./configure --prefix=$HOME/.local --libdir=$HOME/.local/lib --disable-multi-os-directory;;
    esac
    make -j4
    make install
}

