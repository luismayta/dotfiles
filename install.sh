#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

trap 'message::error "bootstrap failed at line $LINENO"' ERR

readonly RED="\033[0;31m"
readonly GREEN="\033[0;32m"
readonly BLUE="\033[0;36m"
readonly RESET="\033[0m"

readonly DOTFILES_NAME='.dotfiles'
readonly DOTFILES_GIT_URI='https://github.com/luismayta/dotfiles.git'
readonly DOTFILES_GIT_BRANCH='main'
readonly PATH_REPO="${HOME}/${DOTFILES_NAME}"

function message::info {
  printf "${BLUE}%s${RESET}\n" "[INFO]: ${1}"
}

function message::success {
  printf "${GREEN}%s${RESET}\n" "🧉 [SUCCESS]: ${1}"
}

function message::error {
  printf "${RED}%s${RESET}\n" "😈 [ERROR]: ${1}"
}

function detect::os {
  uname
}

function setup::factory {
  local os_name
  os_name=$(detect::os)
  case "$os_name" in
    "Darwin")
      setup::mac
      ;;
    "Linux")
      setup::linux
      ;;
    *)
      echo "Unsupported OS: $os_name"
      exit 1
      ;;
  esac
}

function setup::mac {
  if ! type -p brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Detect brew location and set up environment
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    message::error "Homebrew not found after installation. Expected at /opt/homebrew/bin/brew or /usr/local/bin/brew."
    exit 1
  fi

  # Verify brew works
  if ! brew --version >/dev/null 2>&1; then
    message::error "Homebrew is installed but not functioning correctly."
    exit 1
  fi

  brew install zsh git rsync \
    jq ag fd ripgrep cmake ksh
}

function setup::linux {
  # Detect Arch-based distro
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    if [[ "${ID:-}" != "arch" && "${ID:-}" != "cachyos" && "${ID_LIKE:-}" != "arch" ]]; then
      message::error "Unsupported Linux distribution. Only Arch Linux (CachyOS) is supported."
      exit 1
    fi
  else
    message::error "Cannot detect Linux distribution (/etc/os-release not found)."
    exit 1
  fi

  if ! type -p paru >/dev/null; then
    sudo pacman -S --noconfirm paru
  fi

  local packages=(
    git
    go
    npm
    yarn
    gcc
    rsync
    zsh
    ksh
    fd
  )

  for package in "${packages[@]}"; do
    paru -S --noconfirm "${package}"
  done

  npm install -g n
}

function clone_repo {
  local ret=0

  if [[ ! -e "${PATH_REPO}" ]]; then
    git clone --recursive -b "${DOTFILES_GIT_BRANCH}" "${DOTFILES_GIT_URI}" "$PATH_REPO" || ret=$?
    if [[ "$ret" -eq 0 ]]; then
      message::success "$1"
    else
      message::error "Failed to clone ${DOTFILES_NAME}"
      exit 1
    fi
  else
    upgrade_repo "${DOTFILES_NAME}" "Successfully updated ${DOTFILES_NAME}" || ret=$?
  fi

  if [[ "$ret" -eq 0 ]]; then
    cd "${PATH_REPO}" || exit 1
    # shellcheck source=/dev/null
    source provision/script/run.sh
  fi
}

program_exists() {
  local app=$1
  local message="Need to install ${app}."
  local ret='0'
  type -p "${app}" >>/dev/null 2>&1 || ret='1'

  if [[ "$ret" -eq '0' ]]; then
    return 0
  fi

  message::error "${message}"
  exit 1
}

function upgrade_repo() {
  local ret=0
  message::info "trying to update ${1}"

  if [ "${1}" = "${DOTFILES_NAME}" ]; then
    cd "${PATH_REPO}" || { message::error "Failed to cd to ${PATH_REPO}"; exit 1; }
    git pull origin "${DOTFILES_GIT_BRANCH}" || ret=$?
  fi

  message::success "${2}"
  return "$ret"
}

setup::factory

for app in {zsh,git,rsync}; do
  program_exists "${app}"
done
unset app

clone_repo "Successfully cloned ${DOTFILES_NAME}"

message::info "\nThanks for installing ${DOTFILES_NAME}."
message::info "© $(date +%Y) ${DOTFILES_NAME}"
