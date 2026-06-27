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
  core::nix::exists || core::nix::install
}
