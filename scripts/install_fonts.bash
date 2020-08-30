#!/bin/bash

if   [ "$(uname -s)" = "Darwin" ];then os=mac
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then os=linux
else os=unknown
fi

if [ $os = "mac" ]; then
    fonts_dist=~/Library/Fonts
elif [ $os = "linux" ] ; then
    fonts_dist=~/.fonts
fi

if [ ! -f $fonts_dist ]; then
    echo 'make font directory:'$fonts_dist
    mkdir -p $fonts_dist
fi

read -p "Do you have fonts collections?[y/N]:"  ys
case "$ys" in
    [yY]*)
        echo "Choose the directory including fonts"
        fonts_src=$(zenity --file-selection --directory)
        echo "copying fonts from $fonts_src to $fonts_dist"
        cp -rv $fonts_src/* $fonts_dist
        ;;
    [nN]*)
        echo "Donwload Cica font and install it..."
        wget https://github.com/miiton/Cica/releases/download/v5.0.1/Cica_v5.0.1_with_emoji.zip
        cur_dir=$(pwd)
        cica_dir=$fonts_dist/Cica
        if [ ! -e $cica_dir ]; then
            mkdir -p $cica_dir
        fi
        mv Cica_v5.0.1_with_emoji.zip $cica_dir
        cd $cica_dir
        unzip Cica_v5.0.1_with_emoji.zip -d $cica_dir
        rm Cica_v5.0.1_with_emoji.zip 
        cd $cur_dir
        echo "Done installing Cica"
        ;;
    *)
        echo "Invalid input"
esac
