#!/usr/bin/env bash

declare -r LINUX_INOTIFYWAIT_ARGS="close_write"
declare -r TARGET=$1
shift
declare -r ARGS=("${@}")

inotifywait -e $LINUX_INOTIFYWAIT_ARGS -m . |\
	while read -r directory events filename; do
	if [ "$filename" = "$TARGET" ]; then
		echo "$(date): executing pandoc because of $events..."
		time pandoc "$TARGET" "${ARGS[@]}"
	fi
done; exit
