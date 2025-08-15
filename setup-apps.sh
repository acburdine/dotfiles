#!/usr/bin/env bash

set -e

brew bundle install --file="$DOTFILES_DIR/apps/Brewfile"

# fish shell config
fishpath=$(which fish)
if ! grep -q "$fishpath" < /etc/shells; then
  echo "$fishpath" | sudo tee -a /etc/shells
  sudo chsh -s "$fishpath" "$(whoami)"
fi

if [ "${SETUP_PROFILE}" = "personal" ]; then
  if ! defaultbrowser | grep -q "^\* firefox"; then
    echo "setting firefox as default browser"
    # set firefox as default browser
    defaultbrowser firefox
  fi
fi
