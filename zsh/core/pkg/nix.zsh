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
