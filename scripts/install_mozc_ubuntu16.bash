#!/bin/bash

# refer to https://www.karelie.net/install-ibus-mozc/#ibus-mozc-2
cur_dir=$(pwd)

read -p 'Please input proper url of mozc tgz file from https://osdn.net/users/sicklylife/pf/mozc_ut_for_ubuntu/files :' url

#wget https://ja.osdn.net/downloads/users/16/16066/mozc-2.18.2598.102%2Bdfsg-1~ut2-20171008.tgz -O ~/Downloads/mozc.tgz
if [ ! -f ~/Downloads/mozc.tar.tgz ];then
    wget $url -O ~/Downloads/mozc.tgz
fi

cd ~/Downloads
#tar zxvf mozc.tgz
tar xvf mozc.tgz
cd mozc-*/

sed -i s/'const bool kActivatedOnLaunch = false;'/'const bool kActivatedOnLaunch = true;'/g mut/src/unix/ibus/property_handler.cc
sudo apt-get install -y clang libdbus-1-dev libglib2.0-dev libgtk2.0-dev subversion tegaki-zinnia-japanese debhelper libibus-1.0-dev build-essential libssl-dev libxcb-xfixes0-dev python-dev gyp protobuf-compiler libqt4-dev libuim-dev libzinnia-dev fcitx-libs-dev devscripts ninja-build
sudo ./build_mozc_plus_utdict
tail -n 5 /var/log/apt/history.log | grep Install: | sed -e s/"Install: "// | sed -e s/", automatic"//g | sed -e s/"), "/"\n"/g | sed -e s/" (.*$"/""/g | tr '\n' ' ' | xargs sudo apt-get remove -y
sudo apt install ./mozc-*.deb ./fcitx-mozc_*.deb ./ibus-mozc_*.deb
gsettings set org.gnome.settings-daemon.plugins.keyboard active true

cd $cur_dir
