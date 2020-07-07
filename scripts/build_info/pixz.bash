#!/usr/bin/env bash
ver="1.0.6"
url=https://github.com/vasi/pixz/releases/download/v$ver/pixz-$ver.tar.gz
pkg_tarname=pixz-$ver.tar.gz
pkg_dirname=pixz-$ver
commands(){
    case $OSTYPE in
        darwin*)
            ./configure --prefix=$HOME/.local CFLAGS="-I$HOME/.local/include" \
            LDFLAGS="-L$HOME/.local/lib -Wl,-rpath,$HOME/.local/lib" \
            PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig
            sed -i .bak -e 's/FILE \*gInFile/static FILE *gInFile/g' src/common.c
            sed -i .bak -e 's/FILE \*gInFile/static FILE *gInFile/g' src/pixz.h
            sed -i .bak -e 's/lzma_stream gStream/static lzma_stream gStream/g' src/common.c
            sed -i .bak -e 's/lzma_stream gStream/static lzma_stream gStream/g' src/pixz.h
            ;;
        *)
            ./configure --prefix=$HOME/.local CFLAGS="-I$HOME/.local/include" \
            LDFLAGS="-L$HOME/.local/lib -Wl,--rpath=$HOME/.local/lib" \
            PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig ;;
    esac
    make -j4 PREFIX=$HOME/.local && make install PREFIX=$HOME/.local
}
