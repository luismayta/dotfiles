# shellcheck shell=bash
ZSH_GHQ_ENABLED="${ZSH_GHQ_ENABLED:-true}"
# Base ghq configuration

export GHQ_PACKAGE_NAME=ghq
GHQ_ROOT=$(ghq root 2>/dev/null || echo "${PROJECTS:-${HOME}/projects}")
export GHQ_ROOT

export GHQ_FILE_COOKIECUTTER="${ZSH_GHQ_PATH}/resources/data.json"
export GHQ_CACHE_PATH="${HOME}/.cache/ghq"
export GHQ_CACHE_NAME="ghq.txt"
export GHQ_CACHE_PROJECT="${GHQ_CACHE_PATH}/${GHQ_CACHE_NAME}"

export GHQ_REGEX_IS_REPOSITORY="^(git:|git@|ssh://|http://|https://)"

GITHUB_USER="$(git config --global github.user 2>/dev/null || echo "")"
export GITHUB_USER

