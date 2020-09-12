#!/usr/bin/env bash
ver="0.2.16"
url=https://github.com/equalsraf/neovim-qt/archive/v$ver.tar.gz
pkg_tarname=neovim-qt-$ver.tar.gz
pkg_dirname=neovim-qt-$ver
commands(){
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local/ -DCMAKE_BUILD_TYPE=Release ..
    make -j8 && make install
}
