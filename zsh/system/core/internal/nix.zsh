#
# shellcheck shell=bash
# Internal: Nix installation and verification
#

core::internal::nix::exists() {
  command -v nix > /dev/null && return 0
  [[ -x "${HOME}/.nix-profile/bin/nix" ]] && return 0
  [[ -x "/run/current-system/sw/bin/nix" ]] && return 0
  [[ -x "/etc/profiles/per-user/${USER}/bin/nix" ]] && return 0
  return 1
}

core::internal::nix::install() {
  if core::internal::nix::exists; then
    return 0
  fi

  core::internal::message::warning "Nix is not installed. Installing via official script..."

  case "${OSTYPE}" in
    darwin*)
      sh <(curl -L https://nixos.org/nix/install) --daemon
      ;;
    linux*)
      sh <(curl -L https://nixos.org/nix/install) --no-daemon
      ;;
    *)
      core::internal::message::error "Nix installation not supported on ${OSTYPE}"
      return 1
      ;;
  esac

  # Verify installation succeeded
  if ! core::internal::nix::exists; then
    core::internal::message::error "Nix installation failed. Please install manually: https://nixos.org/download"
    return 1
  fi
}
