# shellcheck shell=bash
# nix-darwin internal — nix installation and management

nix::darwin::internal::cleanup() {
  local backup
  for backup in /etc/bashrc.backup-before-nix /etc/zshrc.backup-before-nix; do
    [[ -f "${backup}" ]] || continue
    grep -q -i "nix" "${backup}" 2>/dev/null && continue
    sudo rm -f "${backup}" 2>/dev/null
  done
}

nix::darwin::internal::ensure() {
  command -v nix &>/dev/null && return 0

  # Try sourcing existing nix profiles
  local profile
  for profile in "${HOME}/.nix-profile/etc/profile.d/nix.sh" "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"; do
    if [[ -f "${profile}" ]]; then
      # shellcheck source=/dev/null
      source "${profile}"
      command -v nix &>/dev/null && return 0
    fi
  done

  # Sudo needed for installation
  if ! sudo -n true 2>/dev/null; then
    message_warning "nix requires sudo for installation (once). Run: sudo -v"
    message_info "Then reload your shell to complete installation."
    return 1
  fi

  nix::darwin::internal::cleanup

  message_info "Installing nix..."
  curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh

  # Source profile after installation
  [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]] && source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

  if command -v nix &>/dev/null; then
    message_success "nix installed successfully"
  else
    message_error "nix installation failed. Install manually: https://nixos.org/download"
    return 1
  fi
}

nix::darwin::internal::rebuild() {
  if [[ "${ZSH_NIX_DARWIN_AVAILABLE}" != "true" ]]; then
    message_error "nix-darwin: not detected. Cannot rebuild."
    return 1
  fi
  sudo darwin-rebuild switch --flake "${DOTFILES_PATH}/nix/darwin#$(hostname -s)"
}

nix::darwin::internal::update() {
  if [[ "${ZSH_NIX_DARWIN_AVAILABLE}" != "true" ]]; then
    message_error "nix-darwin: not detected. Cannot update."
    return 1
  fi
  nix flake update && nix::darwin::internal::rebuild
}

nix::darwin::internal::status() {
  if [[ "${ZSH_NIX_DARWIN_AVAILABLE}" == "true" ]]; then
    message_info "nix-darwin: active"
    message_info "profile: /nix/var/nix/profiles/system"
    message_info "hostname: $(scutil --get ComputerName 2>/dev/null || echo 'unknown')"
  else
    message_warning "nix-darwin: not detected"
    message_info "To bootstrap, run:"
    message_info "  nix run nix-darwin -- switch --flake ${DOTFILES_PATH}/nix/darwin#$(hostname -s)"
  fi
}
