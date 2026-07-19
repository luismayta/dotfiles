# shellcheck shell=bash
ZSH_MPD_ENABLED="${ZSH_MPD_ENABLED:-true}"

export MPD_PACKAGE_NAME="mpd"
export MPD_MPC_PACKAGE_NAME="mpc"
export MPD_DATA_PATH="${ZSH_MPD_PATH}/data"
export MPD_SOCKET_PATH="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/mpd/socket"
