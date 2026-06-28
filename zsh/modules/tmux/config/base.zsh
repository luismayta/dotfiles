# shellcheck shell=bash
ZSH_TMUX_ENABLED="${ZSH_TMUX_ENABLED:-true}"

export HOME_CONFIG_PATH="${HOME}"/.config
export TMUX_FILE_SETTINGS="${HOME}"/.tmux.conf
export TMUX_PACKAGE_NAME=tmux
export TMUX_CONFIG_PATH="${HOME_CONFIG_PATH}/tmux"
export TMUX_TPM_PATH="${HOME}"/.tmux/plugins/tpm

export TMUXINATOR_TEMPLATE_PATH="${HOME_CONFIG_PATH}/tmuxinator"
export TMUXINATOR_DEFAULT_TEMPLATE="default"

export TMUX_INSTALL_URL_TPM="https://github.com/tmux-plugins/tpm"

