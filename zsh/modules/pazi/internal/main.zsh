#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
source "${PAZI_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${PAZI_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${PAZI_PATH}/internal/linux.zsh"
  ;;
esac

if ! core::exists pazi; then pazi::internal::pazi::install; fi
pazi::internal::pazi::load
