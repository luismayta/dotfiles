#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# shellcheck disable=SC2034 # ret is used by callers for flow control

function initialize_prereqs() {
  for app in {zsh,git,rsync}; do
    program_exists "$app"
  done
  unset app
}

function install_apps() {
  dotfiles_install_apps
}

function deploy_configs() {
  for path_key in "${CONF_DIR}"/{shell,app}; do
    for file_path in "${path_key}/"*; do
      local file
      file="${HOME}/.${file_path##*/}"
      do_backup "${file}"
      cp_file "$file_path" "$file"
      unset file
    done
    unset file_path
  done
  unset path_key

  cp_file "${ZSH_DIR}/zshrc" "${HOME}/.zshrc"
  cp_file "${ZSH_DIR}/zshenv" "${HOME}/.zshenv"
}

function sync_extras() {
  rsync -avzh --progress "${ROOT_DIR}/config/" "${HOME}/.config/"
  rsync -avzh --progress "${CONF_DIR}/Library/" "${HOME}/Library/"
}

function initialize() {
  initialize_prereqs
  install_apps
  deploy_configs
  sync_extras
}

function do_backup() {
  local ret='0'
  local message="Your old dotfiles stuff has a suffix now and looks like"
  local today
  today=$(date +%Y%m%d)
  local path_today="${PATH_BACKUP}/${today}/"
  mkdir -p "${path_today}"
  local file_backup
  file_backup="${path_today}$(basename "$1")"

  if [ -r "$1" ]; then
    mv "$1" "$file_backup"
    ret="$?"
    msg::success "$message $file_backup"
  fi
}

function cp_file() {
  local ret='0'
  local message="Your move file "

  if [ -r "$1" ]; then
    cp "$1" "$2"
    ret="$?"
    msg::success "$message $1 to $2"
  fi
}

function dotfiles_install_apps() {
  for app in "${APPS[@]}"; do
    "${TOOLS_DIR}/${app}/install.sh"
  done
  unset app
}

function replace_files() {
  if [[ "${DOTFILES_YES:-}" == "true" ]] || [[ ! -t 0 ]]; then
    initialize
  else
    echo -n "This may overwrite existing files in your home directory. Are you sure? (y/n) "
    read -r response
    if [[ $response =~ ^[Yy]$ ]]; then
      initialize
    fi
  fi
}
