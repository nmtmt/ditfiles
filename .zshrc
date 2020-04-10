#!/bin/zsh

if   [ "$(uname -s)" = "Darwin" ];then os=mac
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then os=linux
else os=unknown
fi

if which trash-put &> /dev/null; then
    alias rm='trash-put'
    trash-empty 50
fi
#function find4mac(){ find $@ -print0 }
#function xargs4mac(){ xargs -0 $@ }

if [ $os = mac ];then
    export PS1="%F{green}${USER}@${HOST%%.*}%f:%F{blue}%0~%f%(!.#.$) "
    export LSCOLORS=exgxcxdxcxegedabagacad

    alias ls='ls -G'
    alias gcc=/usr/local/bin/gcc-9
    alias g++=/usr/local/bin/g++-9

    # Tex Live
    export MANPATH=$MANPATH:/usr/local/texlive/2019/texmf-dist/doc/man
    export INFOPATH=$INFOPATH:/usr/local/texlive/2019/texmf-dist/doc/info
    export PATH=$PATH:/usr/local/texlive/2019/bin/x86_64-darwin

    if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
        export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
        export WORKON_HOME=/Users/matsumoto/.venvs
        source /usr/local/bin/virtualenvwrapper.sh
    fi
fi

