#!/bin/bash

source ./link_dotfiles.bash

if   [ "$(uname -s)" = "Darwin" ] ;then os=mac
elif [ "$(uname -s)" = "FreeBSD" ];then os=unix
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then os=linux
else os=unknown
fi

if $(which sudo > /dev/null 2>&1); then
    sudo -v 
    if [ $? == 0 ]; then
        sudo_access=true
    else
        sudo_access=false
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
        if [ $(cat /etc/lsb-release | grep ID | cut -d '=' -f 2) = "Ubuntu" ]; then
            release=$(cat /etc/lsb-release | grep RELEASE | cut -d '=' -f 2)
            case $release in
                16*)
                    release=16;;
                18*)
                    release=18;;
                20*)
                    release=20
            esac
            cat ./env/ubuntu$release/ppa      | xargs -L 1 sudo apt-add-repository
            sudo apt update
            cat ./env/ubuntu$release/packages | xargs sudo apt install -y
        fi
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
            echo "Quit installing packages";;
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

make_venv_with_local_python(){
    venv_shell=$HOME/.local/bin/virtualenvwrapper.sh 
    venv_python=$HOME/.local/bin/python3
    pip3 install -r $HOME/dotfiles/env/system_pip_pkgs
}

make_venv_with_system_python(){
    venv_shell=/usr/local/bin/virtualenvwrapper.sh 
    venv_python=/usr/local/bin/python3
    $sudo_cmd pip3 install -r $HOME/dotfiles/env/system_pip_pkgs
}


echo "Setting virtualenvwrapper..."

if [ ! -f $HOME/.local/bin/python3 ]; then
    make_venv_with_system_python

else
    read -p "Local python3 found!. Do you use local python3 for virtuenenv? [y/N]:" ys
    case $ys in
        [yY])
            make_venv_with_local_python;;
        *)
            make_venv_with_system_python;;
    esac 
fi
hash -r

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
        exit
    fi
    deactivate > /dev/null 2>&1
else
    echo "Cannot find $venv_shell. Abort installing virtualenvwrapper"
    exit 1
fi

if [[ ! $SHELL = */zsh ]]; then
    echo 'Current default shell is '$SHELL
    read -p 'Change default shell to zsh?:[y/N]' yn
    case yn in
        [yY]*)
            echo 'Changing default shell...'
            chsh $USER -s `which zsh`
            if [ ! $? = 0 ];then
                echo 'Failed to change default shell to zsh!'
                exit 1
            fi
            ;;
            *)
                echo 'Stop changing default shell';;
    esac
    echo 'Finished changing shell'
fi

read -p "Do you install fonts? [y/N]:" yn
case "$yn" in
  [yY]*) 
      source $HOME/dotfiles/scripts/install_fonts.bash
      if [ $? == 0 ];then
          echo "Successfully installed fonts"
      else
          echo "error in installing fonts! stop scripts..."
          exit 1
      fi;;
  [nN]*) echo "Skip installing fonts";;
  *)     echo "Invalid input. Skip installing fonts";;
esac

if [ $os = "linux" ] && [ $(cat /etc/lsb-release | grep ID | cut -d '=' -f 2) = "Ubuntu" ] ; then
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
        if which unity-tweak-tool > /dev/null 2>&1; then
            unity-tweak-tool -a
        elif which gnome-tweaks > /dev/null 2>&1; then
            gnoem-tweaks
        fi
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
