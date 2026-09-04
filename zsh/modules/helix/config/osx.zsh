#
# shellcheck shell=bash
# macOS-specific configuration overrides for helix module.
#
: "${ZSH_HELIX_PACKAGE_NAME:=hx}"

# Homebrew path detection
if [[ -x "/opt/homebrew/bin/hx" ]]; then
    : "${ZSH_HELIX_BIN_PATH:=/opt/homebrew/bin}"
elif [[ -x "/usr/local/bin/hx" ]]; then
    : "${ZSH_HELIX_BIN_PATH:=/usr/local/bin}"
fi
