# shellcheck shell=bash
#
# macOS-specific internal logic for nvim module.
# Detects nvim binary from Homebrew paths.

# Detect nvim from Homebrew if not already in PATH
if ! core::exists nvim && [[ -x "/opt/homebrew/bin/nvim" ]]; then
  export PATH="/opt/homebrew/bin:${PATH}"
fi
