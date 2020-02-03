#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
    os=mac
    if !(type curl > /dev/null 2>&1);then 
        brew install curl 
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
    os=windows
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    os=linux
    if !(type curl > /dev/null 2>&1);then 
        sudo apt install curl
    fi
else
    os=unknown
fi

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh

# link dotfiles
if [ $os = "mac" ] || [ $os = "linux" ]; then
    ln -sf ~/dotfiles/.vimrc     ~/.vimrc
    ln -sf ~/dotfiles/.gvimrc    ~/.gvimrc
    ln -sf ~/dotfiles/.zshrc     ~/.zshrc
    ln -sf ~/dotfiles/.unixenv   ~/.unixenv
    ln -sf ~/dotfiles/.macenv    ~/.macenv
    ln -sf ~/dotfiles/select_termenv ~/select_termenv
    mkdir -p ~/.vim/.cache/dein
    sh installer.sh ~/.vim/.cache/dein
elif [ $os = "windows" ]; then
    ln -sf ~/dotfiles/.vimrc     ~/_vimrc
    ln -sf ~/dotfiles/.gvimrc    ~/_gvimrc
    mkdir -p ~/vimfiles/cache/dein
    sh installer.sh ~/vimfiles/cache/dein
fi
ln -sf ~/dotfiles/.latexmkrc ~/.latexmkrc
rm installer.sh

