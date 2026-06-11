# shellcheck shell=bash

if core::exists hyprctl; then
    alias hypr-reload='hypr::reload'
    alias hypr-check='hypr::check'
    alias hypr-ws='hypr::workspaces'
fi
