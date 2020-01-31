#!/bin/sh

# required packages
sudo apt install curl

# download install script and execute it
mkdir -p ~/.vim/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh installer.sh ~/.vim/.cache/dein
rm installer.sh

# link dotfiles
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.latexmkrc ~/.latexmkrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.unixenv ~/.unixenv
ln -sf ~/dotfiles/.macenv ~/.macenv
ln -sf ~/dotfiles/select_termenv ~/select_termenv
