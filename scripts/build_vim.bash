#!/env/bash
#TODO

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

echo "Installing lua..."
cd $src_dir
wget https://www.lua.org/ftp/lua-$lua_ver.tar.gz 
tar zxvf lua-$lua_ver.tar.gz 
cd lua-$lua_ver
if [ $os = "mac" ];then
    sed -i .bak "s/INSTALL_TOP= \/usr\/local/INSTALL_TOP= \$\(HOME\)\/.local\/lua-$lua_ver/" Makefile
    make macosx
elif [ $os = "linux" ]; then
    sed -i "s/INSTALL_TOP= \/usr\/local/INSTALL_TOP= \$\(HOME\)\/.local\/lua-$lua_ver/" Makefile
    make linux
fi
make install
if [ $? != 0 ];then
    echo "installing lua failed! abort..."
    exit 1
else
    echo "Successfully installed lua"
fi

echo "Install ncurses..."
cd $src_dir
wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$ncurses_ver.tar.gz
tar xvfz ncurses-$ncurses_ver.tar.gz
cd ncurses-$ncurses_ver
./configure --prefix=$HOME/.local/ncurses-$ncurses_ver --with-shared --with-pkg-config-libdir=$HOME/.local/ncurses-$ncurses_ver/lib/pkgconfig --enable-pc-files
make
make install
if [ $? != 0 ];then
    echo "installing ncurses failed! abort..."
    exit 1
else
    echo "Successfully installed ncurses"
fi

cd $src_dir
wget ftp://ftp.vim.org/pub/vim/unix/vim-$vim_ver.tar.bz2 -O vim-$vim_ver.tar.bz2
mkdir vim-$vim_ver
tar jxvf vim-$vim_ver.tar.bz2 -C vim-$vim_ver --strip-components=1
cd vim-$vim_ver

./configure \
    --prefix=$PREFIX\
    --with-features=huge \
    --enable-multibyte \
    --enable-gui=auto\
    --enable-pythoninterp=yes \
    --enable-luainterp=yes \
    --enable-perlinterp=yes \
    --with-lua-prefix=$HOME/.local/lua-$lua_ver \
    --enable-cscope \
    --enable-fontset \
    --enable-fail-if-missing \
    #--enable-rubyinterp=yes\
    #--enable-tclinterp=yes\

if [ $? != 0 ]; then
    echo "error configurinig. abort"
    exit 1
else
    make
    make install
fi
