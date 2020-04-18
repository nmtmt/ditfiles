zlib_ver="1.2.11"
xz_ver="5.2.5"
bzip2_ver="1.0.8"
libarchive_ver="3.4.2"
pbzip2_major_ver="1.1"
pbzip2_ver="1.1.13"
pixz_ver="1.0.6"
pigz_ver="2.4"
src_dir=$HOME/.local/src

if [ ! -e $src_dir ]; then
    mkdir -p $src_dir
fi

# args: package_link, package_tarname, package_dirname
download_and_extract_package(){
    cd $src_dir
    if [ ! -d $3 ]; then
        echo "$3 not found. Check compressed file..."
        if [ ! -f $2 ]; then
            echo "$2 not found. Download compressed file..."
            while [ 1 ];do
                wget --retry-connrefused --waitretry 0 --tries 20 --timeout 3 $1 -O $2
                if [ $? = 0 ];then break 
                fi
            done
        fi
        echo "extract compressed file... : $2"
        tar zxf $2
        echo "Done"
    fi
    if [ $? != 0 ]; then
        echo "Failed in download and extract packages"
        echo "Remove downloaded items..."
        cd $src_dir && rm -rf $3 $2 && echo "Done!"
        exit 1
    fi
}
check_success(){
    if [ $? != 0 ]; then
        echo "Installation failed!"
        exit 1
    fi
    echo "Install Completed!"
}

echo "Install zlib..."
download_and_extract_package https://www.zlib.net/zlib-$zlib_ver.tar.gz zlib-$zlib_ver.tar.gz zlib-$zlib_ver
cd zlib-$zlib_ver
./configure --prefix=$HOME/.local
make -j4 && make install

echo "Install xz..."
download_and_extract_package https://sourceforge.net/projects/lzmautils/files/xz-$xz_ver.tar.gz xz-$xz_ver.tar.gz xz-$xz_ver
cd xz-$xz_ver
./configure --prefix=$HOME/.local \
    --enable-shared \
    --enable-static
make -j4 && make install
check_success

echo "Install bzip2..."
download_and_extract_package https://sourceware.org/pub/bzip2/bzip2-$bzip2_ver.tar.gz bzip2-$bzip2_ver.tar.gz bzip2-$bzip2_ver
cd bzip2-$bzip2_ver
make -j4 PREFIX=$HOME/.local && make install PREFIX=$HOME/.local
check_success
echo "Creat shared library..."
make clean && make -f Makefile-libbz2_so
cp *.so* $HOME/.local/lib
check_success

echo "Install libarchive(dependency of pixz)..."
cd $src_dir
download_and_extract_package https://www.libarchive.org/downloads/libarchive-$libarchive_ver.tar.gz libarchive-$libarchive_ver.tar.gz libarchive-$libarchive_ver
cd libarchive-$libarchive_ver
./configure --prefix=$HOME/.local --enable-shared --enable-static
make -j4 PREFIX=$HOME/.local && make install PREFIX=$HOME/.local
check_success

echo "Install pbzip2..."
download_and_extract_package https://launchpad.net/pbzip2/$pbzip2_major_ver/$pbzip2_ver/+download/pbzip2-$pbzip2_ver.tar.gz pbzip2-$pbzip2_ver.tar.gz pbzip2-$pbzip2_ver
cd pbzip2-$pbzip2_ver
make -j4 PREFIX=$HOME/.local CXXFLAGS="-I$HOME/.local/include" LDFLAGS="-L$HOME/.local/lib" && make install PREFIX=$HOME/.local 
check_success

echo "Install pixz..."
download_and_extract_package https://github.com/vasi/pixz/releases/download/v$pixz_ver/pixz-$pixz_ver.tar.gz pixz-$pixz_ver.tar.gz pixz-$pixz_ver
cd pixz-$pixz_ver
./configure --prefix=$HOME/.local \
    CFLAGS="-I$HOME/.local/include" \
    LDFLAGS="-L$HOME/.local/lib -Wl,--rpath=$HOME/.local/lib" \
    PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig
make -j4 PREFIX=$HOME/.local && make install PREFIX=$HOME/.local
check_success

echo "Install pigz..."
download_and_extract_package https://zlib.net/pigz/pigz-$pigz_ver.tar.gz pigz-$pigz_ver.tar.gz pigz-$pigz_ver
cd pigz-$pigz_ver
make CFLAGS="-I$HOME/.local/include" LDFLAGS="-L$HOME/.local/lib"
cp pigz unpigz $HOME/.local/bin
check_success
