#!/bin/bash

echo "Install packages which don't require sudo privilege"

echo "Installing vim..."
bash build_vim.bash
echo "Done!"

echo "Installing ruby..."
bash build_ruby.bash
echo "Done!"
