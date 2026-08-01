# shellcheck shell=bash

# Native package manager dispatch — apt-get (Ubuntu/Debian) vs paru (Arch/CachyOS)
core::internal::core::install() {
  local id="" id_like=""
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    id="${ID:-}"
    id_like="${ID_LIKE:-}"
  fi

  if [[ "${id}" == "ubuntu" || "${id}" == "debian" || "${id_like}" == *"ubuntu"* || "${id_like}" == *"debian"* ]]; then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${@}"
  elif [[ "${id}" == "arch" || "${id}" == "cachyos" || "${id_like}" == *"arch"* ]]; then
    if ! core::internal::core::exists paru; then
      core::internal::message::warning "${CORE_MESSAGE_PARU}"
      return 1
    fi
    paru -S --noconfirm "${@}"
  else
    core::internal::message::error "core::install not implemented for ${OSTYPE}"
    return 1
  fi
}

core::internal::packages::install() {
  local id="" id_like=""
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    id="${ID:-}"
    id_like="${ID_LIKE:-}"
  fi

  if [[ "${id}" == "ubuntu" || "${id}" == "debian" || "${id_like}" == *"ubuntu"* || "${id_like}" == *"debian"* ]]; then
    sudo apt-get update
    core::internal::core::install "${CORE_PACKAGES[@]}"
  else
    if ! core::internal::core::exists paru; then
      core::internal::message::warning "${CORE_MESSAGE_PARU}"
    fi
    paru -Syu --noconfirm
    core::internal::core::install "${CORE_PACKAGES[@]}"
  fi
}
