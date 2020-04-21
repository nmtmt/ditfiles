#!/usr/bin/env 
ver="9.3.0"
url=http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-$ver/gcc-$ver.tar.gz
pkg_tarname=gcc-$ver.tar.gz
pkg_dirname=gcc-$ver
commands(){
    case ${OSTYPE} in
        darwin*)
            sed -i .bak -e 's/ftp:\/\//https:\/\//' ./contrib/download_prerequisites
            ;;
        linux*)
            sed -i -e 's/ftp:\/\//https:\/\//' ./contrib/download_prerequisites
            ;;
        *) echo "error!"; exit 1 ;;
    esac

    while true;
    do
        ./contrib/download_prerequisites --force
        if [ $? = 0 ]; then
            break
        fi
    done
    if [ -d ./build ]; then
        rm -rf ./build
    fi
    mkdir build && cd build
    ../configure --enable-shared --enable-languages=c,c++ --prefix=$HOME/.local --disable-bootstrap --disable-multilib
    make -j4
    make install
}
