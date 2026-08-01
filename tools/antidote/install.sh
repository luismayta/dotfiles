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
[ -r "${SCRIPT_PATH:-}/bootstrap.sh" ] && source "${SCRIPT_PATH:-}/bootstrap.sh"

readonly ZDOTDIR="${ZDOTDIR:-${HOME}}"
readonly ANTIDOTE_PATH="${ZDOTDIR}/.antidote"

if [[ ! -d "${ANTIDOTE_PATH}" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "${ANTIDOTE_PATH}"
else
  msg "antidote already installed at ${ANTIDOTE_PATH}, skipping"
fi

cat <<EOF

--------------------------
 Antidote installed! Enjoy!
--------------------------

EOF
