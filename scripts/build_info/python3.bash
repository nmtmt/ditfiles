#!/usr/bin/env bash
case $OSTYPE in
    darwin*)
        # seems like multiprocessing of python3.8 has a bug and cannot run dataloader of pytorch
        ver="3.7.9";;
    *)
        ver="3.8.7";;
esac
url=https://www.python.org/ftp/python/$ver/Python-$ver.tgz
pkg_tarname=Python-$ver.tgz
pkg_dirname=Python-$ver
commands(){
    case $OSTYPE in
        darwin*)
            ncurses_prefix=/usr/local/opt/ncurses
            openssl_prefix=(`find /usr/local/opt/openssl@?.? -maxdepth 0 -type d -o -type l | sort -r`)
            openssl_prefix=${openssl_prefix[0]}
            tk_prefix=/usr/local/opt/tcl-tk

            #./configure --prefix=$HOME/.local --enable-shared --enable-ipv6 --with-openssl=$HOME/.local/openssl \
            ./configure --prefix=$HOME/.local --enable-shared --enable-ipv6 --with-openssl=$openssl_prefix \
                LDFLAGS="-L$HOME/.local/lib -Wl,-rpath,$HOME/.local/lib -L$openssl_prefix/lib -Wl,-rpath,$HOME/.local/lib -lffi -Wl,-rpath,$openssl_prefix/lib -L$ncurses_prefix/lib -Wl,-rpath,$ncurses_prefix/lib -L$tk_prefix/lib -Wl,-rpath,$tk_prefix/lib" \
                CFLAGS="-fPIC -I$HOME/.local/include -I$openssl_prefix/include -I$openssl_prefix/include/openssl -I$ncurses_prefix/include -I$ncurses_prefix/include/ncurses" \
                CPPFLAGS="-fPIC -I$HOME/.local/include -I$openssl_prefix/include -I$openssl/include/openssl -I$ncurses_prefix/include -I$tk_prefix/include" \
                CC="clang" CXX="clang++";;
        *)
            ncurses_prefix=(`find $HOME/.local/ncurses-?.? -maxdepth 0 -type d | sort -r`)
            ncurses_prefix=${ncurses_prefix[0]}
            ./configure --prefix=$HOME/.local --enable-shared --enable-ipv6 --with-openssl=$HOME/.local/openssl \
                LDFLAGS="-L$HOME/.local/lib -L$HOME/.local/openssl/lib -Wl,--rpath=$HOME/.local/lib -Wl,--rpath=$HOME/.local/openssl/lib -L$ncurses_prefix/lib -Wl,--rpath=$ncurses_prefix/lib" \
                CFLAGS="-fPIC -I$HOME/.local/include -I$HOME/.local/openssl/include -I$HOME/.local/openssl/include/openssl -I$ncurses_prefix/include -I$ncurses_prefix/include/ncurses" \
                CPPFLAGS="-fPIC -I$HOME/.local/include -I$HOME/.local/openssl/include -I$HOME/.local/openssl/include/openssl -I$ncurses_prefix/include -I$ncurses_prefix/include/ncurses";;
    esac

    make -j4
    while true; do
        read -p "Is the result of make right?" ys
        case $ys in
            [Yy]*)
                echo "installing python..."
                make install
                echo "Done!"
                break
                ;;
            [Nn]*)
                echo abord
                exit 1
                ;;
            *)
                echo "Invalid input"
        esac
    done
}
