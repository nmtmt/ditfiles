#!/bin/bash

conf_file=/usr/share/X11/xorg.conf.d/40-libinput.conf
release=$(cat /etc/lsb-release | grep RELEASE | cut -d '=' -f 2)
case $release in
    16*)
        if [ -f $conf_file ];then
            if grep NaturalScrolling $conf_file >/dev/null;then
                echo "Found natural scrolling setting in $conf_file !"
            else
                echo "Add NaturalScrolling setting to $conf_file ..."
                sudo sed -i -e '/libinput pointer catchall/{n;n;a \        Option "NaturalScrolling" "on"
                }' $conf_file
            fi
        else
            echo "Cannot find $conf_file !"
        fi
        ;;
    *)
        echo "Please set natural scrolling with system settings gui"
esac
