#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

[ -r "provision/script/bootstrap.sh" ] || { echo "[ERROR]: bootstrap.sh not found at provision/script/bootstrap.sh"; exit 1; }
# shellcheck source=/dev/null
source "provision/script/bootstrap.sh"

if [[ "${TEST:-}" = 'true' ]]; then
    initialize
    exit 0
fi
replace_files
