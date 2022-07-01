#!/usr/bin/env bash

set -e

brew bundle install --file="$DOTFILES_DIR/apps/Brewfile"
pip3 install neovim

# ensure node 16 gets installed
# TODO: update to node 18 whenever that becomes necessary
brew link node@16 --force --overwrite

# fish shell config
fishpath=$(which fish)
if ! cat /etc/shells | grep -q "$fishpath"; then
  echo "$fishpath" | sudo tee -a /etc/shells
  sudo chsh -s "$fishpath" "$(whoami)"
fi

if ! defaultbrowser | grep -q "^\* firefox"; then
  echo "setting firefox as default browser"
  # set firefox as default browser
  defaultbrowser firefox
fi

# Install One Dark itermcolors theme
open "${DOTFILES_DIR}/theme/One Dark.itermcolors"

if ! ls ~/Library/Fonts | grep -q "MonoLisa"; then
  echo "Downloading MonoLisa font"
  open "https://monolisa.dev/orders"

  read -p "Press Enter once font has been downloaded"

  monolisa_file=$(ls ~/Downloads | grep '^MonoLisa.*\.zip$' | sort -nk 4 | head -1)

  mkdir -p "$HOME/Downloads/MonoLisa"
  unzip -d "$HOME/Downloads/MonoLisa" "$monolisa_file"

  set +e
  docker run -it -v "$HOME/Downloads/MonoLisa:/in" -v "$HOME/Downloads/MonoLisa-patched:/out" --rm nerdfonts/patcher -c --careful -q
  set -e

  open $HOME/Downloads/MonoLisa-patched/*.ttf
fi
