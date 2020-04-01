#!/bin/bash

if [ "$(uname -s)" == "Darwin" ]; then 
    os=mac
    hash curl > /dev/null 2>&1 || brew install curl
elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    os=linux
    hash curl > /dev/null 2>&1 || sudo apt install curl
else
    os=unknown
fi

# link dotfiles
if [ $os = "mac" ] || [ $os = "linux" ]; then
    ln -sf ~/dotfiles/.vimrc     ~/.vimrc
    ln -sf ~/dotfiles/.gvimrc    ~/.gvimrc
    ln -sf ~/dotfiles/.zshrc     ~/.zshrc
    ln -sf ~/dotfiles/.unixenv   ~/.unixenv
    ln -sf ~/dotfiles/.macenv    ~/.macenv
    ln -sf ~/dotfiles/.rsync_exclude ~/.rsync_exclude
    ln -sf ~/dotfiles/select_termenv ~/select_termenv
    mkdir -p ~/.vim/.cache/dein
elif [ $os = "windows" ]; then
    ln -sf ~/dotfiles/.vimrc     ~/_vimrc
    ln -sf ~/dotfiles/.gvimrc    ~/_gvimrc
    mkdir -p ~/vimfiles/cache/dein
fi
ln -sf ~/dotfiles/.latexmkrc ~/.latexmkrc

