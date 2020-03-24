#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
    os=mac
    hash curl > /dev/null 2>&1 || brew install curl
elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
    os=windows
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    os=linux
    hash curl > /dev/null 2>&1 || sudo apt install curl
else
    os=unknown
fi

if [ $os = "mac" ]; then
    cat ./env/mac/packages | xargs brew install 
    font_dir=~/Library/Fonts/Cica
elif [ $os = "Linux" ] || [ $os = "Darwin" ]; then
    cat ./env/ubuntu16/ppa      | xargs -L 1 sudo apt-add-repository 
    sudo apt update
    cat ./env/ubuntu16/packages | xargs sudo apt install -y
    font_dir=~/.font/Cica
fi

# setup Cica
wget https://github.com/miiton/Cica/releases/download/v5.0.1/Cica_v5.0.1_with_emoji.zip
cur_dir=$(pwd)
mkdir -p $font_dir
mv Cica_v5.0.1_with_emoji.zip $font_dir
cd $font_dir
unzip Cica_v5.0.1_with_emoji.zip 
rm Cica_v5.0.1_with_emoji.zip 
sudo cp -r ../Cica /usr/share/fonts
cd $cur_dir

if [ $os = "Linux" ]; then
    # fix time difference in dual boot env
    timedatectl set-local-rtc true

    # regard caps as ctrl
    gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"

    # for backlight on Let's note
    sudo sed --in-place 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_backlight=vendor acpi_osi="/g' /etc/default/grub
    sudo sed --in-place 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=300/g' /etc/default/grub

        unity-tweak-tool -a

    # update grub
    sudo update-initramfs -u
    sudo update-grub
fi
