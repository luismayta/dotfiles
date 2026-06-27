#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

readonly DOTFILES_NAME='.dotfiles'
readonly DOTFILES_GIT_URI='https://github.com/luismayta/dotfiles.git'
readonly DOTFILES_GIT_BRANCH='main'
PATH_REPO="${HOME}/${DOTFILES_NAME}"

# shellcheck source=/dev/null
[ -r "$(dirname "${BASH_SOURCE[0]}")/common/colors.sh" ] || { echo "FATAL: lib/colors.sh not found" >&2; exit 1; }
source "$(dirname "${BASH_SOURCE[0]}")/common/colors.sh"

# shellcheck source=/dev/null
[ -r "$(dirname "${BASH_SOURCE[0]}")/common/messages.sh" ] || { echo "FATAL: lib/messages.sh not found" >&2; exit 1; }
source "$(dirname "${BASH_SOURCE[0]}")/common/messages.sh"

# shellcheck source=/dev/null
[ -r "$(dirname "${BASH_SOURCE[0]}")/common/common.sh" ] || { echo "FATAL: lib/common.sh not found" >&2; exit 1; }
source "$(dirname "${BASH_SOURCE[0]}")/common/common.sh"

trap 'msg::error "bootstrap failed at line $LINENO ($(date))"' ERR

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

function setup::packages::common {
  local os_name
  os_name=$(detect::os)

  # shellcheck source=/dev/null
  [ -r "$(dirname "${BASH_SOURCE[0]}")/config/packages.sh" ] || { echo "FATAL: config/packages.sh not found" >&2; exit 1; }
  source "$(dirname "${BASH_SOURCE[0]}")/config/packages.sh"

  case "$os_name" in
    "Darwin")
      brew install "${PACKAGES_COMMON[@]}"
      brew install --cask "${PACKAGES_MAC[@]}"
      ;;
    "Linux")
      paru -S --noconfirm "${PACKAGES_COMMON[@]}"
      paru -S --noconfirm "${PACKAGES_LINUX[@]}"
      ;;
  esac
}

function setup::nix {
  # Skip Nix installation if SKIP_NIX is set
  if [[ -n "${SKIP_NIX:-}" ]]; then
    msg::info "Skipping Nix installation (SKIP_NIX=true)"
    return 0
  fi

  # Install Nix (single-user, no-daemon) — OS-agnostic
  if ! type -p nix >/dev/null; then
    msg::info "Installing Nix (single-user)..."
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
    # Source Nix for the current session
    # shellcheck source=/dev/null
    [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ] && source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
  fi
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
    msg::error "Homebrew not found after installation. Expected at /opt/homebrew/bin/brew or /usr/local/bin/brew."
    exit 1
  fi

  # Verify brew works
  if ! brew --version >/dev/null 2>&1; then
    msg::error "Homebrew is installed but not functioning correctly."
    exit 1
  fi

  setup::packages::common

  setup::nix
}

function setup::linux {
  # Detect Arch-based distro
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    if [[ "${ID:-}" != "arch" && "${ID:-}" != "cachyos" && "${ID_LIKE:-}" != "arch" ]]; then
      msg::error "Unsupported Linux distribution. Only Arch Linux (CachyOS) is supported."
      exit 1
    fi
  else
    msg::error "Cannot detect Linux distribution (/etc/os-release not found)."
    exit 1
  fi

  if ! type -p paru >/dev/null; then
    sudo pacman -S --noconfirm paru
  fi

  setup::packages::common

  setup::nix
}

function clone_repo {
  local ret=0

  if [[ ! -e "${PATH_REPO}" ]]; then
    git clone --recursive -b "${DOTFILES_GIT_BRANCH}" "${DOTFILES_GIT_URI}" "$PATH_REPO" || ret=$?
    if [[ "$ret" -eq 0 ]]; then
      msg::success "$1"
    else
      msg::error "Failed to clone ${DOTFILES_NAME}"
      exit 1
    fi
  else
    update_repo "${DOTFILES_NAME}" "Successfully updated ${DOTFILES_NAME}" || ret=$?
  fi

  if [[ "$ret" -eq 0 ]]; then
    export DOTFILES_ROOT="${PATH_REPO}"
    export DOTFILES_OS
    DOTFILES_OS=$(detect::os)
    exec bash "${PATH_REPO}/provision/script/run.sh"
  fi
}

function update_repo() {
  local ret=0
  msg::info "trying to update ${1}"

  if [ "${1}" = "${DOTFILES_NAME}" ]; then
    cd "${PATH_REPO}" || { msg::error "Failed to cd to ${PATH_REPO}"; exit 1; }
    git pull origin "${DOTFILES_GIT_BRANCH}" || ret=$?
  fi

  msg::success "${2}"
  return "$ret"
}

setup::factory

ZSH_PATH=$(command -v zsh)
readonly ZSH_PATH

change_shell "${ZSH_PATH}"

for app in {zsh,git,rsync}; do
  program_exists "${app}"
done
unset app

clone_repo "Successfully cloned ${DOTFILES_NAME}"

msg::info "\nThanks for installing ${DOTFILES_NAME}."
msg::info "© $(date +%Y) ${DOTFILES_NAME}"
