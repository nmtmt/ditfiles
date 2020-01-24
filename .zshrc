#!/bin/zsh

export PS1="%F{green}${USER}@${HOST%%.*}%f:%F{blue}%0~%f%(!.#.$) "
export LSCOLORS=exgxcxdxcxegedabagacad

alias ls='ls -G'
alias rm='trash-put'

