# shellcheck shell=bash
# Nix internal — delegates installation to core

function nix::internal::nix::install {
  core::nix::ensure
}

# nix::internal::config::sync — sync config files to home
function nix::internal::config::sync {
    rsync -avzh --quiet "${NIX_DATA_PATH}/nix/" "${NIX_CONF_DIR}/"
}