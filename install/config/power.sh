#!/bin/bash

# Setting the performance profile can make a big difference. By default, most systems seem to start in balanced mode,
# even if they're not running off a battery. So let's make sure that's changed to performance.
yay -S --noconfirm python-gobject power-profiles-daemon

# FIXME: Need a way to add the user system unit in CHROOT install
if ls /sys/class/power_supply/BAT* &>/dev/null && [ -z "${OMARCHY_CHROOT_INSTALL:-}" ]; then
  # This computer runs on a battery
  powerprofilesctl set balanced || true

  # Enable battery monitoring timer for low battery notifications
  systemctl --user enable --now omarchy-battery-monitor.timer
else
  # This computer runs on power outlet
  powerprofilesctl set performance || true
fi
