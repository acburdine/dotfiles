#!/bin/bash

cd ~ # ensure we're in home folder

## NVIM SETUP
mkdir -p ~/.config/nvim/
ln -s ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim

## TMUX SETUP
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
