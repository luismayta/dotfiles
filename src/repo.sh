#!/usr/bin/env bash

upgrade_repo() {
      msg "trying to update $1"

      if [ "$1" = "$app_name" ]; then
          cd "$path_repo" &&
          git pull origin "$git_branch"
      fi

      ret="$?"
      success "$2"
      debug
}

clone_repo() {
    program_exists "git" "Sorry, we cannot continue without GIT, please install it first."

    if [ ! -e "$path_repo/.git" ]; then
        git clone --recursive -b "$git_branch" "$git_uri" "$path_repo"
        ret="$?"
        success "$1"
        debug
    else
        upgrade_repo "$app_name" "Successfully updated $app_name"
    fi
}
