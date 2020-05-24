#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

function dotfiles_setup_prompt {
  read -p "${1}: " val
  printf $val
}

## MACOS Defaults

if [ "$(uname)" == "Darwin" ]; then
  # Key Repeat
  defaults write -g InitialKeyRepeat -int 10 # 150 ms
  defaults write -g KeyRepeat -int 2 # 15 ms

  # Tap to Click
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write 'Apple Global Domain' com.apple.mouse.tapBehavior 1

  # Disable "Are you sure you want to open this application" dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Disable Resume system-wide
  defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

  # Disable Notification Center and remove the menu bar icon
  launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

  # Increase sound quality for Bluetooth headphones/headsets
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

  # Disable the warning before emptying the Trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  # Install One Dark itermcolors theme
  open "${DOTFILES_DIR}/theme/One Dark.itermcolors"
fi

cd ~ # ensure we're in home folder

## Git Config
if [ ! -f "${HOME}/.gitconfig" ]; then
  GIT_COMMIT_EMAIL=$(dotfiles_setup_prompt "Git Commit Email")
  GIT_CONFIG_FILE=$(cat $DOTFILES_DIR/git/gitconfig | sed "s/{{COMMIT_EMAIL}}/${GIT_COMMIT_EMAIL}/;s/{{DOTFILES_DIR}}/${DOTFILES_DIR//\//\\/}/")
  echo "$GIT_CONFIG_FILE" > ~/.gitconfig
else
  echo "~/.gitconfig already exists, skipping"
fi

## Add tokens file
if [ ! -f "${HOME}/.dem-tokens" ]; then
  touch ~/.dem-tokens && chmod 600 ~/.dem-tokens
else
  echo ".dem-tokens file already exists, skipping"
fi

## Setup z.sh
if [ ! -d "${HOME}/bin/z" ]; then
  mkdir -p ~/bin/z/
  git clone https://github.com/rupa/z ~/bin/z/
else
  echo "z is already installed, skipping"
fi

## Brew Setup
if ! hash brew 2>/dev/null; then
  echo "Homebrew not found, installing it"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if [ ! -f "/usr/local/etc/bash_completion" ]; then
  echo "bash_completion not installed, installing it"
  brew install bash-completion
fi

## Bash Profile Setup (deprecated)
if [ ! -f "${HOME}/.bash_profile" ]; then
  ln -s $DOTFILES_DIR/.bash_profile ~/.bash_profile
  source ~/.bash_profile
else
  echo "~/.bash_profile already exists, skipping"
fi

## install fish
if ! hash fish 2>/dev/null; then
  echo "fish not found, installing it"
  brew install fish
fi

## Fish config
if [ ! -f "$HOME/.config/fish/config.fish" ]; then
  mkdir -p ~/.config/fish/
  ln -s $DOTFILES_DIR/fish/config.fish ~/.config/fish/config.fish
  ln -s $DOTFILES_DIR/fish/functions/*.fish ~/.config/fish/functions/
else
  echo "fish config already installed"
fi

## Python Setup (Needed for NeoVim)
if ! hash python3 2>/dev/null; then
  echo "python3 not found, installing it"
  brew install python3
fi

## NVIM SETUP
if ! hash nvim 2>/dev/null; then
  echo "nvim not found, installing it"
  brew install nvim
  pip3 install neovim
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -f "${HOME}/.config/nvim/init.vim" ]; then
  mkdir -p ~/.config/nvim/
  ln -s $DOTFILES_DIR/nvim/init.vim ~/.config/nvim/init.vim
  nvim /tmp/vimfile.txt +PlugInstall +UpdateRemotePlugins +qall
else
  echo "nvim config already exists, skipping"
fi

## TMUX SETUP
if ! hash tmux 2>/dev/null; then
  echo "tmux not found, installing it"
  brew install tmux
fi

if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
  echo "tpm not found, installing it"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -f "${HOME}/.tmux.conf" ]; then
  ln -s $DOTFILES_DIR/tmux/tmux.conf ~/.tmux.conf
  tmux new -d -s tmp
  tmux send -t tmp.0 ~/.tmux/plugins/tpm/bin/install_plugins ENTER
  tmux kill-session -t tmp
else
  echo "tmux config already exists, skipping"
fi
