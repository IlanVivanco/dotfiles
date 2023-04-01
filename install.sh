#!/bin/sh
cd "$HOME"/.dotfiles

# install packages
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install -y $(cat packages)
