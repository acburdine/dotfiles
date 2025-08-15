#!/bin/bash

# first, make sure we're in the home dir
cd ~

# second, clone the repo
git clone https://github.com/acburdine/dotfiles dotfiles

# third, cd into dotfiles repo
cd ~/dotfiles

# lastly, start setup script
bash ./setup.sh $1