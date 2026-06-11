# shellcheck shell=bash

function rvm::internal::version::install {
  local version=${1}
  rvm install "${version}" --with-openssl-dir="$(brew --prefix openssl@3)"
}

function rvm::internal::rvm::load {
  # Add RVM to PATH for scripting
  [ -e "${RVM_ROOT}/bin" ] && export PATH="${PATH}:${RVM_ROOT}/bin"
  [ -e "/opt/homebrew/opt/openssl@3.0/bin" ] && export PATH="${PATH}:/opt/homebrew/opt/openssl@3.0/bin"
  # shellcheck source=/dev/null
  [[ -s "${RVM_ROOT}/scripts/rvm" ]] && . "${RVM_ROOT}/scripts/rvm"
}

function rvm::internal::rvm::install {
  message_info "Installing ${RVM_PACKAGE_NAME}"
  core::install "openssl@3"

  rvm::internal::install::gpg

  curl -sSL https://get.rvm.io | bash -s stable
  rvm get stable
  rvm::internal::rvm::load
  message_success "Installed ${RVM_PACKAGE_NAME}"
}
