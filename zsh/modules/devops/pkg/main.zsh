#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${DEVOPS_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${DEVOPS_PATH}/pkg/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/helper.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/alias.zsh"
