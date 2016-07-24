#!/usr/bin/env bash
# -*- coding: utf-8 -*-

export HOME=~
export PROJECT_NAME=dotfiles
export APP_DIR="$HOME/.$PROJECT_NAME"
export SRC_DIR="$APP_DIR/src"

# shellcheck source=src/load.sh
[ -r "$SRC_DIR/load.sh" ] && source "$SRC_DIR/load.sh"

function install_apps(){
    for app in $APPS; do
        "$TOOLS_DIR/${app}/install.sh"
    done
    unset app
}

function replace_files(){
    echo -n "This may overwrite existing files in your home directory. Are you sure? (y/n) "

    read -r response

    if [[ $response =~ ^[Yy]$ ]]; then
        initialize
    fi
}

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

clone_repo      "Successfully cloned $APP_NAME"

msg             "\nThanks for installing $APP_NAME."
msg             "© $(date +%Y) $APP_NAME,s"

if [[ $TEST = 'true' ]]; then
    initialize
    exit 1
fi

replace_files
