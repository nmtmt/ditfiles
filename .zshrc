#!/usr/bin/env zsh

export PS1="%F{113}${USER}@${HOST%%.*}%f:%F{249}%0~%f%(!.#.$) "
if [ -f $HOME/.termcap ]; then
    export TERMPATH=$HOME/.termcap
fi

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

bindkey -e
bindkey "^[[3~" delete-char # Fn + backspace as forward-delete

cuda_ver="10.2"
has_cuda=false
if [ -d $HOME/.local/cuda-$cuda_ver ]; then
    CUDA_HOME=$HOME/.local/cuda-$cuda_ver
    has_cuda=true
elif [ -d /usr/local/cuda-$cuda_ver ]; then
    CUDA_HOME=/usr/local/cuda-$cuda_ver
    has_cuda=true
fi

export PATH=$HOME/.local/bin:$CUDA_HOME/bin:$PATH
export CPATH=$HOME/.local/include:$CPATH
export EDITOR=vim
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH

if $has_cuda; then
    export LD_LIBRARY_PATH=$HOME/.local/lib:$CUDA_HOME/lib64:$LD_LIBRARY_PATH
else
    export LD_LIBRARY_PATH=$HOME/.local:$LD_LIBRARY_PATH
fi

if [ -f $HOME/.aliases ]; then
    source $HOME/.aliases
fi

if which trash-empty > /dev/null 2>&1; then
    trash-empty 50
fi

if [ -f $HOME/.local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON=$HOME/.local/bin/python3
    export WORKON_HOME=$HOME/.venvs
    source $HOME/.local/bin/virtualenvwrapper.sh
    if [ -d $HOME/.venvs/default ];then
        workon default
    fi
elif [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON=$(which python3)
    export WORKON_HOME=$HOME/.venvs
    source /usr/local/bin/virtualenvwrapper.sh
    if [ -d $HOME/.venvs/default ];then
        workon default
    fi
fi
