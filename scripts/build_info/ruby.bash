major_ver="3.0"
ver="3.0.0"
url=https://cache.ruby-lang.org/pub/ruby/$major_ver/ruby-$ver.tar.gz
pkg_tarname=ruby-$ver.tar.gz
pkg_dirname=ruby-$ver
commands(){
    ./configure --prefix=$HOME/.local --enable-shared --with-openssl-dir=$HOME/.local/openssl
    make -j4
    make install
}
