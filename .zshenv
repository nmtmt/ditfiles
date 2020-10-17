#!/usr/bin/env zsh

#setopt no_global_rcs # dont load /etc/z* files

if [ -f $HOME/.dircolors ]; then
    if type dircolors > /dev/null 2>&1; then
        eval $(dircolors $HOME/.dircolors)
    elif type gdircolors > /dev/null 2>&1; then
        eval $(gdircolors $HOME/.dircolors)
    fi
fi

if [ -n $LS_COLORS ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# setting for zsh_history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000  # histry to be saved in memory
export SAVEHIST=10000 # histry saved in file

setopt hist_ignore_dups
setopt nolistbeep
setopt append_history # when using multiple zsh
#setopt share_history  # with multiple terminal

if [ ! -z $XDG_CURRENT_DESKTOP ];then
    source $HOME/.xprofile
fi
