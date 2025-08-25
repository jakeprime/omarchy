#!/bin/sh

# usage:
#    focus_or_start.sh firefox

executable=$1
# optional title if the class doesn't match the executable
title=$2

if [[ $title != "" ]]
then
    running=$(hyprctl -j clients | jq -r ".[] | select(.title == \"${title}\") | .pid")
else
    running=$(hyprctl -j clients | jq -r ".[] | select(.class == \"${executable}\") | .pid")
fi

echo $running

if [[ $running != "" ]]
then
	hyprctl dispatch focuswindow pid:${running}
  hyprctl dispatch alterzorder top,pid:${running}
else
	${executable} &
fi
