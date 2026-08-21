# shellcheck shell=bash
# Nix internal — delegates installation to core

function nix::internal::nix::install {
  if ! core::nix::exists; then
    message_warning "Nix is not installed. Install it with 'nix::install' or https://nixos.org/download"
    return 0
  fi
}

# nix::internal::config::sync — sync config files to home
function nix::internal::config::sync {
    rsync -avzh --quiet "${NIX_DATA_PATH}/nix/" "${NIX_CONF_PATH}/"
    nix::direnv::internal::sync
}