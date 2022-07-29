#!/usr/bin/env bash


function quit_prompt {
    return $(echo -e "no\nrestart\nyes" | dmenu -i -sb red -p "Confirm Quitting DWM: ")
}

while true; do
    exec dwm
    if [ "$(quit_prompt)" = "yes" ]; then
        break
    fi
done
