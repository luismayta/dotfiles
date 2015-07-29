#!/usr/bin/env bash
# -*- coding: utf-8 -*-

for file in "$ROOT/"src/{config.sh,messages.sh,repo.sh,functions.sh}; do
	[ -r "$file" ] && source "$file"
done
unset file
