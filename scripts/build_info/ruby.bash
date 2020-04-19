major_ver="2.5"
ver="2.5.3"
url=https://cache.ruby-lang.org/pub/ruby/$major_ver/ruby-$ver.tar.gz
pkg_tarname=ruby-$ver.tar.gz
pkg_dirname=ruby-$ver
commands(){
    ./configure --prefix=$HOME/.local --enable-shared
    make -j4
    make install
}
