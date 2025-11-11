#!/bin/bash

play(){
	readarray -t players < "$HOME/.local/share/playing"
	for player in "${players[@]}" ; do
		playerctl -p "$player" play
	done
	rm "$HOME/.local/share/playing"
}

pause(){
	readarray -t players < <(playerctl -l)
	for player in "${players[@]}" ; do
		if [[ $(playerctl -p "$player" status) != "Paused" ]] ; then
			echo "$player" ; playerctl -p "$player" pause
		fi
	done > "$HOME/.local/share/playing"
	grep -q '[^[:space:]]' "$HOME/.local/share/playing" || rm "$HOME/.local/share/playing"
}

if [[ "$1" == "stop" ]] ; then
	stop
else
	if [[ -e "$HOME/.local/share/playing" ]] ; then
		play
	else
		pause
	fi
fi
