#!/usr/bin/env bash
ver="3.8.2"
url=https://www.python.org/ftp/python/$ver/Python-$ver.tgz
pkg_tarname=Python-$ver.tgz
pkg_dirname=Python-$ver
commands(){
    ncurses_prefix=(`find $HOME/.local/ncurses-?.? -maxdepth 0 -type d | sort -r`)
    ncurses_prefix=${ncurses_prefix[0]}
    ./configure --prefix=$HOME/.local --enable-shared --enable-ipv6 --with-openssl=$HOME/.local/openssl \
        LDFLAGS="-L$HOME/.local/lib -L$HOME/.local/openssl/lib -Wl,--rpath=$HOME/.local/lib -Wl,--rpath=$HOME/.local/openssl/lib -L$ncurses_prefix/lib -Wl,--rpath=$ncurses_prefix/lib" \
        CFLAGS="-fPIC -I$HOME/.local/include -I$HOME/.local/openssl/include -I$HOME/.local/openssl/include/openssl -I$ncurses_prefix/include -I$ncurses_prefix/include/ncurses" \
        CPPFLAGS="-fPIC -I$HOME/.local/include -I$HOME/.local/openssl/include -I$HOME/.local/openssl/include/openssl -I$ncurses_prefix/include -I$ncurses_prefix/include/ncurses"
    make -j4
    read -p "Is the result of make right?" ys
    case $ys in
        [Yy]*)
            echo "installing python..."
            make install
            echo "Done!"
            ;;
        [Nn]*) 
            echo abord
            exit 1
            ;;
        *) 
            echo "Invalid input. abord"
            exit 1
    esac
}
