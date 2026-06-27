# shellcheck shell=bash
# Nix internal — delegates installation to core

nix::internal::nix::install() {
  core::nix::ensure
}
