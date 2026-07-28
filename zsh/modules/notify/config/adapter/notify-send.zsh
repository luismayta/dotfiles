# shellcheck shell=bash
# notify-send domain configuration variables

# Package name for core::install
# notify-send is part of libnotify on Arch, libnotify-bin on Debian
export ZSH_NOTIFY_NOTIFY_SEND_PACKAGE_NAME="libnotify"

# Icon path for notifications
ZSH_NOTIFY_NOTIFY_SEND_ICON_PATH="${ZSH_NOTIFY_ASSETS_PATH}"
