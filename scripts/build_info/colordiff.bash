#!/usr/bin/env bash
https://www.colordiff.org/colordiff-1.0.19.tar.gz
ver="1.0.19"
url=https://www.colordiff.org/colordiff-$ver.tar.gz
pkg_tarname=colordiff-$ver.tar.gz
pkg_dirname=colordiff-$ver
commands(){
    case $OSTYPE in
        darwin*);
            sed -i .bak -e 's/$(INSTALL) -Dm/$(INSTALL) -m/g' Makefile
            ;;
        *);
            ;;
    esac
    make install DESTDIR=$HOME/.local INSTALL_DIR=/bin MAN_DIR=/man/man1
}
