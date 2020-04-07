#!/usr/bin/env bash

if   [ "$(uname -s)" = "Darwin" ]; then os=mac
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then os=windows
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then os=linux
else os=unknown
fi

wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xzvf install-tl-unx.tar.gz
cd install-tl*
sudo ./install-tl -no-gui -repository http://mirror.ctan.org/systems/texlive/tlnet/
if [ $? != 0 ]; then
    echo "install failed! if you want to install tex from middle, please try 'sudo ./install-tl -no-gui -profile installation.profile'"
    exit 1
fi

# make simbolic to /usr/local/bin/
sudo /usr/local/texlive/????/bin/*/tlmgr path add

if [ $? == 0 ]; then
    echo "Successfully installed TexLive!"
else
    echo "installation failed!"
    exit 1
fi
cd ..
rm -rf install-tl-*

if [ $os = mac ];then
    # setting for embedding hiragino to pdf
    echo "Set hiragino font for font embedding"
    sudo tlmgr update --self --all
    sudo tlmgr repository add http://contrib.texlive.info/current tlcontrib
    sudo tlmgr pinning add tlcontrib '*'
    sudo tlmgr install japanese-otf-nonfree japanese-otf-uptex-nonfree ptex-fontmaps-macos cjk-gs-integrate-macos
    sudo tlmgr install cjk-gs-integrate adobemapping
    sudo tlmgr path add
    sudo cjk-gs-integrate --link-texmf --cleanup
    sudo cjk-gs-integrate-macos --link-texmf
    sudo mktexlsr
    sudo kanji-config-updmap-sys --jis2004 hiragino-highsierra-pron

    if [ $? == 0 ]; then
        echo "Set hiragino Done"
    else
        echo "font embedding setting failed!"
        exit 1
    fi
fi
