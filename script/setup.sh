#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=script/bootstrap.sh
[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

function initialize(){
    for app in {zsh,git,tmux}; do
        program_exists "$app"
    done
    unset app

    install_apps

    for path in "$CONF_DIR/"/{shell,app}; do
        for file_path in "$path/"*; do
            local file="$HOME/.${file_path##*/}"
            do_backup "$file"
            cp_file "$file_path" "$file"
            unset file
        done
        unset file_path
    done
    unset path

}

if [[ $TEST = 'true' ]]; then
    initialize
    exit 1
fi

replace_files
