# shellcheck shell=bash
# macOS-specific hammerspoon public functions

# Auto-install hammerspoon if not present (macOS only, app-bundle check)
if ! hammerspoon::internal::is_installed; then
    hammerspoon::install
fi
