#!/usr/bin/env bash

APP_NAME='.dotfiles'
PATH_REPO="$HOME/$APP_NAME"

for file in "$PATH_REPO/"src/{config.sh,messages.sh,repo.sh,functions.sh}; do
	[ -r "$file" ] && source "$file"
done
unset file

