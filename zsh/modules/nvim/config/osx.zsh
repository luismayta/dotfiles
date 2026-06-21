# shellcheck shell=bash
#
# macOS-specific configuration overrides for nvim module.
# Overrides nvim binary path for Homebrew installations.

# Prefer Homebrew nvim on Apple Silicon
if [[ -x "/opt/homebrew/bin/nvim" ]]; then
    : "${NVIM_BIN_PATH:=/opt/homebrew/bin}"
elif [[ -x "/usr/local/bin/nvim" ]]; then
    : "${NVIM_BIN_PATH:=/usr/local/bin}"
fi
