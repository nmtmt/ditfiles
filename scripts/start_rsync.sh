#!/bin/sh
while true;
do
    rsync -avus --copy-unsafe-links $HOME/tmp/ matsumoto@133.9.192.12:strage/tmp/
    sleep 60
done
