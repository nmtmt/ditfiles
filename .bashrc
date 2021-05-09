# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=10000

set bell-style none

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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

if [ -z $SHELL ];then
    export SHELL=`which bash`
fi

# enable color support of ls and also add handy aliases
if [ -f $HOME/.dircolors ]; then
    if type dircolors > /dev/null 2>&1; then
        eval $(dircolors $HOME/.dircolors)
    elif type gdircolors > /dev/null 2>&1; then
        eval $(gdircolors $HOME/.dircolors)
    fi
fi

if [ -z $LANG ];then
    export LANG=ja_JP.UTF-8
fi

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

if $has_cuda; then
    export LD_LIBRARY_PATH=$HOME/.local/lib:$CUDA_HOME/lib64:$LD_LIBRARY_PATH
    export PATH=$CUDA_HOME/bin:$PATH
else
    export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
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

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f $HOME/.aliases ]; then
    source $HOME/.aliases
fi
if [ -f $HOME/.func ]; then
    source $HOME/.func
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ ! -z $XDG_CURRENT_DESKTOP ] && [ ! -z $DISPLAY ];then
    source $HOME/.xprofile
fi

# use host display in WSL2
if [ $(uname -s) = Linux ] && [[ $(uname -r) = *microsoft* ]];then
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
fi

if which trash-empty > /dev/null 2>&1; then
    trash-empty 50
fi

venvshell=$(which virtualenvwrapper.sh)
if [ -f $venvshell ]; then
    bindir=$(dirname $venvshell)
    export VIRTUALENVWRAPPER_PYTHON=$bindir/python3
    export WORKON_HOME=$HOME/.venvs
    source $venvshell
    if [ -d $HOME/.venvs/default ];then
        workon default
    fi
fi
