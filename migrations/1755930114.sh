echo "Add status indicators for screen recordings, nightlight, dnd, and idle lock to Waybar"
echo
gum confirm "Replace current Waybar config (backup will be made)?" && omarchy-refresh-waybar
