#!/bin/zsh
export PS1="%F{green}${USER}@${HOST%%.*}%f:%F{blue}%0~%f%(!.#.$) "

export LSCOLORS=exgxcxdxcxegedabagacad
alias ls='ls -G'

alias gcc=/usr/local/bin/gcc-9
alias g++=/usr/local/bin/g++-9

export CPLUS_INCLUDE_PATH=/usr/local/include/eigen3 # for eigen
