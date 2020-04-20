#!/bin/bash
ver="5.3.5"
url=https://www.lua.org/ftp/lua-$ver.tar.gz
pkg_tarname=lua-$ver.tar.gz
pkg_dirname=lua-$ver
commands(){
    case ${OSTYPE} in 
        darwin*) 
            sed -i .bak -e "s/INSTALL_TOP= \/usr\/local/INSTALL_TOP= \$\(HOME\)\/.local\/lua-$ver/" Makefile
            if [ $? != 0 ];then
                echo "Failed to change install directory"
                return 1
            fi
            make macosx && make install 
            ;; 
        linux*) 
            sed -i -e "s/INSTALL_TOP= \/usr\/local/INSTALL_TOP= \$\(HOME\)\/.local\/lua-$ver/" Makefile
            if [ $? != 0 ];then
                echo "Failed to change install directory"
                return 1
            fi
            make linux && make install
            ;; 
    esac
}
