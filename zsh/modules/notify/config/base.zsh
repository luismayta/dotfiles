# shellcheck shell=bash
ZSH_NOTIFY_ENABLED="${ZSH_NOTIFY_ENABLED:-true}"
# Base notify configuration variables

# Notification provider: noti, notify-send, or auto (default)
ZSH_NOTIFY_PROVIDER="${ZSH_NOTIFY_PROVIDER:-noti}"

export NOTIFY_PACKAGE_NAME=notify
export ZSH_NOTIFY_DATA_PATH="${ZSH_NOTIFY_PATH}/data"
export ZSH_NOTIFY_ASSETS_PATH="${ZSH_NOTIFY_DATA_PATH}/assets"
export ZSH_NOTIFY_ASSETS_SOUND_PATH="${ZSH_NOTIFY_ASSETS_PATH}/sounds"
export ZSH_NOTIFY_SOUND_THEME="${ZSH_NOTIFY_SOUND_THEME:-r2d2}"

# Notify thresholds and settings
typeset -g _ZSH_NOTIFY_TIME_THRESHOLD=10
typeset -g _ZSH_NOTIFY_RE_SKIP_COMMANDS="^[^ ]*(ssh|vi|vim|nvim|tmux|tig|man|cat|more|less)"
typeset -g _ZSH_NOTIFY_TERMINAL_BUNDLE="com.googlecode.iterm2"