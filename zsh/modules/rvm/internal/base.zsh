# shellcheck shell=bash

function rvm::internal::rvm::install {
  message_info "Installing ${RVM_PACKAGE_NAME}"
  rvm::internal::install::gpg

  curl -sSL https://get.rvm.io | bash -s stable
  rvm get stable
  rvm::internal::rvm::load
  message_success "Installed ${RVM_PACKAGE_NAME}"
}

function rvm::internal::install::gpg {
  if core::exists gpg; then
      gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  fi

  if core::exists gpg2; then
      gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  fi

  command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
  command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
}

function rvm::internal::rvm::load {
  # Add RVM to PATH for scripting
  [ -e "${RVM_ROOT}/bin" ] && export PATH="${PATH}:${RVM_ROOT}/bin"
  # shellcheck source=/dev/null
  [[ -s "${RVM_ROOT}/scripts/rvm" ]] && . "${RVM_ROOT}/scripts/rvm"
}

function rvm::internal::packages::install {
  if ! core::exists gem; then
      message_warning "it's necessary have gem"
      return
  fi

  message_info "Installing required gem packages"
  gem install "${RVM_PACKAGES[@]}"
  message_success "Installed required gem packages"
}

function rvm::internal::version::install {
  local version=${1}
  rvm install "${version}"
}

function rvm::internal::version::all::install {
  if ! core::exists rvm; then
      message_warning "not found rvm"
      return
  fi

  for version in "${RVM_VERSIONS[@]}"; do
      message_info "Install version of rvm ${version}"
      rvm::internal::version::install "${version}"
      message_success "Installed version of rvm ${version}"
  done
  rvm use "${RVM_VERSION_GLOBAL}" --default
  message_success "Installed versions of rvm"

}

function rvm::internal::version::global::install {
  if ! core::exists rvm; then
      message_warning "not found rvm"
      return
  fi
  message_info "Installing version global of rvm ${RVM_VERSION_GLOBAL}"
  rvm::internal::version::install "${RVM_VERSION_GLOBAL}"
  rvm use "${RVM_VERSION_GLOBAL}" --default
  message_success "Installed version global of rvm ${RVM_VERSION_GLOBAL}"
}
