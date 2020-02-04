#!/bin/zsh

export PS1="%F{green}${USER}@${HOST%%.*}%f:%F{blue}%0~%f%(!.#.$) "
export LSCOLORS=exgxcxdxcxegedabagacad

alias ls='ls -G'
alias rm='trash-put'

# Tex Live
export MANPATH=$MANPATH:/usr/local/texlive/2019/texmf-dist/doc/man
export INFOPATH=$INFOPATH:/usr/local/texlive/2019/texmf-dist/doc/info
export PATH=$PATH:/usr/local/texlive/2019/bin/x86_64-darwin

if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3.7
    export VIRTUALENVWRAPPER_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi
