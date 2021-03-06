#!/bin/sh
set -x
DBUS_NAME="org.freedesktop.login1"
DBUS_PATH="/org/freedesktop/login1"
DBUS_INTERFACE="org.freedesktop.login1.Manager"
DBUS_SIGNAL="PrepareForSleep"

INHIBITOR_PID=

install_background_inhibitor() {
	tail -f /dev/null &
	INHIBITOR_PID=$!

	wait $INHIBITOR_PID &&
	echo done |
	    systemd-inhibit --what sleep --mode delay \
			    --who $0 --why "i3lock before suspend" \
			    read &
}

kill_background_inhibitor() {
	kill $INHIBITOR_PID
}

gdbus monitor --system \
	      --dest $DBUS_NAME \
	      --object-path $DBUS_PATH |
    (install_background_inhibitor;
     trap kill_background_inhibitor INT TERM;
     while read line; do
	     if echo "$line" | grep -q "$DBUS_INTERFACE.$DBUS_SIGNAL"; then
		 if echo "$line" | grep -q true; then
		     . ~/.config/i3/i3-lock
		     kill_background_inhibitor
		 else
		     install_background_inhibitor
		 fi
	     fi
     done)
