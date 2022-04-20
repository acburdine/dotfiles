#!/usr/bin/env bash

set -e

brew bundle install --file="$DOTFILES_DIR/apps/Brewfile"
pip3 install neovim

# fish shell config
fishpath=$(which fish)
echo "$fishpath" | sudo tee -a /etc/shells

sudo chsh -s "$fishpath" "$(whoami)"

# set firefox as default browser
defaultbrowser firefox

echo "Downloading MonoLisa font"
open "https://monolisa.dev/orders"

read -p "Press Enter once font has been downloaded"

mkdir -p "$HOME/Downloads/MonoLisa-personal"
unzip -d "$HOME/Downloads/MonoLisa-personal" "$HOME/Downloads/MonoLisa-personal.zip"

set +e
docker run -it -v "$HOME/Downloads/MonoLisa-personal/ttf:/in" -v "$HOME/Downloads/MonoLisa-patched:/out" --rm nerdfonts/patcher -c --careful -q
set -e

open $HOME/Downloads/MonoLisa-patched/*.ttf
