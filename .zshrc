#!/usr/bin/env zsh

export LANG="en_US.UTF-8"
export PS1="%F{113}${USER}@${HOST%%.*}%f:%F{249}%0~%f%(!.#.$) "
if [ -f $HOME/.termcap ]; then
    export TERMPATH=$HOME/.termcap
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
if $has_cuda; then
    export LD_LIBRARY_PATH=$HOME/.local/lib:$CUDA_HOME/lib64:$LD_LIBRARY_PATH
else
    export LD_LIBRARY_PATH=$HOME/.local:$LD_LIBRARY_PATH
fi
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH

if [ -f /Applications/MacVim.app/Contents/bin/gvim ]; then
    alias gvim="/Applications/MacVim.app/Contents/bin/gvim"
fi
if which trash-put > /dev/null 2>&1; then
    alias rm='trash-put'
    trash-empty 50
fi
alias mux='tmuxinator'
if which colordiff > /dev/null 2>&1; then
    alias diff='colordiff -u'
fi
if which gsed > /dev/null 2>&1; then
    alias sed='gsed'
fi
if which gln > /dev/null 2>&1; then
    alias ln='gln'
fi

if which nvim > /dev/null 2>&1 && [ -f $HOME/.config/nvim/init.vim ];then
    alias vim='nvim'
fi

if [[ $OSTYPE = linux* ]] &&  [ -d /mnt/c/Program\ Files ]; then
    d=$(find /mnt/c/Program\ Files -maxdepth 1 -type d -name 'vim*-kaoriya-win64')
    if [ $? = 0 ]; then
        str=$(echo $d | sed 's/\ /\\\ /g')
        alias gvim="$str/gvim.exe"
    fi
elif [[ $OSTYPE = linux* ]]; then
    # gvim not work well with fcitx(not show unconverted kana when using gvim)
    # Also enable convert im method to direct input with Esc
    # alias gvim='vim -g'
    alias gvim='nvim-qt'
fi

if [ -f $HOME/.local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON=$HOME/.local/bin/python3
    export WORKON_HOME=$HOME/.venvs
    source $HOME/.local/bin/virtualenvwrapper.sh
    if [ -f $(pwd)/setup.zsh ];then
        # useful when open ros catkin_workspace
        source $(pwd)/setup.zsh
    else
        if [ -d $HOME/.venvs/default ]; then workon default; fi
    fi
elif [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON=$(which python3)
    export WORKON_HOME=$HOME/.venvs
    source /usr/local/bin/virtualenvwrapper.sh
    if [ -f $(pwd)/setup.zsh ];then
        # useful when open ros catkin_workspace
        source $(pwd)/setup.zsh
    else
        if [ -d $HOME/.venvs/default ]; then workon default; fi
    fi
fi
