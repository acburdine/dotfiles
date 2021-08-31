#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

function dotfiles_setup_prompt {
  read -rp "${1}: " val
  printf '%s' "$val"
}

## MACOS Defaults

if [ "$(uname)" == "Darwin" ]; then
  source "$DOTFILES_DIR/setup-mac.sh"
elif [ "$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d \")" == "Ubuntu" ]; then
  source "$DOTFILES_DIR/setup-ubuntu.sh"
else
  echo "only macos and ubuntu distros are currently supported" && exit 1
fi

cd ~ || exit # ensure we're in home folder

## Git Config
if [ ! -f "${HOME}/.gitconfig" ]; then
  GIT_COMMIT_EMAIL=$(dotfiles_setup_prompt "Git Commit Email")
  GIT_CONFIG_FILE=$(sed "s/{{COMMIT_EMAIL}}/${GIT_COMMIT_EMAIL}/;s/{{DOTFILES_DIR}}/${DOTFILES_DIR//\//\\/}/" <"$DOTFILES_DIR/git/gitconfig")
  echo "$GIT_CONFIG_FILE" >~/.gitconfig
else
  echo "$HOME/.gitconfig already exists, skipping"
fi

## Add tokens file
if [ ! -f "${HOME}/.dem-tokens" ]; then
  touch ~/.dem-tokens && chmod 600 ~/.dem-tokens
else
  echo "$HOME/.dem-tokens file already exists, skipping"
fi

## Setup z.sh
if [ ! -d "${HOME}/bin/z" ]; then
  mkdir -p ~/bin/z/
  git clone https://github.com/rupa/z ~/bin/z/
else
  echo "z is already installed, skipping"
fi

if [ ! -f "/usr/local/etc/bash_completion" ] && [ ! -f "/etc/bash_completion" ]; then
  echo "bash_completion not installed, installing it"
  install_thing bash-completion
fi

## Bash Profile Setup (deprecated)
if [ ! -f "${HOME}/.bash_profile" ]; then
  ln -s "$DOTFILES_DIR/.bash_profile" ~/.bash_profile

  # shellcheck source=./.bash_profile
  source ~/.bash_profile
else
  echo "$HOME/.bash_profile already exists, skipping"
fi

## install fish
if ! hash fish 2>/dev/null; then
  echo "fish not found, installing it"
  install_thing fish
  fishpath=$(which fish)
  echo "$fishpath" | sudo tee -a /etc/shells
  chsh -s "$fishpath"
fi

## Fish config
if [ ! -f "$HOME/.config/fish/config.fish" ]; then
  mkdir -p ~/.config/fish/
  ln -s "$DOTFILES_DIR/fish/config.fish" ~/.config/fish/config.fish
  ln -s "$DOTFILES_DIR/fish/functions/*.fish" ~/.config/fish/functions/
else
  echo "fish config already installed"
fi

## install oh-my-fish
if [ ! -d "${HOME}/.local/share/omf" ]; then
  echo "omf not installed, installing it"
  curl -L https://get.oh-my.fish >/tmp/omf-install
  fish /tmp/omf-install --noninteractive -y
  fish ./fish/omf-setup.fish
fi

## setup z.fish
if [ ! -d "${HOME}/bin/z-fish" ]; then
  git clone https://github.com/sjl/z-fish ~/bin/z-fish
else
  echo "z-fish already installed"
fi

## Python Setup (Needed for NeoVim)
if ! hash python3 2>/dev/null; then
  echo "python3 not found, installing it"
  install_thing python3
fi

## NVIM SETUP
if ! hash nvim 2>/dev/null; then
  echo "nvim not found, installing it"
  install_thing neovim
  pip3 install neovim
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -f "${HOME}/.config/nvim/init.vim" ]; then
  mkdir -p ~/.config/nvim/
  ln -s "$DOTFILES_DIR/nvim/init.vim" ~/.config/nvim/init.vim
  ln -s "$DOTFILES_DIR/nvim/ftplugin" ~/.config/nvim/ftplugin
  nvim /tmp/vimfile.txt +PlugInstall +UpdateRemotePlugins +qall
else
  echo "nvim config already exists, skipping"
fi

## TMUX SETUP
if ! hash tmux 2>/dev/null; then
  echo "tmux not found, installing it"
  install_thing tmux
fi

if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
  echo "tpm not found, installing it"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -f "${HOME}/.tmux.conf" ]; then
  ln -s "$DOTFILES_DIR/tmux/tmux.conf" ~/.tmux.conf
  tmux new -d -s tmp
  tmux send -t tmp.0 ~/.tmux/plugins/tpm/bin/install_plugins ENTER
  tmux kill-session -t tmp
else
  echo "tmux config already exists, skipping"
fi
