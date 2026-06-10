#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

trap 'echo "[ERROR]: antidote install failed at line ${LINENO}"' ERR

cat <<EOF

----------------------------
 Antidote Plugin Manager ZSH
----------------------------

EOF

# shellcheck source=/dev/null
[ -r "${SCRIPT_DIR:-}/bootstrap.sh" ] && source "${SCRIPT_DIR:-}/bootstrap.sh"

readonly ZDOTDIR="${ZDOTDIR:-${HOME}}"

git clone --depth=1 https://github.com/mattmc3/antidote.git "${ZDOTDIR}/.antidote"

cat <<EOF

--------------------------
 Antidote installed! Enjoy!
--------------------------

EOF
