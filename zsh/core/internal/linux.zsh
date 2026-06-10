# shellcheck shell=bash

# Paru install override (CachyOS/Arch)
core::internal::core::install() {
  if ! core::internal::core::exists paru; then
    core::internal::message::warning "${CORE_MESSAGE_PARU}"
    return 1
  fi
  paru -S --noconfirm "${@}"
}
