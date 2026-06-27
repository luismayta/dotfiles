#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BOOTSTRAP="${ROOT_DIR}/provision/script/bootstrap.sh"
[ -r "${BOOTSTRAP}" ] || { echo "[ERROR]: bootstrap.sh not found at ${BOOTSTRAP}"; exit 1; }
# shellcheck source=/dev/null
source "${BOOTSTRAP}"

if [[ "${TEST:-}" = 'true' ]]; then
    initialize
    exit 0
fi
replace_files
