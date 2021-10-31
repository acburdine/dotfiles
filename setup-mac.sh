#!/bin/bash

echo "
----------------------------------
acburdine's dotfiles - macOS setup
----------------------------------
"

# macOS specific setup

echo "checking that xcode-select is installed"
if [ -z "$(xcode-select -p)" ]; then
  echo "xcode-select not installed, installing it now..."
  xcode-select --install
fi

# Key Repeat
defaults write -g InitialKeyRepeat -int 10 # 150 ms
defaults write -g KeyRepeat -int 2         # 15 ms

# Tap to Click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write 'Apple Global Domain' com.apple.mouse.tapBehavior 1

# Disable "Are you sure you want to open this application" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2>/dev/null

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Install One Dark itermcolors theme
open "${DOTFILES_DIR}/theme/One Dark.itermcolors"

echo "checking if aws-cli is installed"
if ! hash aws 2>/dev/null; then
  echo "aws-cli not found, installing it now..."

  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "/tmp/AWSCLIV2.pkg"
  sudo installer -pkg /tmp/AWSCLIV2.pkg -target /
  rm /tmp/AWSCLIV2.pkg
fi
