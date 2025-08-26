#!/bin/bash

sudo pacman -S --needed --noconfirm zsh

ZSH="$HOME/.oh-my-zsh" CHSH=no RUNZSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# ZSH="$HOME/.oh-my-zsh" sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

MISE_SHIMS=$HOME/.local/share/mise/shims
if [ -f $MISE_SHIMS/homesick ]; then
  $MISE_SHIMS/homesick link arch --force
fi

sudo chsh -s $(which zsh) jake
