#!/bin/bash

if   [ "$(uname -s)" = "Darwin" ] ;then os=mac
elif [ "$(uname -s)" = "FreeBSD" ];then os=unix
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then os=linux
else os=unknown
fi

if $(which sudo > /dev/null 2>&1); then
    sudo -v 
    if [ $? == 0 ]; then sudo_access=true
    else sudo_access=false
    fi
else
    sudo_access=false
fi
if $sudo_access; then
    sudo_cmd="sudo"
fi
    
if [ $os = "mac" ]; then
    cat ./env/mac/packages      | xargs brew install 
    cat ./env/mac/cask_packages | xargs brew cask install 
elif [ $os = "linux" ] ; then
    if $sudo_access; then
        cat ./env/ubuntu16/ppa      | xargs -L 1 sudo apt-add-repository 
        sudo apt update
        cat ./env/ubuntu16/packages | xargs sudo apt install -y
    else
        echo "You don't have access to sudo!"
        read -p "Install packages from source?[y/N]:" ys
        case $ys in 
            [yY]*)
                bash ./scripts/build_pkgs.bash;;
            *)
                echo " Quit installing packages";;
        esac
    fi
elif [ $os = "unix" ]; then
    echo "You don't have access to sudo!"
    read -p "Install packages from source?[y/N]:" ys
    case $ys in 
        [yY]*)
            bash ./scripts/build_pkgs.bash;;
        *)
            echo " Quit installing packages";;
    esac
fi
if [ ! $os = "mac" ]; then
    gem=$(which gem)
    case $gem in
        /usr*)
            echo "Installing ruby packages..."
            cat $HOME/dotfiles/env/gem_pkgs | xargs sudo gem install;;
        /home*)
            echo "Installing ruby packages..."
            cat $HOME/dotfiles/env/gem_pkgs | xargs gem install;;
    esac
fi

echo "Setting virtualenvwrapper..."
read -p "Do you use system python for VIRTUALENVWRAPPER_PYTHON?[y/N]:" ys
case $ys in
    [yY])
        venv_shell=/usr/local/bin/virtualenvwrapper.sh 
        venv_python=/usr/local/bin/python3
        $sudo_cmd pip3 install -r $HOME/dotfiles/env/system_pip_pkgs
        hash -r
        ;;
    *)
        venv_shell=$HOME/.local/bin/virtualenvwrapper.sh 
        venv_python=$HOME/.local/bin/python3
        if [ ! -f $venv_python ]; then
            echo "Installing system pip packages..."
            $sudo_cmd pip3 install -r $HOME/dotfiles/env/system_pip_pkgs
        else
            pip3 install -r $HOME/dotfiles/env/system_pip_pkgs
        fi
        hash -r
esac 
if [ -f $venv_shell ]; then
    deactivate > /dev/null 2>&1
    export VIRTUALENVWRAPPER_PYTHON=$venv_python
    export WORKON_HOME=$HOME/.venvs
    source $venv_shell
    if [ $? != 0 ]; then
        echo "Setup virtualenvwrapper failed! abort"
        exit 1
    fi
    if [ ! -d $WORKON_HOME/default ]; then
        echo "Successfully installed virtualenvwrapper. Creating default venv..."
        mkvirtualenv default --python=python3
    fi
    if [ $? == 0 ]; then
        workon default
        echo "Installing default pip packages..."
        pip install -r $HOME/dotfiles/env/venv_default_pip_pkgs
        echo "Setting virtualenvwrapper Done!"
    else
        echo "Failed to make default venv!"
    fi
    deactivate > /dev/null 2>&1
else
    echo "Cannot find $venv_shell. Abort installing virtualenvwrapper"
fi

read -p "Do you install fonts? [y/N]:" yn
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
    read -p "is thie dualboot env?[y/N]:" ys
    case $ys in 
        [yY]*) 
            timedatectl set-local-rtc true 
            echo "Done fixing time setting"
            ;;
        *) echo "skip setting time problem between windows and linux";;
    esac

    if [ ! -z "$DISPLAY" ]; then
        echo "Please configure font and theme..."
        unity-tweak-tool -a
        echo "Done"
    fi

    # regard caps as ctrl
    echo "Setting caps as ctrl"
    gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
    echo "Done"

    if $sudo_access; then
        read -p "Do you have a problem with backlight?[y/N]:" ys
        case $ys in
            [yY])
                # for backlight on Let's note
                echo "Change boot setting..."
                sudo sed --in-place 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_backlight=vendor acpi_osi="/g' /etc/default/grub
                sudo sed --in-place 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=300/g' /etc/default/grub

                # update grub
                sudo update-initramfs -u
                sudo update-grub
                echo "Done updatting grub with new config"
                ;;
            *)
                echo "Skip modifying grub setting";;
        esac
    fi
fi
