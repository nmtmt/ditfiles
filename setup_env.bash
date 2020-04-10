#!/bin/bash

if   [ "$(uname -s)" = "Darwin" ];then os=mac
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then os=linux
else os=unknown
fi
    
if [ $os = "mac" ]; then
    cat ./env/mac/packages      | xargs brew install 
    cat ./env/mac/cask_packages | xargs brew cask install 
    cat ./env/default_python_packages | xargs -L 1 sudo pip3 install 
elif [ $os = "linux" ] ; then
    cat ./env/ubuntu16/ppa      | xargs -L 1 sudo apt-add-repository 
    sudo apt update
    cat ./env/ubuntu16/packages | xargs sudo apt install -y
    cat ./env/default_python_packages | xargs -L 1 sudo pip3 install 
fi
exit 0

read -p "Do you install fonts? (y/N): " yn
case "$yn" in
  [yY]*) 
      bash $HOME/dotfiles/scripts/install_fonts.bash
      if [ $? == 0 ];then
          echo "Successfully installed fonts"
      else
          echo "error in installing fonts! stop scripts..."
          exit 1
      fi;;
  [nN]*) echo "Skip installing fonts";;
  *)     echo "Invalid input. Skip installing fonts";;
esac

if [ $os = "linux" ]; then
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
