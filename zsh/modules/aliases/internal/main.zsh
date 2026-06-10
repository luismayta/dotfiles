#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
source "${ALIASES_PATH}/internal/base.zsh"

# core utilities merged into internal
if type -p tmuxinator > /dev/null; then
    mux() {
        tmuxinator "${1}";
    }
fi

function net {
    ping 1.1.1.1 | grep -E --only-match --color=never '[0-9\.]+ ms'
}

# shellcheck source=/dev/null
source "${ALIASES_PATH}/internal/eza.zsh"

# shellcheck source=/dev/null
source "${ALIASES_PATH}/internal/docker.zsh"

# shellcheck source=/dev/null
source "${ALIASES_PATH}/internal/editor.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ALIASES_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ALIASES_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${ALIASES_PATH}/internal/helper.zsh"
