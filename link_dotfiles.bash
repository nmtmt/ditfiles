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
    if [ $os = "unix" ];then
        opt=h
    else
        opt=T
    fi

    ln -sf$opt $HOME/dotfiles/.vimrc         $HOME/.vimrc
    ln -sf$opt $HOME/dotfiles/.gvimrc        $HOME/.gvimrc
    makedir $HOME/.vim
    ln -sf$opt $HOME/dotfiles/vim/ftplugin  $HOME/.vim/ftplugin

    ln -sf$opt $HOME/dotfiles/.zshrc         $HOME/.zshrc
    ln -sf$opt $HOME/dotfiles/.zshenv        $HOME/.zshenv
    ln -sf$opt $HOME/dotfiles/.bashrc        $HOME/.bashrc
    ln -sf$opt $HOME/dotfiles/.aliases       $HOME/.aliases

    ln -sf$opt $HOME/dotfiles/.dircolors     $HOME/.dircolors
    ln -sf$opt $HOME/dotfiles/.tmux.conf     $HOME/.tmux.conf
    ln -sf$opt $HOME/dotfiles/.rsync_exclude $HOME/.rsync_exclude
    ln -sf$opt $HOME/dotfiles/.gitconfig     $HOME/.gitconfig
    ln -sf$opt $HOME/dotfiles/.Xmodmap       $HOME/.Xmodmap
    ln -sf$opt $HOME/dotfiles/.xprofile      $HOME/.xprofile

    makedir $HOME/.vim/.cache/dein
    makedir $HOME/.local/bin
    ln -sf$opt  $HOME/dotfiles/.lsyncd_local.conf $HOME/.lsyncd_local.conf

    makedir $HOME/.config
    ln -sf$opt $HOME/dotfiles/.config/tmuxinator $HOME/.config/tmuxinator
    if [ $os = "linux" ] || [ $os = "unix" ]; then
        ln -sf$opt $HOME/dotfiles/.config/autostart  $HOME/.config/autostart
    fi
    makedir $HOME/.config/nvim
    ln -sf$opt $HOME/.vimrc  $HOME/.config/nvim/init.vim
    ln -sf$opt $HOME/.gvimrc $HOME/.config/nvim/ginit.vim

elif [ $os = "windows" ]; then
    ln -sfT $HOME/dotfiles/.vimrc  $HOME/_vimrc
    ln -sfT $HOME/dotfiles/.gvimrc $HOME/_gvimrc

    makedir $HOME/vimfiles/cache/dein
    ln -sfT $HOME/dotfiles/vim/ftplugin $HOME/vimfiles/ftplugin
fi
ln -sf ~/dotfiles/.latexmkrc ~/.latexmkrc
