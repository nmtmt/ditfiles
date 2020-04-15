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

echo "Install xz..."
cd $src_dir
if [ ! -f xz-$xz_ver ]; then
    if [ ! -f xz-$xz_ver.tar.gz ]; then
        wget https://sourceforge.net/projects/lzmautils/files/xz-$xz_ver.tar.gz -O xz-$xz_ver.tar.gz
    fi
    tar zxf xz-$xz_ver.tar.gz
fi
cd xz-$xz_ver
./configure --prefix=$HOME/.local \
    --enable-shared \
    --enable-static
make -j4 && make install
if [ $? != 0 ]; then
    echo "xz installation failed!"
    exit 1
fi
echo "Done!"

echo "Install bzip2..."
cd $src_dir
if [ ! -f bzip2-$bzip2_ver ]; then
    if [ ! -f bzip2-$bzip2_ver.tar.gz ]; then
        wget https://sourceware.org/pub/bzip2/bzip2-$bzip2_ver.tar.gz -O bzip2-$bzip2_ver.tar.gz
    fi
    tar zxf bzip2-$bzip2_ver.tar.gz
fi
cd bzip2-$bzip2_ver
make -j4 PREFIX=$HOME/.local && make install PREFIX=$HOME/.local
if [ $? != 0 ]; then
    echo "bzip2 installation failed!"
    exit 1
fi
echo "Done!"

echo "Install libarchive(dependency of pixz)..."
cd $src_dir
if [ ! -f libarchive-$libarchive_ver ]; then
    if [ ! -f libarchive-$libarchive_ver.tar.gz ]; then
        wget https://www.libarchive.org/downloads/libarchive-$libarchive_ver.tar.gz -O libarchive-$libarchive_ver.tar.gz
    fi
    tar zxf libarchive-$libarchive_ver.tar.gz
fi
cd libarchive-$libarchive_ver
./configure --prefix=$HOME/.local --enable-shared --enable-static
make -j4 PREFIX=$HOME/.local && make install PREFIX=$HOME/.local
if [ $? != 0 ]; then
    echo "pbzip2 installation failed!"
    exit 1
fi
echo "Done!"

echo "Install pbzip2..."
cd $src_dir
if [ ! -f pbzip2-$pbzip2_ver ]; then
    if [ ! -f pbzip2-$pbzip2_ver.tar.gz ]; then
        wget https://launchpad.net/pbzip2/$pbzip2_major_ver/$pbzip2_ver/+download/pbzip2-$pbzip2_ver.tar.gz -O pbzip2-$pbzip2_ver.tar.gz
    fi
    tar zxf pbzip2-$pbzip2_ver.tar.gz
fi
cd pbzip2-$pbzip2_ver
make -j4 PREFIX=$HOME/.local && make install PREFIX=$HOME/.local
if [ $? != 0 ]; then
    echo "pbzip2 installation failed!"
    exit 1
fi
echo "Done!"

echo "Install pixz..."
cd $src_dir
if [ ! -f pixz-$pixz_ver ]; then
    if [ ! -f pixz-$pixz_ver.tar.gz ]; then
        wget https://github.com/vasi/pixz/releases/download/v$pixz_ver/pixz-$pixz_ver.tar.gz -O pixz-$pixz_ver.tar.gz
    fi
    tar zxf pixz-$pixz_ver.tar.gz
fi
cd pixz-$pixz_ver
./configure --prefix=$HOME/.local \
    CFLAGS="-I$HOME/.local/include" \
    LDFLAGS="-L$HOME/.local/lib -Wl,--rpath=$HOME/.local/lib" \
    PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig
make -j4 PREFIX=$HOME/.local && make install PREFIX=$HOME/.local
if [ $? != 0 ]; then
    echo "pixz installation failed!"
    exit 1
fi
echo "Done!"

echo "Install pigz..."
cd $src_dir
if [ ! -f pigz-$pigz_ver ]; then
    if [ ! -f pigz-$pigz_ver.tar.gz ]; then
        wget https://zlib.net/pigz/pigz-$pigz_ver.tar.gz -O pigz-$pigz_ver.tar.gz
    fi
    tar zxf pigz-$pigz_ver.tar.gz
fi
cd pigz-$pigz_ver
make && cp pigz unpigz $HOME/.local/bin
if [ $? != 0 ]; then
    echo "pigz installation failed!"
    exit 1
fi
echo "Done!"
