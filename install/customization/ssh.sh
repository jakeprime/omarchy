#!/bin/bash

SSH_KEY=id_$(hostname)

echo "Generating SSH key"
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -C "$(git config get user.email)" -f ".ssh/$SSH_KEY" -N ""

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/$SSH_KEY

# we need to add this to Github, which will require another computer
echo "Add this key to Github using wormhole"
/usr/bin/wormhole send --hide-progress --no-qr ~/.ssh/$SSH_KEY.pub

read -p "Press enter when key has been added to Github...
"

# ensure it works and add fingerprint to known hosts without prompting
ssh -o StrictHostKeyChecking=accept-new git@github.com
