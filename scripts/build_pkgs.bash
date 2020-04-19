#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd)

# load functions for installing
source func.bash

src_dir=$HOME/.local/src
if [ ! -e $src_dir ]; then
    mkdir -p $src_dir
fi
if [ ! -f $src_dir/.installed_pkgs ]; then
    touch $src_dir/.installed_pkgs
else
    installed_pkgs=$(cat $src_dir/.installed_pkgs)
fi

install(){
    pkgs=$@
    for pkg in $pkgs; do
        if `echo ${installed_pkgs[@]} | grep -q "$pkg"` ; then
            echo "Package '$pkg' is already installed!"
            echo "If you want to reinstall that package, remove pkg name from $src_dir/.installed_pkgs"
        else
            echo "Installing $pkg ... "
            # load param and 'commands' function for build
            source $script_dir/build_info/$pkg.bash
            install_pkg $src_dir $url $pkg_tarname $pkg_dirname 
            echo $pkg >> $src_dir/.installed_pkgs
        fi
    done
}

compress_pkgs=("zlib" "xz" "bzip2" "libarchive" "pbzip2" "pixz" "pigz")
install ${compress_pkgs[@]}

compilers=("gcc")
install ${compilers[@]}

util_pkgs=("util-linux" "openssl" "libffi" "ncurses" "libsm")
install ${util_pkgs[@]}

programming_langs=("ruby" "lua" "python")
install ${programming_langs[@]}

editor_pkgs=("vim")
install ${editor_pkgs[@]}

