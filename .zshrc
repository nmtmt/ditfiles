#!/usr/bin/env zsh

export PS1="%F{113}${USER}@${HOST%%.*}%f:%F{249}%0~%f%(!.#.$) "
if [ -f $HOME/.termcap ]; then
    export TERMPATH=$HOME/.termcap
fi

in_docker=0
if [ -f /.dockerenv ];then
    in_docker=1
fi
export IN_DOCKER=$in_docker
if [ $IN_DOCKER -eq 1 ]; then
    export DISPLAY=host.docker.internal:0.0
fi

# vim starts slow when DISPLAY variable set and vim cannot reach out X11 server
if uname -r | grep microsoft >/dev/null; then
    unset DISPLAY
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

preffered_cuda_ver="10.2"
has_cuda=false
if [ -d $HOME/.local/cuda-$preffered_cuda_ver ]; then
    CUDA_HOME=$HOME/.local/cuda-$preffered_cuda_ver
    export PATH=$CUDA_HOME/bin:$PATH
    has_cuda=true
elif [ -d /usr/local/cuda-$preffered_cuda_ver ]; then
    CUDA_HOME=/usr/local/cuda-$preffered_cuda_ver
    export PATH=$CUDA_HOME/bin:$PATH
    has_cuda=true
elif [ -d /usr/local/cuda ]; then
    CUDA_HOME=/usr/local/cuda
    export PATH=$CUDA_HOME/bin:$PATH
    has_cuda=true
fi

export PATH=$HOME/.local/bin:$PATH
export CPATH=$HOME/.local/include:$CPATH
export EDITOR=vim
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH

if $has_cuda; then
    export LD_LIBRARY_PATH=$HOME/.local/lib:$CUDA_HOME/lib64:$LD_LIBRARY_PATH
else
    export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
fi

if [ -f $HOME/.aliases ]; then
    source $HOME/.aliases
fi
if [ -f $HOME/.func ]; then
    source $HOME/.func
fi

if [ $(uname -s) = Darwin ] && [ ! -z $HOMEBREW_PREFIX ];then
    # openssl
    export PATH=$HOMEBREW_PREFIX/opt/openssl@1.1/bin:$PATH
    export LD_LIBRARY_PATH=$HOMEBREW_PREFIX/opt/openssl@1.1/lib:$LD_LIBRARY_PATH
    export CPATH=$HOMEBREW_PREFIX/opt/openssl@1.1/include:$CPATH
    export PKG_CONFIG_PATH=$HOMEBREW_PREFIX/opt/openssl@1.1/lib/pkgconfig:$PATH

    # java
    export PATH=$HOMEBREW_PREFIX/opt/openjdk@11/bin:$PATH
    export CPATH=$HOMEBREW_PREFIX/opt/openjdk@11/include:$CPATH
fi

if which trash-empty > /dev/null 2>&1; then
    trash-empty 50
fi

venvshell=$(which virtualenvwrapper.sh 2>&1)
if [ $? -eq 0 ] && [ ! -z $venvshell ] && [ -f $venvshell ]; then
    bindir=$(dirname $venvshell)
    export VIRTUALENVWRAPPER_PYTHON=$bindir/python3
    export WORKON_HOME=$HOME/.venvs
    source $venvshell
    if [ -d $HOME/.venvs/default ];then
        workon default
    fi
fi
