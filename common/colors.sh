#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck disable=SC2034 # consumed by sourcing scripts
# Idempotency guard: re-sourcing in a shell that already loaded these
# readonly vars would fail with "readonly variable".
if [[ -v C_RED ]]; then
  # shellcheck disable=SC2317 # return is intentional (fallback for direct exec)
  return 0 2>/dev/null || true
fi

readonly C_RED="\033[0;31m"
readonly C_GREEN="\033[0;32m"
readonly C_BLUE="\033[0;36m"
readonly C_YELLOW="\033[0;33m"
readonly C_RESET="\033[0m"
