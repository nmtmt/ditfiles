#!/usr/bin/env bash

src_dir=$HOME/.local/src
uuid_ver="2.34"

cd $src_dir
wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v$uuid_ver/util-linux-$uuid_ver.tar.gz -O util-linux-$uuid_ver.tar.gz
tar xvfz util-linux-$uuid_ver.tar.gz
cd util-linux-$uuid_ver
./configure --prefix=$HOME/.local/util-linux-$uuid_ver --disable-all-programs --enable-libuuid --without-python --disable-makeinstall-chown --without-systemdsystemunitdir --without-ncurses  PKG_CONFIG=""
make
make install
cd $HOME/.local/util-linux-$uuid_ver/
cp lib/libuuid* $HOME/.local/lib/
cp lib/pkgconfig/* $HOME/.local/lib/pkgconfig/
cp -r include/uuid $HOME/.local/include/
