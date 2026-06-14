# shellcheck shell=bash

# create cache and reload settings
function reload {
    exec "${SHELL}" -l
}

# Homebrew install override
core::internal::core::install() {
  if ! core::internal::core::exists brew; then
    core::internal::message::warning "${CORE_MESSAGE_BREW}"
    return 1
  fi
  brew install "${@}"
}

core::internal::packages::install() {
  if ! core::internal::core::exists brew; then
    core::internal::message::warning "${CORE_MESSAGE_BREW}"
  fi

  core::internal::core::install "${CORE_PACKAGES[@]}"
}