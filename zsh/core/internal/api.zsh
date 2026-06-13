#
# shellcheck shell=bash
# Internal: core utilities and messaging
#

core::internal::core::install() {
  core::internal::message::error "core::install not implemented for ${OSTYPE}"
  return 1
}

core::internal::packages::install() {
  core::internal::message::error "core::packages::install not implemented for ${OSTYPE}"
  return 1
}

core::internal::cargo::install() {
  if ! core::internal::core::exists cargo; then
    core::internal::message::warning "${CORE_MESSAGE_RUST}"
  fi
  cargo install "${@}"
}

core::internal::core::load() {
  core::internal::message::warning "Method not implemented for ${CORE_PACKAGE_NAME:-core}"
}

core::internal::core::exists() {
  command -v "${1}" > /dev/null
}

core::internal::multiplatform::install() {
  case "${OSTYPE}" in
    darwin*)
      if core::internal::core::exists brew; then
        brew bundle --file="${DOTFILES_CORE_DIR}/Brewfile" 2>/dev/null || true
      else
        core::internal::message::warning "${CORE_MESSAGE_BREW}"
      fi
      ;;
    linux*)
      if core::internal::core::exists paru; then
        paru -Syu --noconfirm
        core::internal::packages::install "${CORE_LINUX_PACKAGES[@]}"
      else
        core::internal::message::warning "${CORE_MESSAGE_PARU}"
      fi
      ;;
    *)
      core::internal::message::error "multiplatform::install not supported for ${OSTYPE}"
      return 1
      ;;
  esac
}

core::internal::message::info() {
  printf "\033[0m\033[1;32m[INFO]: %s \033[0m\n" "${1}"
}

core::internal::message::error() {
  printf "\033[0m\033[0;31m[ERROR]: %s \033[0m\n" "${1}"
  return 0
}

core::internal::message::warning() {
  printf "\033[0m\033[0;33m[WARNING]: %s \033[0m\n" "${1}"
}

core::internal::message::success() {
  printf "\033[0m\033[0;32m[SUCCESS]: %s \033[0m\n" "${1}"
}
