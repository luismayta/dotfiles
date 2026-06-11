#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

trap 'echo "[ERROR]: fonts install failed at line ${LINENO}"' ERR

# shellcheck source=/dev/null
[ -r "${SCRIPT_DIR:-}/bootstrap.sh" ] && source "${SCRIPT_DIR:-}/bootstrap.sh"

cat <<EOF

--------------------------
 Install Programming Fonts!
--------------------------

EOF

readonly find_command="find \"${PATH_FONTS_REPO:-}\" \( -name '*.[o,t]tf' -or -name '*.pcf.gz' \) -type f -print0"

eval "${find_command}" | xargs -0 -I % cp "%" "${FONTS_DIR:-${HOME}/.fonts}/" || echo "Could not copy fonts to ${FONTS_DIR:-${HOME}/.fonts}"

# Reset font cache on Linux
if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "${FONTS_DIR:-${HOME}/.fonts}"
fi

cd "${FONTS_DIR:-${HOME}/.fonts}" && curl -fLo "Sauce Code Pro Medium Nerd Font Complete Mono.ttf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SourceCodePro/Medium/complete/Sauce%20Code%20Pro%20Medium%20Nerd%20Font%20Complete%20Mono.ttf

cat <<EOF

--------------------------
 Fonts installed! Enjoy!
--------------------------

EOF
