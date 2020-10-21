#!/bin/bash

app_dir=$HOME/.local/appimage

function install_appimage(){
    url=$1
    appimage_name=$2
    link_name=$3

    if [ ! -d $app_dir ]; then
        mkdir $app_dir
    fi
    if [ -f $app_dir/$appimage_name ];then
        echo Appimage $app_dir/$appimage_name found!
        return
    fi

    cd $app_dir

    echo Download appimage from $url
    while true; do
        wget --retry-connrefused --waitretry 0 --tries 10 --timeout 3 --no-check-certificate $url -O $appimage_name
        if [ $? = 0 ];then
            chmod a+x $appimage_name
            break
        fi
    done
    if [ ! -d $HOME/.local/bin ]; then
        mkdir $HOME/.local/bin
    fi
    ln -sf $app_dir/$appimage_name $HOME/.local/bin/$link_name
    echo Done!
}

install_appimage https://github.com/neovim/neovim/releases/download/stable/nvim.appimage nvim.appimage nvim
install_appimage https://download.kde.org/stable/krita/4.4.0/krita-4.4.0-x86_64.appimage krita-4.4.0.appimage krita
