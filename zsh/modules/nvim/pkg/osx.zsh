# shellcheck shell=bash
#
# macOS-specific public API for nvim module.

# On macOS, ensure brew nvim is preferred
function nvim::path::brew {
    if [[ -x "/opt/homebrew/bin/nvim" ]]; then
        echo "/opt/homebrew/bin"
    elif [[ -x "/usr/local/bin/nvim" ]]; then
        echo "/usr/local/bin"
    fi
}
