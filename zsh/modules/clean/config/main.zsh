#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
source "${ZSH_CLEAN_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_CLEAN_PATH}/config/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_CLEAN_PATH}/config/linux.zsh"
  ;;
esac
