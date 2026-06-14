# shellcheck shell=bash
# macOS-specific apps config

export APPS_IDE_TOOLS_OSX=(raycast)
export APPS_DEVOPS_OSX=(unite orbstack)
export APPS_BROWSER_OSX=(comet)
export APPS_VPN_CLIENTS_OSX=(tunnelblick)

APPS_PACKAGES+=(
    "${APPS_IDE_TOOLS_OSX[@]}"
    "${APPS_DEVOPS_OSX[@]}"
    "${APPS_BROWSER_OSX[@]}"
    "${APPS_VPN_CLIENTS_OSX[@]}"
)