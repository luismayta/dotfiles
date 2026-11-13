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

# core::internal::nix::package::add-verb — feature-detect nix profile verb (install vs add)
core::internal::nix::package::add-verb() {
  # Cache: only probe when the variable is unset/empty.
  if [[ -n "${ZSH_NIX_PROFILE_INSTALL_VERB:-}" ]]; then
    return 0
  fi

  # Default verb (widely supported).
  ZSH_NIX_PROFILE_INSTALL_VERB="install"

  # Probe only when nix is available.
  if ! core::internal::nix::exists; then
    return 0
  fi

  local help_output=""
  if help_output="$(nix profile --help 2>&1)"; then
    if [[ "${help_output}" == *"profile install"* ]]; then
      ZSH_NIX_PROFILE_INSTALL_VERB="install"
    elif [[ "${help_output}" == *"profile add"* ]]; then
      ZSH_NIX_PROFILE_INSTALL_VERB="add"
    fi
  fi

  return 0
}

# core::internal::nix::package::exists <binary> — delegates to core::exists (no nix profile list)
core::internal::nix::package::exists() {
  core::exists "${1}"
}

# core::internal::nix::package::profile::exists <profile-name> — returns 0 if present in nix profile list
core::internal::nix::package::profile::exists() {
  local profile_name="${1:-}"

  # 1. Restore nix into PATH via fallback script paths.
  if ! command -v nix >/dev/null 2>&1; then
    if [[ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]]; then
      # shellcheck source=/dev/null
      source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
    elif [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
      # shellcheck source=/dev/null
      source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi
  fi

  # 2. If nix still unavailable -> not present (no error).
  if ! command -v nix >/dev/null 2>&1; then
    return 1
  fi

  # 3. Profile detection.
  if nix profile list 2>/dev/null | grep -q -- "${profile_name}"; then
    return 0
  fi
  return 1
}

# core::internal::nix::package::install <package-ref> <profile-name>
core::internal::nix::package::install() {
  local package_ref="${1:-}"
  local profile_name="${2:-}"
  local attr="${package_ref##*#}"

  [[ -z "${profile_name}" ]] && profile_name="${attr}"

  # 1. Restore nix into PATH via fallback script paths.
  if ! command -v nix >/dev/null 2>&1; then
    if [[ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]]; then
      # shellcheck source=/dev/null
      source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
    elif [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
      # shellcheck source=/dev/null
      source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi
  fi

  # 2. If nix still unavailable -> error, never auto-install nix.
  if ! command -v nix >/dev/null 2>&1; then
    message_error "nix is not available in PATH. Install nix: https://nixos.org/download"
    return 1
  fi

  # 3. Binary guard first: short-circuit if the binary is already in PATH.
  if core::exists "${attr}"; then
    return 0
  fi

  # 4. Idempotent profile detection: if already in user profile, return 0.
  if core::internal::nix::package::profile::exists "${profile_name}"; then
    return 0
  fi

  # 5. nix-darwin: skip user-profile install and warn.
  if [[ "${ZSH_NIX_DARWIN_AVAILABLE:-}" == "true" ]]; then
    message_warning "Package ${attr} is managed by nix-darwin; skipping user-profile install."
    return 0
  fi

  # 6. Feature-detect verb and install.
  core::internal::nix::package::add-verb
  local verb="${ZSH_NIX_PROFILE_INSTALL_VERB:-install}"

  message_info "Installing ${attr}"
  if ! nix profile "${verb}" --extra-experimental-features 'nix-command flakes' "${package_ref}"; then
    message_error "Failed to install ${package_ref}"
    return 1
  fi
  message_success "Installed ${attr}"

  return 0
}