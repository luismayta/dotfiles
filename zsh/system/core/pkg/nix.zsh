#
# shellcheck shell=bash
# Public API: Nix core functions
#

core::nix::install() {
  core::internal::nix::install
}

core::nix::exists() {
  core::internal::nix::exists
}

core::nix::ensure() {
  if ! core::nix::exists; then
    core::nix::install || {
      core::message::error "Failed to ensure Nix installation"
      return 1
    }
  fi
}

# Public wrappers for nix package helper.
core::nix::package::exists() {
  core::exists "${1}"
}

core::nix::package::install() {
  local package_ref="${1:-}"
  local profile_name="${2:-}"
  if [[ -z "${profile_name}" ]]; then
    profile_name="${package_ref##*#}"
  fi
  core::internal::nix::package::install "${package_ref}" "${profile_name}"
}

core::nix::package::upgrade() {
  local profile_name="${1:-}"

  # Restore nix into PATH via fallback script paths.
  if ! command -v nix >/dev/null 2>&1; then
    if [[ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]]; then
      # shellcheck source=/dev/null
      source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
    elif [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
      # shellcheck source=/dev/null
      source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi
  fi

  if ! command -v nix >/dev/null 2>&1; then
    message_error "nix is not available in PATH. Install nix: https://nixos.org/download"
    return 1
  fi

  message_info "Upgrading ${profile_name}"
  if ! nix profile upgrade "${profile_name}" --extra-experimental-features 'nix-command flakes'; then
    message_error "Failed to upgrade ${profile_name}"
    return 1
  fi
  message_success "Upgraded ${profile_name}"
}