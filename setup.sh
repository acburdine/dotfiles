#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if [ "$(uname)" == "Darwin" ]; then
  source "$DOTFILES_DIR/setup-mac.sh"
elif [ "$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d \")" == "Ubuntu" ]; then
  source "$DOTFILES_DIR/setup-ubuntu.sh"
else
  echo "only macos and ubuntu distros are currently supported" && exit 1
fi

cd "$HOME" || exit # ensure we're in home folder

GIT_INSTALLED=0

# Git
if ! hash git 2>/dev/null; then
  install_thing git
  GIT_INSTALLED=1
fi

## Python Setup (Needed for NeoVim)
if ! hash python3 2>/dev/null; then
  install_thing python3
fi

## Pip3 Setup
## NOTE: on macOS this will be installed alongside python3 with brew
## On Ubuntu, we need to install it separately
if ! hash pip3 2>/dev/null; then
  install_thing python3-pip
fi

## install fish
if ! hash fish 2>/dev/null; then
  install_thing fish
  fishpath=$(which fish)
  echo "$fishpath" | sudo tee -a /etc/shells
  chsh -s "$fishpath"

  fish "$DOTFILES_DIR/fish/setup.fish"
fi

if [ $GIT_INSTALLED -eq 1 ]; then
  fish "$DOTFILES_DIR/git/setup.fish"
fi

## NVIM SETUP
if ! hash nvim 2>/dev/null; then
  install_thing neovim
  pip3 install neovim

  fish "$DOTFILES_DIR/nvim/setup.fish"
fi

## TMUX SETUP
if ! hash tmux 2>/dev/null; then
  install_thing tmux

  fish "$DOTFILES_DIR/tmux/setup.fish"
fi
