#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function vim {
  if core::exists nvim > /dev/null; then
    nvim ${@}
  else
    vim ${@}
  fi
}
