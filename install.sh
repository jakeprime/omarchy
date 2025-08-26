#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

export PATH="$HOME/.local/share/omarchy/bin:$PATH"
OMARCHY_INSTALL=~/.local/share/omarchy/install

# Give people a chance to retry running the installation
catch_errors() {
  echo -e "\n\e[31mOmarchy installation failed!\e[0m"
  echo
  echo "This command halted with exit code $?:"
  echo "$BASH_COMMAND"
  echo
  echo "Get help from the community via QR code or at https://discord.gg/tXFUdasqhY"
  echo "                                 "
  echo "    █▀▀▀▀▀█ ▄ ▄ ▀▄▄▄█ █▀▀▀▀▀█    "
  echo "    █ ███ █ ▄▄▄▄▀▄▀▄▀ █ ███ █    "
  echo "    █ ▀▀▀ █ ▄█  ▄█▄▄▀ █ ▀▀▀ █    "
  echo "    ▀▀▀▀▀▀▀ ▀▄█ █ █ █ ▀▀▀▀▀▀▀    "
  echo "    ▀▀█▀▀▄▀▀▀▀▄█▀▀█  ▀ █ ▀ █     "
  echo "    █▄█ ▄▄▀▄▄ ▀ ▄ ▀█▄▄▄▄ ▀ ▀█    "
  echo "    ▄ ▄▀█ ▀▄▀▀▀▄ ▄█▀▄█▀▄▀▄▀█▀    "
  echo "    █ ▄▄█▄▀▄█ ▄▄▄  ▀ ▄▀██▀ ▀█    "
  echo "    ▀ ▀   ▀ █ ▀▄  ▀▀█▀▀▀█▄▀      "
  echo "    █▀▀▀▀▀█ ▀█  ▄▀▀ █ ▀ █▄▀██    "
  echo "    █ ███ █ █▀▄▄▀ █▀███▀█▄██▄    "
  echo "    █ ▀▀▀ █ ██  ▀ █▄█ ▄▄▄█▀ █    "
  echo "    ▀▀▀▀▀▀▀ ▀ ▀ ▀▀▀  ▀ ▀▀▀▀▀▀    "
  echo "                                 "

  if [[ -n $OMARCHY_BARE ]]; then
    echo "You can retry by running: OMARCHY_BARE=true bash ~/.local/share/omarchy/install.sh"
  else
    echo "You can retry by running: bash ~/.local/share/omarchy/install.sh"
  fi
}

trap catch_errors ERR

show_logo() {
  clear
  tte -i ~/.local/share/omarchy/logo.txt --frame-rate ${2:-120} ${1:-expand}
  echo
}

show_subtext() {
  echo "$1" | tte --frame-rate ${3:-640} ${2:-wipe}
  echo
}

# Install prerequisites
source $OMARCHY_INSTALL/preflight/chroot.sh
source $OMARCHY_INSTALL/preflight/mirrorlist.sh
source $OMARCHY_INSTALL/preflight/guard.sh
source $OMARCHY_INSTALL/preflight/aur.sh
source $OMARCHY_INSTALL/preflight/migrations.sh

# Configuration
source $OMARCHY_INSTALL/config/config.sh
source $OMARCHY_INSTALL/config/branding.sh
source $OMARCHY_INSTALL/config/network.sh
source $OMARCHY_INSTALL/config/power.sh
source $OMARCHY_INSTALL/config/git.sh
source $OMARCHY_INSTALL/config/gpg.sh
source $OMARCHY_INSTALL/config/usb-autosuspend.sh
source $OMARCHY_INSTALL/config/timezones.sh
source $OMARCHY_INSTALL/config/nvidia.sh
source $OMARCHY_INSTALL/config/increase-sudo-tries.sh
source $OMARCHY_INSTALL/config/increase-lockout-limit.sh
source $OMARCHY_INSTALL/config/ignore-power-button.sh
source $OMARCHY_INSTALL/config/ssh-flakiness.sh
source $OMARCHY_INSTALL/config/detect-keyboard-layout.sh
source $OMARCHY_INSTALL/config/fix-fkeys.sh
source $OMARCHY_INSTALL/config/xcompose.sh

# Login
source $OMARCHY_INSTALL/login/plymouth.sh
source $OMARCHY_INSTALL/login/limine-snapper.sh
source $OMARCHY_INSTALL/login/alt-bootloaders.sh

# Development
source $OMARCHY_INSTALL/development/terminal.sh
source $OMARCHY_INSTALL/development/development.sh
source $OMARCHY_INSTALL/development/nvim.sh
source $OMARCHY_INSTALL/development/ruby.sh
source $OMARCHY_INSTALL/development/docker.sh
source $OMARCHY_INSTALL/development/firewall.sh

# Desktop
source $OMARCHY_INSTALL/desktop/desktop.sh
source $OMARCHY_INSTALL/desktop/hyprlandia.sh
source $OMARCHY_INSTALL/desktop/theme.sh
source $OMARCHY_INSTALL/desktop/bluetooth.sh
source $OMARCHY_INSTALL/desktop/asdcontrol.sh
source $OMARCHY_INSTALL/desktop/fonts.sh
source $OMARCHY_INSTALL/desktop/printer.sh

# Apps
source $OMARCHY_INSTALL/apps/webapps.sh
source $OMARCHY_INSTALL/apps/tuis.sh
source $OMARCHY_INSTALL/apps/xtras.sh
source $OMARCHY_INSTALL/apps/mimetypes.sh

# jakeprime customization
source $OMARCHY_INSTALL/customization/packages.sh
source $OMARCHY_INSTALL/customization/homesick.sh
source $OMARCHY_INSTALL/customization/zsh.sh

# Updates
sudo updatedb

# Update system packages if we have a network connection
if ping -c5 omarchy.org &>/dev/null; then
  yay -Syu --noconfirm
fi

# Reboot
show_logo laseretch 920
show_subtext "You're done! So we're ready to reboot now..."

if sudo test -f /etc/sudoers.d/99-omarchy-installer; then
  sudo rm -f /etc/sudoers.d/99-omarchy-installer &>/dev/null
  echo
  read -n 1 -s -r -p "Remove the USB installer then press any key to reboot..."
  echo
fi

sleep 2
reboot
