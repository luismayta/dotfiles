# shellcheck shell=bash
ZSH_MPD_ENABLED="${ZSH_MPD_ENABLED:-true}"

export MPD_PACKAGE_NAME="mpd"
export MPD_MPC_PACKAGE_NAME="mpc"
export MPD_FMT_PACKAGE_NAME="fmt"
export MPD_NCMP_CPP_PACKAGE_NAME="ncmpcpp"
export MPD_DATA_PATH="${ZSH_MPD_PATH}/data"
export MPD_NCMP_CPP_DATA_PATH="${ZSH_MPD_PATH}/data/ncmpcpp"
export MPD_NCMP_CPP_CONFIG_PATH="${HOME}/.ncmpcpp"
export MPD_CONFIG_DATA_PATH="${ZSH_MPD_PATH}/data"
export MPD_CONFIG_PATH="${HOME}/.config/mpd"
export MPD_SOCKET_PATH="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/mpd/socket"
