#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
source "${CLEAN_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${CLEAN_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${CLEAN_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${CLEAN_PATH}/internal/helper.zsh"
