#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

readonly DOTFILES_NAME='.dotfiles'
readonly DOTFILES_GIT_URI='https://github.com/luismayta/dotfiles.git'
readonly DOTFILES_GIT_BRANCH='main'
PATH_REPO="${HOME}/${DOTFILES_NAME}"

[ -r "$(dirname "${BASH_SOURCE[0]}")/common/colors.sh" ] || { echo "FATAL: lib/colors.sh not found" >&2; exit 1; }
# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/common/colors.sh"

[ -r "$(dirname "${BASH_SOURCE[0]}")/common/messages.sh" ] || { echo "FATAL: lib/messages.sh not found" >&2; exit 1; }
# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/common/messages.sh"

[ -r "$(dirname "${BASH_SOURCE[0]}")/common/common.sh" ] || { echo "FATAL: lib/common.sh not found" >&2; exit 1; }
# shellcheck source=/dev/null
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

function is_apt_distro {
  local id="" id_like=""
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    id="${ID:-}"
    id_like="${ID_LIKE:-}"
  fi
  [[ "${id}" == "ubuntu" || "${id}" == "debian" || "${id_like}" == *"ubuntu"* || "${id_like}" == *"debian"* ]]
}

function is_paru_distro {
  local id="" id_like=""
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    id="${ID:-}"
    id_like="${ID_LIKE:-}"
  fi
  [[ "${id}" == "arch" || "${id}" == "cachyos" || "${id_like}" == *"arch"* ]]
}

function install_paru {
  if type -p paru >/dev/null 2>&1; then
    msg::success "paru already installed"
    return 0
  fi
  msg::info "Installing paru from AUR..."
  sudo pacman -S --needed --noconfirm base-devel git
  if [[ ! -d "/tmp/paru-build" ]]; then
    git clone https://aur.archlinux.org/paru.git "/tmp/paru-build"
  fi
  (cd "/tmp/paru-build" && makepkg -si --noconfirm)
}

function install_apt_packages {
  local pkg=""
  sudo -v
  for pkg in "${PACKAGES_COMMON[@]}" "${PACKAGES_APT[@]}"; do
    if dpkg -s "${pkg}" >/dev/null 2>&1; then
      msg::success "${pkg} already installed, skipping"
    else
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${pkg}"
    fi
  done
  unset pkg
}

function setup::packages::apt_repos {
  local repo=""
  local repo_guard=""
  [[ ${#PACKAGES_APT_REPOS[@]} -eq 0 ]] && return 0

  if ! dpkg -s software-properties-common >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
  fi

  for repo in "${PACKAGES_APT_REPOS[@]}"; do
    repo_guard="${repo}"
    if [[ "${repo}" == ppa:* ]]; then
      repo_guard="${repo#ppa:}"
      repo_guard="${repo_guard//\//-}"
      # shellcheck disable=SC2010 # glob no maneja filenames con no-alfanuméricos de PPAs
      if ls /etc/apt/sources.list.d/ 2>/dev/null | grep -q "^${repo_guard}-"; then
        msg::success "${repo} already configured, skipping"
        continue
      fi
    elif grep -rhqF "${repo}" /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null; then
      msg::success "${repo} already configured, skipping"
      continue
    fi
    sudo add-apt-repository -y "${repo}"
  done
  unset repo repo_guard
  sudo apt-get update
}

function install_paru_packages {
  local pkg=""
  for pkg in "${PACKAGES_COMMON[@]}" "${PACKAGES_LINUX[@]}"; do
    if paru -Q "${pkg}" >/dev/null 2>&1; then
      msg::success "${pkg} already installed, skipping"
    else
      paru -S --noconfirm "${pkg}"
    fi
  done
  unset pkg
}

function setup::packages::common {
  local os_name
  os_name=$(detect::os)

  if [[ ! -v PACKAGES_COMMON ]]; then
    [ -r "$(dirname "${BASH_SOURCE[0]}")/config/packages.sh" ] || { echo "FATAL: config/packages.sh not found" >&2; exit 1; }
    # shellcheck source=/dev/null
    source "$(dirname "${BASH_SOURCE[0]}")/config/packages.sh"
  fi

  case "$os_name" in
    "Darwin")
      brew install "${PACKAGES_COMMON[@]}"
      brew install --cask "${PACKAGES_MAC[@]}"
      ;;
    "Linux")
      if is_apt_distro; then
        install_apt_packages
      elif is_paru_distro; then
        install_paru_packages
      else
        msg::error "Unsupported Linux distribution for package installation."
        exit 1
      fi
      ;;
  esac
}

function setup::nix {
  # Skip Nix installation if SKIP_NIX is set
  if [[ -n "${SKIP_NIX:-}" ]]; then
    msg::info "Skipping Nix installation (SKIP_NIX=true)"
    return 0
  fi

  # Install Nix — daemon mode on macOS, single-user on Linux
  if ! type -p nix >/dev/null; then
    local os_name
    os_name=$(detect::os)
    local install_args="--no-daemon"
    [[ "$os_name" == "Darwin" ]] && install_args="--daemon"

    msg::info "Installing Nix (${install_args#--})..."
    sh <(curl -L https://nixos.org/nix/install) "$install_args"

    # Source Nix for the current session
    if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
      # shellcheck source=/dev/null
      source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
    elif [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
      # shellcheck source=/dev/null
      source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi
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

  # Bootstrap nix-darwin if the flake is available locally
  if [[ -f "${PATH_REPO}/nix/darwin/flake.nix" ]] && command -v nix >/dev/null; then
    msg::info "Bootstrapping nix-darwin system configuration..."
    nix run nix-darwin -- switch --flake "${PATH_REPO}/nix/darwin"
  fi
}

function setup::linux {
  # Detect Linux distribution
  local distro_id=""
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    distro_id="${ID:-}"
  else
    msg::error "Cannot detect Linux distribution (/etc/os-release not found)."
    exit 1
  fi

  if [[ ! -v PACKAGES_COMMON ]]; then
    [ -r "$(dirname "${BASH_SOURCE[0]}")/config/packages.sh" ] || { echo "FATAL: config/packages.sh not found" >&2; exit 1; }
    # shellcheck source=/dev/null
    source "$(dirname "${BASH_SOURCE[0]}")/config/packages.sh"
  fi

  if is_apt_distro; then
    setup::packages::apt_repos
  elif is_paru_distro; then
    install_paru
  else
    msg::error "Unsupported Linux distribution '${distro_id}'. Supported: Ubuntu/Debian (apt), Arch/CachyOS (paru)."
    exit 1
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
