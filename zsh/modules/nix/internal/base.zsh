# shellcheck shell=bash
# Nix internal — delegates installation to core

nix::internal::nix::install() {
  core::nix::ensure
}

# nix::internal::config::sync — sync config files to home
nix::internal::config::sync() {
    rsync -avzh --progress "${NIX_DATA_PATH}/sync/" "${HOME}/"
}
