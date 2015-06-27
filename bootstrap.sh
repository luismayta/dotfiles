#!/usr/bin/env bash

############################  SETUP PARAMETERS
app_name='dotfiles'
git_uri='https://github.com/luismayta/dotfiles.git'
git_branch='develop'
debug_mode='0'
fork_maintainer='0'

############################  BASIC SETUP TOOLS
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
    msg "\e[32m[✔]\e[0m ${1}${2}"
    fi
}

error() {
    msg "\e[31m[✘]\e[0m ${1}${2}"
    exit 1
}

debug() {
    if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
      msg "An error occured in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

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
    if [ -e "$2" ] || [ -e "$3" ] || [ -e "$4" ]; then
        today=`date +%Y%m%d_%s`
        for i in "$2" "$3" "$4"; do
            [ -e "$i" ] && [ ! -L "$i" ] && mv "$i" "$i.$today";
        done
        ret="$?"
        success "$1"
        debug
   fi
}

upgrade_repo() {
      msg "trying to update $1"

      if [ "$1" = "$app_name" ]; then
          cd "$HOME/.$app_name" &&
          git pull origin "$git_branch"
      fi

      ret="$?"
      success "$2"
      debug
}

clone_repo() {
    program_exists "git" "Sorry, we cannot continue without GIT, please install it first."
    endpath="$HOME/.$app_name-3"

    if [ ! -e "$endpath/.git" ]; then
        git clone --recursive -b "$git_branch" "$git_uri" "$endpath"
        ret="$?"
        success "$1"
        debug
    else
        upgrade_repo "$app_name"    "Successfully updated $app_name"
    fi
}


############################ MAIN()
program_exists "git" "To install $app_name you first need to install git."
program_exists "tmux" "To install $app_name you first need to install tmux."

do_backup   "Your old dotfiles stuff has a suffix now and looks like .dotfiles.`date +%Y%m%d%S`" \
        "$HOME/.bashrc" \
        "$HOME/.profile" \
        "$HOME/.exports"

clone_repo      "Successfully cloned $app_name"

msg             "\nThanks for installing $app_name."
msg             "© `date +%Y` dotfiles"

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" --exclude ".dependences"\
		--exclude "README.md" --exclude "git" --exclude "LICENSE-MIT.txt" -av --no-perms . ~
	source ~/.bash_profile
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset doIt
