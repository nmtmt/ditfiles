#!/bin/bash

if   [ "$(uname -s)" = "Darwin" ];then os=mac
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then os=linux
else os=unknown
fi

sudo -v 
if [ $? == 0 ]; then sudo_access=1
else sudo_access=0
fi
    
if [ $os = "mac" ]; then
    cat ./env/mac/packages      | xargs brew install 
    cat ./env/mac/cask_packages | xargs brew cask install 
    cat ./env/default_python_packages | xargs -L 1 pip3 install 
elif [ $os = "linux" ] ; then
    if [ $sudo_access ]; then
        cat ./env/ubuntu16/ppa      | xargs -L 1 sudo apt-add-repository 
        sudo apt update
        cat ./env/ubuntu16/packages | xargs sudo apt install -y
        cat ./env/default_python_packages | xargs -L 1 sudo pip3 install 
    else
        echo "You don't have access to sudo!"
        read -p "Install packages from source?[y/N]" ys
        case $ys in 
            [yY]*)
                bash ./scripts/build_pkgs.bash
                ;;
            *)
                echo " Quit installing packages";;
        esac
    fi
fi

if [ $sudo_access ]; then
    venv_shell=/usr/local/bin/virtualenvwrapper.sh 
    venv_python=/usr/local/bin/python3
else
    venv_shell=$HOME/.local/bin/virtualenvwrapper.sh 
    venv_python=$HOME/.local/bin/python3
fi

# install virtualenvwrapper
if [ -f $venv_shell ]; then
    export VIRTUALENVWRAPPER_PYTHON=$venv_python
    export WORKON_HOME=$HOME/.venvs
    source $venv_shell
    if [ $? != 0 ]; then
        echo "setup virtualenvwrapper failed! abort"
        exit 1
    fi

    if [[ $SHELL = *"/bash" ]] ; then initshell=.bashrc
    elif [[ $SHELL = *"/zsh" ]]; then initshell=.zshrc
    fi

    grep "export WORKON_HOME=" $HOME/$initshell
    if [ $? != 0 ];then
        echo "if [ -f $venv_shell ]; then"                     >> $HOME/$initshell
        echo "    export VIRTUALENVWRAPPER_PYTHON=$venv_python">> $HOME/$initshell
        echo "    export WORKON_HOME=$HOME/.venvs"             >> $HOME/$initshell
        echo "    source $venv_shell" >> $HOME/$initshell
        echo "fi"                     >> $HOME/$initshell
    fi
fi

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
    read -p "is thie dualboot env?[y/N]" ys
    case $ys in 
        [yY]*) 
            timedatectl set-local-rtc true 
            echo "Done fixing time setting"
            ;;
        *) echo "skip setting time problem between windows and linux";;
    esac

    echo "setting font and theme..."
    unity-tweak-tool -a
    echo "Done"

    # regard caps as ctrl
    echo "Setting caps as ctrl"
    gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
    echo "Done"

    if [ $sudo_access ]; then
        # for backlight on Let's note
        echo "Change boot setting..."
        sudo sed --in-place 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_backlight=vendor acpi_osi="/g' /etc/default/grub
        sudo sed --in-place 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=300/g' /etc/default/grub

        # update grub
        sudo update-initramfs -u
        sudo update-grub
        echo "Done updatting grub with new config"
    fi
fi
