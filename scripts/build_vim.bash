#!/env/bash

PREFIX=$HOME/.local
vim_ver="8.2"
lua_ver="5.3.5"
ncurses_ver="6.1"

src_dir=$HOME/.local/src
if [ ! -e $src_dir ]; then
    mkdir -p $src_dir
fi

if   [ "$(uname -s)" = "Darwin" ]; then os=mac
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then os=linux
else os=unknown
fi

if [ ! -e $HOME/.local/lua-$lua_ver ]; then
    echo "Installing lua..."
    cd $src_dir
    if [ ! -e ./lua-$lua_ver ]; then
        if [ ! -e ./lua-$lua_ver.tar.gz ]; then
            wget https://www.lua.org/ftp/lua-$lua_ver.tar.gz -t 10
        fi
        tar zxvf lua-$lua_ver.tar.gz 
    fi
    cd lua-$lua_ver
    if [ $os = "mac" ];then
        sed -i .bak "s/INSTALL_TOP= \/usr\/local/INSTALL_TOP= \$\(HOME\)\/.local\/lua-$lua_ver/" Makefile
        make macosx && make install
    elif [ $os = "linux" ]; then
        sed -i "s/INSTALL_TOP= \/usr\/local/INSTALL_TOP= \$\(HOME\)\/.local\/lua-$lua_ver/" Makefile
        make linux && make install
    fi
    if [ $? != 0 ];then
        echo "installing lua failed! abort..."
        exit 1
    else
        echo "Successfully installed lua"
    fi
fi

if [ ! -e $HOME/.local/ncurses-$ncurses_ver ]; then
    echo "Install ncurses..."
    cd $src_dir
    if [ ! -e ./ncurses-$ncurses_ver ]; then
        if [ ! -e ./ncurses-$ncurses_ver.tar.gz ]; then
            wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$ncurses_ver.tar.gz -t 10
        fi
        tar xvfz ncurses-$ncurses_ver.tar.gz
    fi
    cd ncurses-$ncurses_ver
    ./configure --prefix=$HOME/.local/ncurses-$ncurses_ver --with-shared --with-pkg-config-libdir=$HOME/.local/ncurses-$ncurses_ver/lib/pkgconfig --enable-pc-files
    make && make install
    if [ $? != 0 ];then
        echo "installing ncurses failed! abort..."
        exit 1
    else
        echo "Successfully installed ncurses"
    fi
fi

cd $src_dir
if [ ! -e ./vim-$vim_ver ]; then
    if [ ! -e ./vim-$vim_ver.tar.bz2 ]; then
        wget --no-check-certificate --tries=10 --retry-connrefused --waitretry=1 --timeout=10 https://ftp.vim.org/pub/vim/unix/vim-$vim_ver.tar.bz2 -O vim-$vim_ver.tar.bz2
    fi
    mkdir vim-$vim_ver
    tar jxvf vim-$vim_ver.tar.bz2 -C vim-$vim_ver --strip-components=1
    if [ $? != 0 ]; then
        rm -rf vim-$vim_ver vim-$vim_ver.tar.bz2
    fi
fi

cd vim-$vim_ver
<< com
./configure \
    --prefix=$PREFIX\
    --with-features=huge \
    --with-local-dir=$HOME/.local \
    --enable-multibyte \
    --enable-gui=auto \
    --enable-pythoninterp=yes \
    --enable-python3interp=yes \
    --enable-luainterp=yes \
    --enable-rubyinterp=yes\
    --enable-perlinterp=auto \
    --with-lua-prefix=$HOME/.local/lua-$lua_ver \
    --enable-cscope \
    --enable-fontset \
    --enable-fail-if-missing \
    #--enable-tclinterp=yes\

com

if [ $? != 0 ]; then
    echo "error configurinig. abort"
    exit 1
else
    make && make install
fi
