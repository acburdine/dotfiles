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
install_thing python3

## Pip3 Setup
## NOTE: on macOS this will be installed alongside python3 with brew
## On Ubuntu, we need to install it separately
if ! hash pip3 2>/dev/null; then
  install_thing python3-pip
fi

# fish setup
install_thing fish
fishpath=$(which fish)
echo "$fishpath" | sudo tee -a /etc/shells

sudo chsh -s "$fishpath" "$(whoami)"

# skip running this in GH Codespaces since it seems to break things
fish "$DOTFILES_DIR/fish/setup.fish"

if [ $GIT_INSTALLED -eq 1 ]; then
  fish "$DOTFILES_DIR/git/setup.fish"
fi

# Neovim setup
install_thing neovim
pip3 install neovim

fish "$DOTFILES_DIR/nvim/setup.fish"

## TMUX SETUP
install_thing tmux

fish "$DOTFILES_DIR/tmux/setup.fish"

if [ -n "$CODESPACES" ]; then
  wall "dotfiles setup complete"
fi
