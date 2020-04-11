#!/bin/bash 

src_dir=$HOME/.local/src
ruby_major_ver="2.5"
ruby_ver="2.5.3"

cd $src_dir
if [ ! -e ruby-$ruby_ver ]; then
    if [ ! -e ruby-$ruby_ver.tar.gz ]; then
        wget -t 10 --timeout 5 --waitretry=1 --retry-connrefused https://cache.ruby-lang.org/pub/ruby/$ruby_major_ver/ruby-$ruby_ver.tar.gz -O ruby-$ruby_ver.tar.gz
    fi
    tar zxvf ruby-$ruby_ver.tar.gz
    if [ $? != 0 ]; then
        rm ruby-$ruby_ver ruby-$ruby_ver.tar.gz 
    fi
fi
cd ruby-$ruby_ver
./configure --prefix=$HOME/.local/ruby-$ruby_ver --enable-shared
make
make install
