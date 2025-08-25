#!/bin/sh

keyboard=$1

ln -fs ~/.config/hypr/hyprland/input/keyboard.${keyboard}.conf ~/.config/hypr/hyprland/input/keyboard.conf
hyprctl reload
