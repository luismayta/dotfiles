# shellcheck shell=bash
ZSH_GIT_ENABLED="${ZSH_GIT_ENABLED:-true}"
# shellcheck disable=SC2154 # ZSH_GIT_PATH defined in plugin.zsh

export GIT_PACKAGE_NAME=git
export SCMPUFF_PACKAGE_NAME=scmpuff

export HOME_CONFIG_PATH="${HOME}"/.config
export GIT_FILE_SETTINGS="${HOME}"/.gitconfig
export GIT_PROVISION_HOOKS_PATH="provision/git/hooks/"
export GIT_DATA_PATH="${ZSH_GIT_PATH}/data"
export ZSH_GIT_HOOKS_PATH="${GIT_DATA_PATH}/hooks/"
export ZSH_GIT_REGEX_IS_HOOK="^(prepare-commit-msg)"
export ZSH_GIT_REGEX_DOMAIN_ENABLED="(github.com|bitbucket.org)"

GITHUB_USER="$(git config github.user 2>/dev/null || true)"
export GITHUB_USER

BITBUCKET_USER="$(git config bitbucket.user 2>/dev/null || true)"
export BITBUCKET_USER

GITLAB_USER="$(git config gitlab.user 2>/dev/null || true)"
export GITLAB_USER
