#!/usr/bin/env bash

for file in "$path_repo/"src/{config.sh,messages.sh,repo.sh,functions.sh}; do
	[ -r "$file" ] && source "$file"
done
unset file

