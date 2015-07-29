#!/usr/bin/env bash
# -*- coding: utf-8 -*-

function upgrade_repo() {
      msg "trying to update $1"

      if [ "$1" = "$APP_NAME" ]; then
          cd "$PATH_REPO" &&
          git pull origin "$GIT_BRANCH"
      fi

      ret="$?"
      success "$2"
      debug
}

function clone_repo() {
    if [ ! -e "$PATH_REPO/.git" ]; then
        git clone --recursive -b "$GIT_BRANCH" "$GIT_URI" "$PATH_REPO"
        ret="$?"
        success "$1"
        debug
    else
        upgrade_repo "$APP_NAME" "Successfully updated $APP_NAME"
    fi
}
