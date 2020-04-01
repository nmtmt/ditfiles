#!/bin/zsh

export PS1="%F{green}${USER}@${HOST%%.*}%f:%F{blue}%0~%f%(!.#.$) "
export LSCOLORS=exgxcxdxcxegedabagacad

alias ls='ls -G'

if which trash-put &> /dev/null; then
    alias rm='trash-put'
    trash-empty 50
fi

function find4mac(){ find $@ -print0 }
#alias find='find4mac'
function xargs4mac(){ xargs -0 $@ }
#alias xargs='xargs4mac'

alias gcc=/usr/local/bin/gcc-9
alias g++=/usr/local/bin/g++-9

# Tex Live
export MANPATH=$MANPATH:/usr/local/texlive/2019/texmf-dist/doc/man
export INFOPATH=$INFOPATH:/usr/local/texlive/2019/texmf-dist/doc/info
export PATH=$PATH:/usr/local/texlive/2019/bin/x86_64-darwin

if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3.7
    export VIRTUALENVWRAPPER_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi
