#!/usr/bin/env bash

if [[ ! $APP_NAME ]]; then
    APP_NAME='.dotfiles'
fi

if [[ ! $PATH_REPO ]]; then
    PATH_REPO="$HOME/$APP_NAME"
fi

echo $ROOT
echo $PATH_REPO

for file in "$PATH_REPO/"src/{config.sh,messages.sh,repo.sh,functions.sh}; do
    echo $file
	[ -r "$file" ] && source "$file"
done
unset file
