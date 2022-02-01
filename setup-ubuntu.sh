#!/usr/bin/env bash

echo "
-----------------------------------
acburdine's dotfiles - ubuntu setup
-----------------------------------
"

if ! hash sudo 2>/dev/null && [ "$EUID" -eq 0 ]; then
  echo "sudo not found, installing it..."
  apt-get update &>/dev/null && apt-get install -y sudo &>/dev/null
fi

echo "running apt-get update..."
sudo apt-get update &>/dev/null

echo "ensuring necessary base components are installed (curl, git, unzip, gcc)..."
sudo apt-get install -y curl git unzip gcc &>/dev/null

echo "checking if aws-cli is installed"
if ! hash aws 2>/dev/null; then
  echo "aws-cli not found, installing it now..."

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip >/dev/null
  sudo ./aws/install
  rm -rf awscliv2.zip ./aws/
fi
