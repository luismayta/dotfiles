#!/usr/bin/env bash
# -*- coding: utf-8 -*-

function detect::os {
  uname
}

program_exists() {
  local app=$1
  local message="Need to install ${app}."
  local ret='0'
  type -p "${app}" >/dev/null 2>&1 || ret='1'

  if [[ "$ret" -eq '0' ]]; then
    return 0
  fi

  echo "${message}" >&2
  exit 1
}

change_shell() {
  local shell_path="$1"
  if [[ "${SHELL}" != "${shell_path}" ]]; then
    sudo chsh -s "${shell_path}" "${USER}"
  fi
}
