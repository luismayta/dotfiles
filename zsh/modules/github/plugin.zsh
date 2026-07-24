#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

[[ -n "${__ZSH_GITHUB_LOADED:-}" ]] && return
__ZSH_GITHUB_LOADED=1

ZSH_GITHUB_PATH="$(dirname "${0}")"

message_info "Loading module: github"

# shellcheck source=/dev/null
source "${ZSH_GITHUB_PATH}/config/main.zsh"
$ZSH_GITHUB_ENABLED || return

# shellcheck source=/dev/null
source "${ZSH_GITHUB_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_GITHUB_PATH}/pkg/main.zsh"
