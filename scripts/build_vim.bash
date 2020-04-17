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

download_and_extract_package(){
    cd $src_dir
    if [ ! -d $3 ]; then
        echo "$3 not found. Check compressed file..."
        if [ ! -f $2 ]; then
            echo "$2 not found. Download compressed file..."
            while [ 1 ];do
                wget --retry-connrefused --waitretry 0 --tries 20 --timeout 3 $1 -O $2
                if [ $? = 0 ];then break 
                fi
            done
        fi
        echo "extract compressed file... : $2"
        tar zxf $2
        echo "Done"
    fi
    if [ $? != 0 ]; then
        echo "Failed in download and extract packages"
        echo "Remove downloaded items..."
        cd $src_dir && rm -rf $3 $2 && echo "Done!"
        exit 1
    fi
}
check_success(){
    if [ $? != 0 ]; then
        echo "Installation failed!"
        exit 1
    fi
    echo "Install Completed!"
}

if [ ! -e $HOME/.local/lua-$lua_ver ]; then
    echo "Installing lua..."
    cd $src_dir
    download_and_extract_package https://www.lua.org/ftp/lua-$lua_ver.tar.gz lua-$lua_ver.tar.gz lua-$lua_ver
    cd lua-$lua_ver
    if [ $os = "mac" ];then
        sed -i .bak "s/INSTALL_TOP= \/usr\/local/INSTALL_TOP= \$\(HOME\)\/.local\/lua-$lua_ver/" Makefile
        make macosx && make install
    elif [ $os = "linux" ]; then
        sed -i "s/INSTALL_TOP= \/usr\/local/INSTALL_TOP= \$\(HOME\)\/.local\/lua-$lua_ver/" Makefile
        make linux && make install
    fi
    check_success
fi

if [ ! -e $HOME/.local/ncurses-$ncurses_ver ]; then
    echo "Install ncurses..."
    cd $src_dir
    download_and_extract_package https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$ncurses_ver.tar.gz ncurses-$ncurses_ver.tar.gz ncurses-$ncurses_ver
    cd ncurses-$ncurses_ver
    ./configure --prefix=$HOME/.local/ncurses-$ncurses_ver --with-shared --with-pkg-config-libdir=$HOME/.local/ncurses-$ncurses_ver/lib/pkgconfig --enable-pc-files
    make -j4 && make install
    check_success
fi

cd $src_dir
if [ ! -e ./vim-$vim_ver ]; then
    if [ ! -e ./vim-$vim_ver.tar.bz2 ]; then
        while true;do
            wget --no-check-certificate --tries=10 --retry-connrefused --waitretry=1 --timeout=10 https://ftp.vim.org/pub/vim/unix/vim-$vim_ver.tar.bz2 -O vim-$vim_ver.tar.bz2
            if [ $? = 0 ]; then break
            fi
        done
    fi
    mkdir vim-$vim_ver
    tar jxvf vim-$vim_ver.tar.bz2 -C vim-$vim_ver --strip-components=1
    if [ $? != 0 ]; then
        rm -rf vim-$vim_ver vim-$vim_ver.tar.bz2
    fi
fi

cd vim-$vim_ver
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

if [ $? != 0 ]; then
    echo "error configurinig. abort"
    exit 1
else
    make -j4 && make install
fi
