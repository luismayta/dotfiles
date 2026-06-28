#
# shellcheck shell=bash
# Core env vars
#

export CORE_MESSAGE_BREW="Please install brew or use core::install"
export CORE_MESSAGE_PARU="Please install paru or use the paru module at zsh/modules/paru"
export CORE_MESSAGE_RUST="Please install rust or use the rust module at zsh/modules/rust"
export CORE_MESSAGE_CARGO="Please install cargo or use the rust module at zsh/modules/rust"
export CORE_MESSAGE_RVM="Please install rvm or use the rvm module at zsh/modules/rvm"
export CORE_MESSAGE_NIX="Please install nix or use the nix module at zsh/modules/nix"
export CORE_MESSAGE_PYTHON="Please install pyenv or use the python module at zsh/modules/python"
export CORE_PROJECTS_BACKUP_PATH="${HOME}/backup"

export ANDROID_HOME="${HOME}/Library/Android/sdk"
export ANDROID_PLATFORM_VERSION="35"
export ANDROID_SDK_VERSION="35.0.1"
export ANDROID_FILE_REPOSITORIES="${HOME}/.android/repositories.cfg"
export FUNCNEST=5000

# Default editor
: "${EDITOR:=nvim}"

export NIX_CONF_DIR="${HOME}/.config/nix"
export NIXPKGS_ALLOW_UNFREE=1
