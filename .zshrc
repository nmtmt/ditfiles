#!/bin/zsh

if   [ "$(uname -s)" = "Darwin" ];then os=mac
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then os=linux
else os=unknown
fi

export PATH=$HOME/.local/bin:$PATH

if which trash-put &> /dev/null; then
    alias rm='trash-put'
    trash-empty 50
fi

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

#export PS1="%F{gray}${USER}@${HOST%%.*}%f:%F{blue}%0~%f%(!.#.$) "
export PS1="%F{113}${USER}@${HOST%%.*}%f:%F{249}%0~%f%(!.#.$) "

if [ $os = mac ];then
    if type gls > /dev/null 2>&1; then
        alias ls="gls --color=auto"
    elif type ls > /dev/null 2>&1; then
        alias ls="ls -G"
    fi
    #export LSCOLORS=exgxcxdxcxegedabagacad # default setting
    
    alias gcc=gcc-9
    alias g++=g++-9
    
    #function ssh_with_color(){ ssh $@ -t "export MYCOLORENV=mac && /bin/bash -l" }
    #alias ssh=ssh_with_color
elif [ $os = linux ]; then
    alias ls="ls --color=auto"
fi

if [ -f $HOME/.local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON=$HOME/.local/bin/python3
    export WORKON_HOME=$HOME/.venvs
    source $HOME/.local/bin/virtualenvwrapper.sh
    if [ -d $HOME/.venvs/default ]; then workon default; fi
elif [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    export WORKON_HOME=$HOME/.venvs
    source /usr/local/bin/virtualenvwrapper.sh
    if [ -d $HOME/.venvs/default ]; then workon default; fi
fi

