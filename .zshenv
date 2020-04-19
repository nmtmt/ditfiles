#!/usr/bin/env zsh

export LANG="en_US.utf-8"
export PS1="%F{113}${USER}@${HOST%%.*}%f:%F{249}%0~%f%(!.#.$) "

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

if   [ "$(uname -s)" = "Darwin" ]; then os=mac
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
fi

if which trash-put &> /dev/null; then
    alias rm='trash-put'
    trash-empty 50
fi
