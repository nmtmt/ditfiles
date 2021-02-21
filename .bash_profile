#!/bin/bash

# require .bash_profile or .bash_login or .profile which source bashrc
# because tmux won't load bashrc with new session
if [ -f $HOME/.bashrc ];then
    source $HOME/.bashrc
fi
