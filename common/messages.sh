#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "$(dirname "${BASH_SOURCE[0]}")/colors.sh" ] || { echo "FATAL: lib/colors.sh not found" >&2; exit 1; }
source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

function msg::info {
  printf '%s\n' "${C_BLUE}[INFO]: ${1}${C_RESET}" >&2
}

function msg::success {
  printf '%s\n' "${C_GREEN}[✔]: ${1}${C_RESET}" >&2
}

function msg::error {
  printf '%s\n' "${C_RED}[✘]: ${1}${C_RESET}" >&2
}

function msg::warn {
  printf '%s\n' "${C_YELLOW}[!]: ${1}${C_RESET}" >&2
}
