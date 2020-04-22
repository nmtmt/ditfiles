ver="2.34"
url=https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v$ver/util-linux-$ver.tar.gz
pkg_tarname=util-linux-$ver.tar.gz
pkg_dirname=util-linux-$ver
commands(){
    ./configure --prefix=$HOME/.local/util-linux-$ver --disable-all-programs --enable-libuuid --without-python --disable-makeinstall-chown --without-systemdsystemunitdir --without-ncurses  PKG_CONFIG=""
    make
    make install
    cp $HOME/.local/util-linux-$ver/lib/libuuid* $HOME/.local/lib/
    cp $HOME/.local/util-linux-$ver/lib/pkgconfig/* $HOME/.local/lib/pkgconfig/
    cp -r $HOME/.local/util-linux-$ver/include/uuid $HOME/.local/include/
    ln -s $HOME/.local/include/uuid/* $HOME/.local/include/
}
