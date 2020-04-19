#!/bin/bash
ver="1.1.1"
url=https://www.openssl.org/source/old/$ver/openssl-${ver}e.tar.gz
pkg_tarname=openssl-${ver}e.tar.gz
pkg_dirname=openssl-${ver}e
commands(){
    ./config shared --prefix=$HOME/.local/openssl --openssldir=$HOME/.local/openssl
    make -j4
    make install
}
