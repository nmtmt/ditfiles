#!/bin/bash
core_package=$(sudo dpkg -l | grep xserver-xorg-core | xargs -L 1 echo | awk '{print $2}')
case $core_package in
    xserver-xorg-core)
        echo Managing package for enable natural scrolling...
        sudo apt install xserver-xorg-input-libinput
        sudo apt purge xserver-xorg-input-synaptics
        ;;
    xserver-xorg-core-*)
        echo Managing package for enable natural scrolling \(with hwe packages\)...
        sudo apt install xserver-xorg-input-libinput-hwe-16.04
        sudo apt purge xserver-xorg-input-synaptics-hwe-16.04
        ;;
    *)
        echo error!
        exit 1
esac
if [ $? = 1 ];then
    echo Done!
else
    echo Failed to manage packages!
    exit 1
fi
