#!/bin/bash

makedir(){
    dirpath=$1
    if [ ! -d $dirpath ];then
        echo Make directory...$dirpath
        mkdir -p $dirpath
    fi
}

copy_and_extract(){
    name=$1
    dist_dir=$2

    echo Choose $name folder!
    src_dir=$(zenity --file-selection --directory)

    makedir $dist_dir
    echo "Copying fonts from $src_dir to $dist_dir"
    cp -rv $src_dir/* $dist_dir

    cur_dir=$(pwd)
    cd $dist_dir
    find . -type f -name '*.tar.*' | while read file; do
        tar xvf $file
    done
    find . -type f -name '*.zip' | while read file; do
        unzip -f $file
    done
    
    cd $cur_dir
}

install_application_themes(){
    copy_and_extract 'application themes' $HOME/.themes
}
install_icons(){
    copy_and_extract 'icons' $HOME/.icons
}
install_plank_themes(){
    copy_and_extract 'plank themes' $HOME/.local/share/plank/themes
}

case $OSTYPE in
    linux*)
        install_application_themes
        install_icons
        install_plank_themes
        ;;
    *)
        ;;
esac
