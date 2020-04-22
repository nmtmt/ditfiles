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

makedir(){
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
}

# link dotfiles
if [ $os = "mac" ] || [ $os = "linux" ]; then
    ln -sf $HOME/dotfiles/.vimrc         $HOME/.vimrc
    ln -sf $HOME/dotfiles/.gvimrc        $HOME/.gvimrc
    ln -sf $HOME/dotfiles/.zshrc         $HOME/.zshrc
    ln -sf $HOME/dotfiles/.zshenv        $HOME/.zshenv
    ln -sf $HOME/dotfiles/.dircolors     $HOME/.dircolors
    ln -sf $HOME/dotfiles/.tmux.conf     $HOME/.tmux.conf
    ln -sf $HOME/dotfiles/.rsync_exclude $HOME/.rsync_exclude
    ln -sf $HOME/dotfiles/.gitconfig     $HOME/.gitconfig
    makedir $HOME/.ssh
    ln -sf $HOME/dotfiles/.ssh/config  $HOME/.ssh/config
    makedir $HOME/.vim/.cache/dein
    makedir $HOME/.local/bin
    ln -sf $HOME/dotfiles/scripts/start_rsync.sh  $HOME/.local/bin/start_rsync.sh
    ln -sf $HOME/dotfiles/scripts/start_lsyncd.sh $HOME/.local/bin/start_lsyncd.sh
    ln -sf $HOME/dotfiles/.lsyncd_local.conf      $HOME/.lsyncd_local.conf
elif [ $os = "windows" ]; then
    ln -sf $HOME/dotfiles/.vimrc     $HOME/_vimrc
    ln -sf $HOME/dotfiles/.gvimrc    $HOME/_gvimrc
    makedir $HOME/vimfiles/cache/dein
fi
ln -sf ~/dotfiles/.latexmkrc ~/.latexmkrc
