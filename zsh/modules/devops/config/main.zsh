#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/config/base.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/config/tfenv.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/config/atuin.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/config/bruno.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/config/cloudflared.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/config/caddy.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/config/worktrunk.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${DEVOPS_PATH}/config/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${DEVOPS_PATH}/config/linux.zsh"
  ;;
esac