#!/bin/sh

# Usage: llight.sh up|down
# Adjusts the default backlight in relation to its current
# strength. Favours minor changes in small values, as we're 
# more sensitive to that.
# 
# This can't be remotely novel, but I couldn't find anything
# on this when I was looking for it.
#
# Author: Thor K. Høgås <thor at roht dot no>

LIGHT=$(light -G)
MOD=$(echo "scale=4; (0.001 + ($LIGHT/2)/(100+$LIGHT)) *100" | bc)
if [ "$1" == "up" ]; then
	light -A "$MOD"
elif [ "$1" == "down" ]; then
	light -U "$MOD"
fi
