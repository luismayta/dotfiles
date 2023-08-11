#!/usr/bin/env bash
# -*- coding: utf-8 -*-

cat <<EOF

----------------------------
 Antidote Plugin Manager ZSH
----------------------------

EOF

# shellcheck source=/dev/null
[ -r "${SCRIPT_DIR}/bootstrap.sh" ] && source "${SCRIPT_DIR}/bootstrap.sh"

git clone --depth=1 https://github.com/mattmc3/antidote.git "${HOME}"/.antidote

cat <<EOF

--------------------------
 Antidote installed! Enjoy!
--------------------------

EOF