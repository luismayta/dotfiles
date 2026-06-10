#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${DEVOPS_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${DEVOPS_PATH}/internal/linux.zsh"
  ;;
esac

# core/ utilities merged into internal (core/ is empty in this repo, but adding for consistency)
# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/helper.zsh"
