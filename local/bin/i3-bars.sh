set -x

hostname=$(hostname)

killall polybar

if [ $hostname == 'delta-alpha' ]; then
	MONITOR=DVI-I-1 polybar desktop-center -r &
	MONITOR=DVI-D-0 polybar desktop-left -r &
	MONITOR=DP-0 polybar desktop-right -r &
else
	polybar $hostname -r &
fi

