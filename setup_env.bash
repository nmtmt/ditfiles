#!/bin/bash

cat ./env/ppa      | xargs -L 1 sudo apt-add-repository 
sudo apt update
cat ./env/packages | xargs sudo apt install -y

# setup Cica
wget https://github.com/miiton/Cica/releases/download/v5.0.1/Cica_v5.0.1_with_emoji.zip
font_dir=~/.font/Cica
cur_dir=$(pwd)
echo $cur_dir
mkdir -p $font_dir
mv Cica_v5.0.1_with_emoji.zip $font_dir
cd $font_dir
unzip Cica_v5.0.1_with_emoji.zip 
rm Cica_v5.0.1_with_emoji.zip 
sudo cp -r ../Cica /usr/share/fonts
cd $cur_dir

# fix time difference in dual boot env
timedatectl set-local-rtc true

# regard caps as ctrl
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"

# for backlight on Let's note
sudo sed --in-place 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_backlight=vendor"/g' /etc/default/grub
sudo sed --in-place 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=300/g' /etc/default/grub

unity-tweak-tool -a

# update grub
sudo update-initramfs -u
sudo update-grub
