#!/usr/bin/env bash

if [[ ! $APP_NAME ]]; then
    APP_NAME='.dotfiles'
fi

if [[ ! $PATH_REPO ]]; then
    PATH_REPO="$HOME/$APP_NAME"
fi

for file in "$PATH_REPO/"src/{config.sh,messages.sh,repo.sh,functions.sh}; do
	[ -r "$file" ] && source "$file"
done
unset file
