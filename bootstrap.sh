#!/usr/bin/env bash

APP_NAME='.dotfiles'
PATH_REPO="$HOME/$APP_NAME"

[ -r "$PATH_REPO/src/load.sh" ] && source "$PATH_REPO/src/load.sh"

############################  BASIC SETUP TOOLS
function program_exists() {
    local ret='0'
    type $1 >/dev/null 2>&1 || { local ret='1'; }

    # throw error on non-zero return value
    if [ ! "$ret" -eq '0' ]; then
        error "$2"
        exit
    fi
}

############################ SETUP FUNCTIONS
function do_backup() {
    local ret='0'
    local msg="Your old dotfiles stuff has a suffix now and looks like"
    local today=`date +%Y%m%d`
    local path_today="$PATH_BACKUP/$today/"
    `mkdir -p "$path_today"`
    file_backup="$path_today${file##*/}"

    if [ -r "$1" ]; then
        mv "$1" "$file_backup";
        ret="$?"
        success "$msg $file_backup"
        debug
    fi
}

############################ MOVE FILE
function mv_file() {
    local ret='0'
    local msg="Your move file "

    if [ -r "$1" ]; then
        [ ! -L "$1" ] && cp "$1" "$2";
        ret="$?"
        success "$msg $1 to $2"
        debug
    fi
}

############################ MAIN()

function do_it(){
    for app in {zsh,git,tmux}; do
        program_exists "$app" "To install $app_name you first need to install $app."
    done
    unset app

    for path in "$PATH_REPO/"conf/{shell,app}; do
        for file_path in "$path/"*; do
            local file="$HOME/.${file_path##*/}"
            do_backup "$file"
            mv_file "$file_path" "$file"
            unset file
        done
        unset file_path
    done
    unset path

    msg "Install Fonts"

    "$PATH_REPO/tools/fonts/install.sh"

    msg "Copying file bashrc adding it to ~/.zshrc"

    echo  "[ -r ~/.bashrc ] && source ~/.bashrc" >> ~/.zshrc
}

clone_repo      "Successfully cloned $app_name"

msg             "\nThanks for installing $app_name."
msg             "© `date +%Y` $app_name"

echo -n "This may overwrite existing files in your home directory. Are you sure? (y/n) "

read response

if [[ $response =~ ^[Yy]$ ]]; then
    do_it
fi
