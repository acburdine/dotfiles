#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if [ "$(uname)" == "Darwin" ]; then
  source "$DOTFILES_DIR/setup-mac.sh"
elif [ "$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d \")" == "Ubuntu" ]; then
  export CI=1
  source "$DOTFILES_DIR/setup-ubuntu.sh"
else
  echo "only macOS and Ubuntu distros are currently supported." && exit 1
fi

echo "checking if brew is installed"
if ! hash brew 2>/dev/null; then
  echo "brew not found, installing it now..."

  # note: the CI env var here is to make it non-interactive
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # temporary path modification so that brew is available later on in the script
  # brew itself will be available after setup via the fish config
  export PATH=/usr/local/bin:/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:$PATH
  eval "$(brew shellenv)"
fi

cd "$HOME" || exit # ensure we're in home folder

echo "installing apps"

if [ "$(uname)" == "Darwin" ]; then
  source "$DOTFILES_DIR/setup-apps.sh"
fi

echo "running individual setup scripts for different tools"
fish "$DOTFILES_DIR/fish/setup.fish"
fish "$DOTFILES_DIR/git/setup.fish"
fish "$DOTFILES_DIR/nvim/setup.fish"
fish "$DOTFILES_DIR/tmux/setup.fish"
fish "$DOTFILES_DIR/misc-config/setup.fish"
