#!/usr/bin/env zsh

#setopt no_global_rcs # dont load /etc/z* files

# setting for zsh_history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000  # histry to be saved in memory
export SAVEHIST=10000 # histry saved in file

setopt hist_ignore_dups
setopt nolistbeep
setopt append_history # when using multiple zsh
#setopt share_history  # with multiple terminal

# enable advanced tab completion
autoload -U compinit
compinit

export LANG="en_US.UTF-8"

if [ ! -z $XDG_CURRENT_DESKTOP ];then
    source $HOME/.xprofile
fi

# for using host display in WSL2
if [ $(uname -s) = Linux ] && [[ $(uname -r) = *microsoft* ]];then
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
fi
