#!/bin/bash

src_dir=$HOME/.local/src

libffi_ver="3.2.1"
openssl_ver="1_1_0"
python_ver="3.8.2"

cur_dir=$(pwd)

sudo apt install tk tk-dev python-tk python3-tk libsqlite3-dev libgdbm-dev libreadline-dev libbz2-dev libdb5.3-dev 

if [ ! -e $src_dir ]; then
    mkdir -p $src_dir
fi

# install libffi for _ctypes
if [ ! -e $HOME/.local/lib/libffi-$libffi_ver ]; then
    cd $src_dir
    if [ ! -e $src_dir/libffi-$libffi_ver ]; then
        if [ ! -e $src_dir/libffi-$libffi_ver/libffi-$libffi_ver.tar.gz ]; then
            wget https://sourceware.org/ftp/libffi/libffi-$libffi_ver.tar.gz 
            tar zxvf libffi-$libffi_ver.tar.gz
        fi
    fi
    cd libffi-3.2.1
    ./configure --prefix=$HOME/.local
    make -j4
    make install
    if [ ! -e $HOME/.local/include ];then
        mkdir -p $HOME/.local/include
    fi
fi
ln -s $HOME/.local/lib/libffi-$libffi_ver/include/* $HOME/.local/include/

# install openssl (1.0.2 or 1.1 are compatible)
cd $src_dir
if [ ! -e ./openssl ]; then
    git clone https://github.com/openssl/openssl.git
fi
if [ ! -e $HOME/.local/openssl ]; then
    cd openssl*
    git checkout OpenSSL_$openssl_ver-stable
    ./config shared --prefix=$HOME/.local --openssldir=$HOME/.local/openssl
    make -j4
    make install
fi

cd $src_dir

if [ ! -e $src_dir/Python-$python_ver.tgz ];then
    wget https://www.python.org/ftp/python/$python_ver/Python-$python_ver.tgz -O $src_dir/Python-$python_ver.tgz
fi
if [ ! -e $src_dir/Python-$python_ver ];then
    tar zxf Python-$python_ver.tgz
fi

cd Python-$python_ver
./configure --prefix=$HOME/.local LDFLAGS="-L$HOME/.local/lib -L$HOME/.local/openssl/lib -Wl,--rpath=$HOME/.local/lib -Wl,--rpath=$HOME/.local/openssl/lib" CFLAGS="-fPIC -I$HOME/.local/include -I$HOME/.local/openssl/include -I$HOME/.local/openssl/include/openssl" CPPFLAGS="-fPIC -I$HOME/.local/include -I$HOME/.local/openssl/include -I$HOME/.local/openssl/include/openssl" --enable-shared --enable-ipv6 --with-openssl=$HOME/.local/
make -j4
read -p "Is the result of make right?" ys
case "ys" in
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
