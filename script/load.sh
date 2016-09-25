#!/usr/bin/env bash
# -*- coding: utf-8 -*-

export HOME=~
export PROJECT_NAME=dotfiles
export APP_DIR="$HOME/.$PROJECT_NAME"
export SRC_DIR="$APP_DIR/src"
export CONF_DIR="$APP_DIR/conf"
export TOOLS_DIR="$APP_DIR/tools"
export ROOT_DIR=$(pwd)

for file in "$SRC_DIR/"{config.sh,messages.sh,repo.sh,functions.sh}; do
	[ -r "${file}" ] && source "${file}"
done
unset file
