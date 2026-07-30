# shellcheck shell=bash
# Linux-specific Nix config — sync paths

export NIX_CONF_SOURCE="${DOTFILES}/nix/nix.conf"
export NIX_CONF_DIR="${HOME}/.config/nix"
export NIX_CONF_TARGET="${NIX_CONF_DIR}/nix.conf"
