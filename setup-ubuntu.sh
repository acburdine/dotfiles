#!/bin/bash

function install_thing {
  if [ -z "$1" ]; then echo "must specify something to install" && exit 1; fi
  sudo apt install -y "$1"
}
