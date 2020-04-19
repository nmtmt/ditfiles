#!/usr/bin/env bash
major_ver="1.1"
ver="1.1.13"
url=https://launchpad.net/pbzip2/$major_ver/$ver/+download/pbzip2-$ver.tar.gz
pkg_tarname=pbzip2-$ver.tar.gz
pkg_dirname=pbzip2-$ver
commands(){
    make -j4 PREFIX=$HOME/.local CXXFLAGS="-I$HOME/.local/include" LDFLAGS="-L$HOME/.local/lib"
    make install PREFIX=$HOME/.local
}
