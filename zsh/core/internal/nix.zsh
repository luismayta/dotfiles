#
# shellcheck shell=bash
# Internal: Nix installation and verification
#

core::internal::nix::exists() {
  command -v nix > /dev/null
}

core::internal::nix::install() {
  if core::internal::nix::exists; then
    return 0
  fi

  core::internal::message::warning "Nix is not installed. Installing via official script..."

  case "${OSTYPE}" in
    darwin*|linux*)
      sh <(curl -L https://nixos.org/nix/install) --no-daemon
      ;;
    *)
      core::internal::message::error "Nix installation not supported on ${OSTYPE}"
      return 1
      ;;
  esac
}
