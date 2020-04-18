#!/bin/bash

check_installed()
{
    if [ $? = 0 ]; then
        echo "Success in run script : $1"
    else
        echo "Failed to run script : $1"
        echo "Abort"
        exit 1
    fi
}

script_dir=$(cd $(dirname $0); pwd)
echo "Install packages which don't require sudo privilege"

echo "Installing packages for compression..."
bash $script_dir/build_compress_pkgs.bash
check_installed  "build_compress_pkgs.bash"

echo "Installing ruby..."
bash $script_dir/build_ruby.bash
check_installed "build_ruby.bash"

echo "Install Python..."
bash $script_dir/build_python.bash
check_installed "build_python.bash"

echo "Installing vim..."
bash $script_dir/build_vim.bash
check_installed  "build_vim.bash"
