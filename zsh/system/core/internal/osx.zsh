# shellcheck shell=bash

# Homebrew install override
core::internal::core::install() {
  if ! core::internal::core::exists brew; then
    core::internal::message::warning "${CORE_MESSAGE_BREW}"
    return 1
  fi
  brew install "${@}"
}

core::internal::cask::install() {
  if ! core::internal::core::exists brew; then
    core::internal::message::warning "${CORE_MESSAGE_BREW}"
    return 1
  fi
  brew install --cask "${@}"
}

core::internal::packages::install() {
  if ! core::internal::core::exists brew; then
    core::internal::message::warning "${CORE_MESSAGE_BREW}"
    return 1
  fi

  brew update

  if [[ ${#CORE_PACKAGES[@]} -gt 0 ]]; then
    core::internal::core::install "${CORE_PACKAGES[@]}"
  fi

  if [[ ${#CORE_CASKS[@]} -gt 0 ]]; then
    core::internal::cask::install "${CORE_CASKS[@]}"
  fi
}
