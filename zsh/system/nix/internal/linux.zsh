# shellcheck shell=bash
# Linux-specific Nix internals — nix.conf sync

function nix::internal::linux::sync::nix_conf {
  if [[ ! -d "${NIX_CONF_DIR}" ]]; then
    mkdir -p "${NIX_CONF_DIR}"
  fi

  rsync -avzh --quiet "${NIX_CONF_SOURCE}" "${NIX_CONF_TARGET}"
}