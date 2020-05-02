#!/usr/bin/env bash
ver="2.8"
url=https://github.com/tmux/tmux/releases/download/$ver/tmux-$ver.tar.gz
pkg_tarname=tmux-$ver.tar.gz
pkg_dirname=tmux-$ver
commands(){
    ./configure --prefix=$HOME/.local --enable-shared --enable-static
    make -j4 && make install
}
