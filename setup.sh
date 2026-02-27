#!/bin/bash

# Clone neovim configuration
if [ ! -d nvim ]; then
    git clone --recursive https://github.com/Pencilcaseman/nvim-config.git nvim
fi

# Symlink tmux configuration
if [ ! -e $HOME/.tmux.conf ]; then
    ln -s tmux/.tmux.conf $HOME/.tmux.conf
fi
