#!/bin/bash
ver="5.3.5"
url=https://www.lua.org/ftp/lua-$ver.tar.gz
pkg_tarname=lua-$ver.tar.gz
pkg_dirname=lua-$ver
commands(){
    case ${OSTYPE} in 
        darwin*) 
            sed -i .bak "s/INSTALL_TOP= \/usr\/local/INSTALL_TOP= $(HOME)\/.local\/lua-$ver/" Makefile
            make macosx && make install 
            ;; 
        linux*) 
            sed -i "s/INSTALL_TOP= \/usr\/local/INSTALL_TOP= $(HOME)\/.local\/lua-$ver/" Makefile
            make linux && make install
            ;; 
    esac
}
