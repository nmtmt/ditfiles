#!/usr/bin/env bash
ps -ef -o user:10,comm | grep -q "$USER.*lsyncd*" 
if [ $? != 0 ]; then
    lsyncd -nodaemon -log scarce $HOME/.lsyncd_local.conf
fi
