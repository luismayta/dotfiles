# shellcheck shell=bash

ZSH_SMOLVM_ENABLED="${ZSH_SMOLVM_ENABLED:-true}"

export ZSH_SMOLVM_PACKAGE_NAME=smolvm
export ZSH_SMOLVM_VERSION=1.3.2
export ZSH_SMOLVM_BIN_PATH="${HOME}/.local/bin"
export ZSH_SMOLVM_DATA_PATH="${ZSH_SMOLVM_PATH}/data"