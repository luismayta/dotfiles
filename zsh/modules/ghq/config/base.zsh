# shellcheck shell=bash
ZSH_GHQ_ENABLED="${ZSH_GHQ_ENABLED:-true}"
# Base ghq configuration

export ZSH_GHQ_DATA_PATH="${ZSH_GHQ_PATH}/data"

export ZSH_GHQ_PACKAGE_NAME=ghq
ZSH_GHQ_ROOT="${ZSH_GHQ_ROOT:-${GHQ_ROOT:-${HOME}/Projects/src}}"
export ZSH_GHQ_ROOT

export ZSH_GHQ_FILE_COOKIECUTTER="${ZSH_GHQ_PATH}/data/data.json"
export ZSH_GHQ_CACHE_PATH="${HOME}/.cache/ghq"
export ZSH_GHQ_CACHE_NAME="ghq.txt"
export ZSH_GHQ_CACHE_PROJECT="${ZSH_GHQ_CACHE_PATH}/${ZSH_GHQ_CACHE_NAME}"

export ZSH_GHQ_REGEX_IS_REPOSITORY="^(git:|git@|ssh://|http://|https://)"

ZSH_GHQ_GITHUB_USER="$(git config --global github.user 2>/dev/null || echo "")"
export ZSH_GHQ_GITHUB_USER

# Backward-compat aliases (remove in next cleanup cycle)
export GHQ_PACKAGE_NAME="${ZSH_GHQ_PACKAGE_NAME}"
export GHQ_ROOT="${ZSH_GHQ_ROOT}"
export GHQ_FILE_COOKIECUTTER="${ZSH_GHQ_FILE_COOKIECUTTER}"
export GHQ_CACHE_PATH="${ZSH_GHQ_CACHE_PATH}"
export GHQ_CACHE_NAME="${ZSH_GHQ_CACHE_NAME}"
export GHQ_CACHE_PROJECT="${ZSH_GHQ_CACHE_PROJECT}"
export GHQ_REGEX_IS_REPOSITORY="${ZSH_GHQ_REGEX_IS_REPOSITORY}"
export GITHUB_USER="${ZSH_GHQ_GITHUB_USER}"
