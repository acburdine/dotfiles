#!/bin/bash

cd ~ # ensure we're in home folder

## Add tokens file
touch ~/.dem-tokens && chmod 600 ~/.dem-tokens

## Setup z.sh
mkdir -p ~/bin/z/
git clone https://github.com/rupa/z ~/bin/z/

## Bash Setup
ln -s ~/dotfiles/.bash_profile ~/.bash_profile
source ~/.bash_profile

## NVIM SETUP
mkdir -p ~/.config/nvim/
ln -s ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim

## TMUX SETUP
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
