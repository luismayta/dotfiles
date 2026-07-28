# shellcheck shell=bash
# noti domain configuration variables

# Telegram credentials
ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN="${ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN:-}"
ZSH_NOTIFY_NOTI_TELEGRAM_CHATID="${ZSH_NOTIFY_NOTI_TELEGRAM_CHATID:-}"

# Package name for core::install
export ZSH_NOTIFY_NOTI_PACKAGE_NAME="noti"

# Data path (templates)
export ZSH_NOTIFY_NOTI_DATA_PATH="${ZSH_NOTIFY_PATH}/data/noti"

# Config paths (OS-specific, but same for both)
ZSH_NOTIFY_NOTI_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/noti"
ZSH_NOTIFY_NOTI_CONFIG_FILE="${ZSH_NOTIFY_NOTI_CONFIG_DIR}/noti.yaml"
