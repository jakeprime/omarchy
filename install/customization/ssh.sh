#!/bin/bash

export SSH_KEY=id_$(hostname)

echo "Generating SSH key"
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -C "$(git config get user.email)" -f ".ssh/$SSH_KEY" -N ""

echo ""
echo "$(tput bold)Creating SSH key so we can access our Github repos$(tput sgr0)"
echo ""

# we need to add this to Github, which will require another computer
echo "Add this key to Github using wormhole"
/usr/bin/wormhole send --hide-progress --no-qr ~/.ssh/$SSH_KEY.pub

echo ""
read -p "$(tput bold)Press enter when key has been added to Github...$(tput sgr0)
"

# add fingerprint
echo "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
" >> ~/.ssh/known_hosts

