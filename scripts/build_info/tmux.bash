#!/usr/bin/env bash
ver="3.1"
url=https://github.com/tmux/tmux/releases/download/$ver/tmux-$ver.tar.gz
pkg_tarname=tmux-$ver.tar.gz
pkg_dirname=tmux-$ver
commands(){
    ncurses=$(find $HOME/.local -maxdepth 1 -name "ncurses-*" -type d)
    ./configure --prefix=$HOME/.local --enable-shared --enable-static CFLAGS="-I$ncurses/include/ncurses -I$ncurses/include" LDFLAGS="-L$ncurses/lib"
    make -j4 && make install
}
