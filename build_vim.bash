#!/env/bash

PREFIX=$HOME/.local
VIM_HOME=$PREFIX/vim
VIM_VERSION="v8.2.0520"

#git clone https://github.com/vim/vim.git $VIM_HOME
cd $VIM_HOME
#git checkout refs/tags/$VIM_VERSION


./configure\
    --prefix=$PREFIX\
    --with-features=huge \
    --enable-multibyte \
    --enable-gui=auto\
    --enable-pythoninterp=yes \
    --enable-tclinterp=yes\
    --enable-luainterp=yes \
    --enable-perlinterp=yes \
    --with-lua-prefix=/usr \
    --enable-gpm \
    --enable-cscope \
    --enable-fontset \
    --enable-fail-if-missing
    #--enable-rubyinterp=yes\

make
make install
