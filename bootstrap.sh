#!/usr/bin/env bash

############################  SETUP PARAMETERS
app_name='.dotfiles'
git_uri='https://github.com/luismayta/dotfiles.git'
git_branch='develop'
debug_mode='0'
fork_maintainer='0'
path_repo="$HOME/$app_name"
path_backup="$HOME/backup"

# import files
for file in "$path_repo/"src/{messages.sh,repo.sh}; do
	[ -r "$file" ] && source "$file"
done
unset file

############################  BASIC SETUP TOOLS
program_exists() {
    local ret='0'
    type $1 >/dev/null 2>&1 || { local ret='1'; }

    # throw error on non-zero return value
    if [ ! "$ret" -eq '0' ]; then
        error "$2"
    fi
}

############################ SETUP FUNCTIONS
do_backup() {
    local ret='0'
    local msg="Your old dotfiles stuff has a suffix now and looks like"
    local today=`date +%Y%m%d`
    local path_today="$path_backup/$today/"
    `mkdir -p "$path_today"`
    file_backup="$path_today${file##*/}"

    if [ -r "$1" ]; then
        [ ! -L "$1" ] && mv "$1" "$file_backup";
        ret="$?"
        success "$msg $file_backup"
        debug
    fi
}

############################ MOVE FILE
mv_file() {
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

do_it(){
    for app in {zsh,git,tmux}; do
        program_exists "$app" "To install $app_name you first need to install $app."
    done
    unset app

    for path in conf/{shell,app}; do
        for file_path in "$path/"*; do
            file="$HOME/.${file_path##*/}"
            file_path="$path_repo/$file_path"
            do_backup "$file"
            mv_file "$file_path" "$file"
            unset file
        done
        unset file_path
    done
    unset path
}

clone_repo      "Successfully cloned $app_name"

msg             "\nThanks for installing $app_name."
msg             "© `date +%Y` $app_name"

# cd "$(dirname "${BASH_SOURCE}")"

echo -n "This may overwrite existing files in your home directory. Are you sure? (y/n) "

read response

if [[ $response =~ ^[Yy]$ ]]; then
    do_it
fi
