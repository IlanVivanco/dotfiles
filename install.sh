#!/bin/sh

# Repositories
add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt upgrade -y

# Install packages
sudo apt install -y $(cat packages)
sudo apt autoremove -y

# Create coding dir
mkdir -p ${HOME}/code

# Setup and config PHP
./bin/setup-php.sh

# Setup and config Samba
./bin/setup-samba.sh

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)

# install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

## Install stow dirs
stow code
stow git
stow general
stow ssh
stow zsh
