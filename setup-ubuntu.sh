#!/bin/bash

# fix for containers
if ! hash sudo 2>/dev/null && [ "$EUID" -eq 0 ]; then
  echo "installing sudo"
  apt-get update >/dev/null 2>/dev/null && apt-get install -qq -y sudo >/dev/null 2>/dev/null
fi

function install_thing {
  if [ -z "$1" ]; then echo "must specify something to install" && exit 1; fi
  echo "installing $1"
  sudo apt-get install -y "$1" >/dev/null 2>/dev/null
}

# fix for missing add-apt-repository command
if ! hash add-apt-repository 2>/dev/null; then install_thing software-properties-common; fi

# ensure curl's installed
if ! hash curl 2>/dev/null; then install_thing curl; fi

# ensure unzip's installed
if ! hash unzip 2>/dev/null; then install_thing unzip; fi

# add various apt repositories
echo "adding fish-shell ppa"
sudo add-apt-repository ppa:fish-shell/release-3 >/dev/null 2>/dev/null

echo "adding diff-so-fancy ppa"
sudo add-apt-repository ppa:aos1/diff-so-fancy >/dev/null 2>/dev/null

echo "adding neovim ppa"
sudo add-apt-repository ppa:neovim-ppa/stable >/dev/null 2>/dev/null

# apt-update
echo "running apt-get update"
sudo apt-get update >/dev/null 2>/dev/null

if ! hash aws 2>/dev/null; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip >/dev/null
  sudo ./aws/install
  rm -rf awscliv2.zip ./aws/

  if ! hash aws 2>/dev/null; then echo "aws cli install failed!" && exit 1; fi
fi
