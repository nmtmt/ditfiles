#!/usr/bin/env zsh

#setopt no_global_rcs # dont load /etc/z* files

if [ -f $HOME/.dircolors ]; then
    if type dircolors > /dev/null 2>&1; then
        eval $(dircolors $HOME/.dircolors)
    elif type gdircolors > /dev/null 2>&1; then
        eval $(gdircolors $HOME/.dircolors)
    fi
else
    echo "failed to load dircolors!"
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
#setopt share_history  # with multiple terminal
setopt append_history # when using multiple zsh

if   [ "$(uname -s)" = "Darwin" ]; then os=mac
elif [ "$(uname -s)" = "FreeBSD" ]; then os=unix
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then os=linux
else os=unknown
fi

if [ $os = mac ];then
    if type gls > /dev/null 2>&1; then
        alias ls="gls --color=auto"
    elif type ls > /dev/null 2>&1; then
        alias ls="ls -G"
    fi
elif [ $os = linux ]; then
    alias ls="ls --color=auto"
elif [ $os = unix ]; then
    alias ls="ls -G"
    export MAILCHECK=0
fi

if [ ! -z $XDG_CURRENT_DESKTOP ];then
    source $HOME/.xprofile
fi
