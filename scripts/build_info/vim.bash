#!/usr/bin/env bash
ver="8.2"
url=https://ftp.vim.org/pub/vim/unix/vim-$ver.tar.bz2
pkg_tarname=vim-$ver.tar.bz2
pkg_dirname=vim-$ver
commands(){
    lua_prefix=(`find $HOME/.local/lua-?.?.? -maxdepth 0 -type d | sort -r`)
    lua_prefix=${lua_prefix[0]}
    python_include=(`find $HOME/.local/include/python3.? -maxdepth 0 -type d | sort -r`)
    python_include=${python_include[0]}
    ncurses_prefix=(`find $HOME/.local/ncurses-?.? -maxdepth 0 -type d | sort -r`)
    ncurses_prefix=${ncurses_prefix[0]}
    echo $lua_prefix 
    echo $python_include 
    echo $ncurses_prefix 
    ./configure \
        --prefix=$HOME/.local \
        --with-features=huge \
        --with-local-dir=$HOME/.local \
        --enable-multibyte \
        --enable-gui=yes \
        --enable-pythoninterp=auto \
        --enable-python3interp=yes \
        --enable-luainterp=yes \
        --enable-rubyinterp=yes\
        --enable-perlinterp=auto \
        --with-lua-prefix=$lua_prefix \
        --enable-cscope \
        --enable-fontset \
        --enable-fail-if-missing \
        CFLAGS="-I$HOME/.local/include -I$ncurses_prefix/include -I$python_include " \
        LDFLAGS="-L$HOME/.local/lib -L$ncurses_prefix/lib" 
        make -j4 && make install; 
}
