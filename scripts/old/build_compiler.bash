gcc_ver="9.3.0"

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

echo "Install gcc..."
download_and_extract_package http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-$gcc_ver/gcc-$gcc_ver.tar.gz gcc-$gcc_ver.tar.gz gcc-$gcc_ver
cd gcc-$gcc_ver
./contrib/download_prerequisites
mkdir build && cd build
../configure --enable-languages=c,c++ --prefix=$HOME/.local --disable-bootstrap --disable-multilib
make -j4 
make install
check_success
