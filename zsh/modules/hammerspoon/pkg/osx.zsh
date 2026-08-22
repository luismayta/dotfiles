# shellcheck shell=bash
# macOS-specific hammerspoon public functions

# Auto-install hammerspoon if not present (macOS only)
if ! core::exists hammerspoon; then
    hammerspoon::install
fi
