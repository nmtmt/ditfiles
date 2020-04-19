#!/usr/bin/env bash

download_and_extract_pkg(){
    src_dir=$1
    pkg_url=$2
    pkg_tarname=$3
    pkg_dirname=$4

    cd $src_dir
    if [ ! -d $pkg_dirname ]; then
        echo "$pkg_dirname not found. Check compressed file..."
        if [ ! -f $pkg_tarname ]; then
            echo "$pkg_tarname not found. Download compressed file..."
            while [ 1 ];do
                wget --retry-connrefused --waitretry 0 --tries 20 --timeout 3 --no-check-certificate $pkg_url -O $pkg_tarname
                if [ $? = 0 ]; then break ;fi
            done
        fi
        echo "Extracting compressed file... : $pkg_tarname"
        mkdir $pkg_dirname
        bash -c "tar xf $pkg_tarname -C $pkg_dirname --strip-components=1"
    fi
    if [ $? != 0 ]; then
        echo "Failed in download and extract packages"
        echo "Remove downloaded items..."
        cd $src_dir && rm -rf $pkg_dirname $pkg_tarname && echo "Removed!"
        exit 1
    fi
    echo "Done extracting."
}
check_installed(){
    if [ $? != 0 ]; then
        echo "Installation failed!"
        echo "Remove extracted dir..."
        eval rm -rf $1 && echo "Done removing!"
        exit 1
    fi
    echo "Install Completed!"
}
 
install_pkg(){
    cur_dir=$(pwd)
    src_dir=$1
    pkg_url=$2
    pkg_tarname=$3
    pkg_dirname=$4
    download_and_extract_pkg $1 $2 $3 $4

    # commands is a function defined in files in build_info
    cd $src_dir/$pkg_dirname && commands

    check_installed $src_dir/$pkg_dirname
    cd $cur_dir
    hash -r
}
