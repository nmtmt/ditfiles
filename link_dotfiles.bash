#!/bin/bash

if [ "$(uname -s)" == "Darwin" ]; then 
    os=mac
    hash curl > /dev/null 2>&1 || brew install curl
elif [ "$(uname -s)" == "FreeBSD" ]; then
    os=unix
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
if [ $os = "mac" ] || [ $os = "linux" ] || [ $os = "unix" ]; then
    if [ $os = "mac" ] && which gls > /dev/null 2>&1; then
        ln(){
            gln $*
        }
    fi
    ln -sf $HOME/dotfiles/.vimrc         $HOME/.vimrc
    ln -sf $HOME/dotfiles/.gvimrc        $HOME/.gvimrc
    makedir $HOME/.vim
    ln -sfT $HOME/dotfiles/vim/ftplugin  $HOME/.vim/ftplugin
    ln -sf $HOME/dotfiles/.zshrc         $HOME/.zshrc
    ln -sf $HOME/dotfiles/.zshenv        $HOME/.zshenv
    ln -sf $HOME/dotfiles/.dircolors     $HOME/.dircolors
    ln -sf $HOME/dotfiles/.tmux.conf     $HOME/.tmux.conf
    ln -sf $HOME/dotfiles/.rsync_exclude $HOME/.rsync_exclude
    ln -sf $HOME/dotfiles/.gitconfig     $HOME/.gitconfig
    ln -sf $HOME/dotfiles/.Xmodmap       $HOME/.Xmodmap
    ln -sf $HOME/dotfiles/.xprofile      $HOME/.xprofile

    makedir $HOME/.vim/.cache/dein
    makedir $HOME/.local/bin
    ln -sf  $HOME/dotfiles/.lsyncd_local.conf $HOME/.lsyncd_local.conf

    makedir $HOME/.config
    ln -sfT $HOME/dotfiles/.config/tmuxinator $HOME/.config/tmuxinator
    if [ $os = "linux" ] || [ $os = "unix" ]; then
        ln -sfT $HOME/dotfiles/.config/autostart  $HOME/.config/autostart
    fi
    makedir $HOME/.config/nvim
    ln -sf $HOME/.vimrc  $HOME/.config/nvim/init.vim
    ln -sf $HOME/.gvimrc $HOME/.config/nvim/ginit.vim

elif [ $os = "windows" ]; then
    ln -sf $HOME/dotfiles/.vimrc  $HOME/_vimrc
    ln -sf $HOME/dotfiles/.gvimrc $HOME/_gvimrc

    makedir $HOME/vimfiles/cache/dein
    ln -sfT $HOME/dotfiles/vim/ftplugin $HOME/vimfiles/ftplugin
fi
ln -sf ~/dotfiles/.latexmkrc ~/.latexmkrc
