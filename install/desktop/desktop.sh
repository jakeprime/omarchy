#!/bin/bash

yay -S --noconfirm --needed \
  brightnessctl playerctl pamixer wiremix wireplumber \
  wl-clip-persist \
  nautilus sushi ffmpegthumbnailer gvfs-mtp \
  slurp satty \
  mpv evince imv \
  google-chrome

# Add screen recorder based on GPU
if lspci | grep -qi 'nvidia'; then
  yay -S --noconfirm --needed wf-recorder
else
  yay -S --noconfirm --needed wl-screenrec
fi
