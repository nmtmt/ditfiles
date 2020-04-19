#!/usr/bin/env zsh

cuda_ver="10.0"
if [ -d $HOME/.local/cuda-$cuda_ver ]; then
    CUDA_HOME=$HOME/.local/cuda-$cuda_ver
elif [ -d /usr/local/cuda-$cuda_ver ]; then
    CUDA_HOME=/usr/local/cuda-$cuda_ver
fi

export PATH=$HOME/.local/bin:$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:$CUDA_HOME/lib64:$LD_LIBRARY_PATH

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
