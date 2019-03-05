#/bin/sh
#
# Requires PulseAudio version 4 or higher due to pactl syntax
#
ACTION=$1
STEP="5%"

case $ACTION in
	"up") 
		pactl set-sink-volume @DEFAULT_SINK@ "+$STEP"; pactl set-sink-mute @DEFAULT_SINK@ 0 ;; 
	"down") 
		pactl set-sink-volume @DEFAULT_SINK@ "-$STEP"; pactl set-sink-mute @DEFAULT_SINK@ 0 ;; 
	"toggle") 
		pactl set-sink-mute @DEFAULT_SINK@ toggle ;; 
esac

