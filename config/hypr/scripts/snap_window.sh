#!/bin/sh

position=$1

params() {
    local x=$(echo "scale=0; ($1 + 0.5) / 1" | bc)
    local y=$(echo "scale=0; ($2 + 0.5) / 1" | bc)
    echo "exact $x $y"
}

math() {
    local result=$(echo "scale=3; $1" | bc)
    echo $result
}

monitor=$(hyprctl -j activewindow | jq -r ".monitor")

screen_width=$(hyprctl -j monitors | jq -r ".[$monitor].width")
screen_height=$(hyprctl -j monitors | jq -r ".[$monitor].height")
screen_x=$(hyprctl -j monitors | jq -r ".[$monitor].x")
screen_y=$(hyprctl -j monitors | jq -r ".[$monitor].y")
taskbar_height=$(hyprctl -j monitors | jq -r ".[$monitor].reserved[1]")
scale=$(hyprctl -j monitors | jq -r ".[$monitor].scale")

gaps_out=$(hyprctl -j getoption "general:gaps_out" | jq -r ".custom | split(\" \") | .[0]")
gaps_in=$(hyprctl -j getoption "general:gaps_in" | jq -r ".custom | split(\" \") | .[0]")
border_size=$(hyprctl -j getoption "general:border_size" | jq -r ".int")

origin_x=$(math "$screen_x + $gaps_out")
origin_y=$(math "$taskbar_height + $screen_y + $gaps_out")
usable_width=$(math "($screen_width / $scale) - 2 * $gaps_out")
usable_height=$(math "($screen_height / $scale) - $taskbar_height - 2 * $gaps_out")

window_x=$(hyprctl -j activewindow | jq -r ".at | .[0]")
window_y=$(math "$origin_y + $gaps_in + $border_size")
window_width=$(hyprctl -j activewindow | jq -r ".size | .[0]")
window_height=$(math "$usable_height - 2 * ($gaps_in + $border_size)")

# echo "screen_width: $screen_width"
# echo "screen_height: $screen_height"
# echo "screen_x: $screen_x"
# echo "screen_y: $screen_y"
# echo "taskbar_height: $taskbar_height"
# echo "scale: $scale"

# echo "gaps_out: $gaps_out"
# echo "gaps_in: $gaps_in"
# echo "border_size: $border_size"

# echo "origin_x: $origin_x"
# echo "origin_y: $origin_y"
# echo "usable_width: $usable_width"
# echo "usable_height: $usable_height"

# echo "window_x: $window_x"
# echo "window_y: $window_y"
# echo "window_width: $window_width"
# echo "window_height: $window_height"


case $position in
    "left-half"|"right-half")
        window_width=$(math "($usable_width / 2) - 2 * ($gaps_in + $border_size)")
        ;;
    "left-third"|"center-third"|"right-third")
        window_width=$(math "($usable_width / 3) - 2 * ($gaps_in + $border_size)")
        ;;
    "left-twothirds"|"right-twothirds")
        window_width=$(math "($usable_width * 2 / 3) - 2 * ($gaps_in + $border_size)")
        ;;
    "fullscreen")
        window_width=$(math "$usable_width - 2 * ($gaps_in + $border_size)")
        ;;
    "up"|"down")
        window_height=$(math "($usable_height / 2) - 2 * ($gaps_in + $border_size)")
        ;;
    *)
esac

case $position in
    "left-half"|"left-third"|"left-twothirds"|"fullscreen")
        window_x=$(math "$origin_x + $gaps_in + $border_size")
        ;;
    "center-third"|"right-twothirds")
        window_x=$(math "$origin_x + ($usable_width / 3) + (1 * ($gaps_in + $border_size))")
        ;;
    "right-third")
        window_x=$(math "$origin_x + 2 * ($usable_width / 3) + (1 * ($gaps_in + $border_size))")
        ;;
    "right-half")
        window_x=$(math "$origin_x + ($usable_width / 2) + (1 * ($gaps_in + $border_size))")
        ;;
    "down")
        window_y=$(math "$origin_y + ($usable_height / 2) + (1 * ($gaps_in + $border_size))")
        ;;
    *)
esac

move_params=$(params $window_x $window_y)
resize_params=$(params $window_width $window_height)
# echo "resize_params: $resize_params"
# echo "move_params: $move_params"

hyprctl dispatch setfloating
hyprctl dispatch resizeactive $resize_params
hyprctl dispatch moveactive $move_params
