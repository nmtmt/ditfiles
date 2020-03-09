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

# get installer for dein(vim plugin manager)
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

# setup pdf viewer for vimtex
if [ $os = "mac" ] && [ ! -e /Applications/Skim.app ]; then
    brew cask install skim 
fi
