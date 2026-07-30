# shellcheck shell=bash
ZSH_NIX_ENABLED="${ZSH_NIX_ENABLED:-true}"

export NIX_PACKAGE_NAME="nix"
export NIX_INSTALL_URL="https://nixos.org/nix/install"
export NIX_DATA_PATH="${ZSH_NIX_PATH}/data"

