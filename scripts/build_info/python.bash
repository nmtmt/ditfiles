#!/usr/bin/env bash
ver="3.8.3"
url=https://www.python.org/ftp/python/$ver/Python-$ver.tgz
pkg_tarname=Python-$ver.tgz
pkg_dirname=Python-$ver
commands(){
    case $OSTYPE in
        darwin*)
            ncurses_prefix=/usr/local/opt/ncurses
            openssl_prefix=(`find /usr/local/opt/openssl@?.? -maxdepth 0 -type d | sort -r`)
            openssl_prefix=${openssl_prefix[0]}
            tk_prefix=/usr/local/opt/tcl-tk
            libffi_prefix=/usr/local/opt/libffi

                #LDFLAGS="-L$HOME/.local/lib -L$openssl_prefix/lib -Wl,-rpath,$HOME/.local/lib -Wl,-rpath,$openssl_prefix/lib -L$ncurses_prefix/lib -Wl,-rpath,$ncurses_prefix/lib -L$tk_prefix/lib -Wl,-rpath,$tk_prefix/lib -L$libffi_prefix/lib -Wl,-rpath,$libffi_prefix/lib" \
                #CPPFLAGS="-fPIC -I$HOME/.local/include -I$openssl_prefix/include -I$openssl/include/openssl -I$ncurses_prefix/include -I$tk_prefix/include -I$libffi_prefix/include";;

            ./configure --prefix=$HOME/.local --enable-shared --enable-ipv6 --with-openssl=$HOME/.local/openssl \
                LDFLAGS="-L$HOME/.local/lib -Wl,-rpath,$HOME/.local/lib -L$openssl_prefix/lib -Wl,-rpath,$HOME/.local/lib -Wl,-rpath,$openssl_prefix/lib -L$ncurses_prefix/lib -Wl,-rpath,$ncurses_prefix/lib -L$tk_prefix/lib -Wl,-rpath,$tk_prefix/lib" \
                CFLAGS="-fPIC -I$HOME/.local/include -I$openssl_prefix/include -I$openssl_prefix/include/openssl -I$ncurses_prefix/include -I$ncurses_prefix/include/ncurses" \
                CPPFLAGS="-fPIC -I$HOME/.local/include -I$openssl_prefix/include -I$openssl/include/openssl -I$ncurses_prefix/include -I$tk_prefix/include";;
        *)
            ncurses_prefix=(`find $HOME/.local/ncurses-?.? -maxdepth 0 -type d | sort -r`)
            ncurses_prefix=${ncurses_prefix[0]}
            ./configure --prefix=$HOME/.local --enable-shared --enable-ipv6 --with-openssl=$HOME/.local/openssl \
                LDFLAGS="-L$HOME/.local/lib -L$HOME/.local/openssl/lib -Wl,--rpath=$HOME/.local/lib -Wl,--rpath=$HOME/.local/openssl/lib -L$ncurses_prefix/lib -Wl,--rpath=$ncurses_prefix/lib" \
                CFLAGS="-fPIC -I$HOME/.local/include -I$HOME/.local/openssl/include -I$HOME/.local/openssl/include/openssl -I$ncurses_prefix/include -I$ncurses_prefix/include/ncurses" \
                CPPFLAGS="-fPIC -I$HOME/.local/include -I$HOME/.local/openssl/include -I$HOME/.local/openssl/include/openssl -I$ncurses_prefix/include -I$ncurses_prefix/include/ncurses";;
    esac

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
