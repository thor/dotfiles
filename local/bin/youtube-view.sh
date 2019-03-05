#!/bin/bash

# This script plays videos from a number of websites in mpv, 
# including YouTube, Vimeo, SoundCloud, etc
# 
# Playlists are also supported.
set -me
work_dir="$(mktemp -d /tmp/youtube-dl_mpv.XXXX)"
cookies_file="${work_dir}/cookies"
#user_agent="$(youtube-dl --dump-user-agent)"
fifo=$(mktemp -u)
fifo2=$(mktemp -u)
mkfifo $fifo
mkfifo $fifo2

mpv --ytdl --quiet --hwdec=vdpau \
	'--ytdl-raw-options=sub-lang="en-GB,en,no",write-sub=,cookies='$cookies_file'' \
	$* >&2
