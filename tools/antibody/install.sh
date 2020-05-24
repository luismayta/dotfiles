#!/usr/bin/env bash
# -*- coding: utf-8 -*-

cat <<EOF

----------------------------
 Antibody Plugin Manager ZSH
----------------------------

EOF

# shellcheck source=/dev/null
[ -r "${SCRIPT_DIR}/bootstrap.sh" ] && source "${SCRIPT_DIR}/bootstrap.sh"

curl -sfL git.io/antibody | sh -s - -b "${LOCAL_PATH_BIN}"

cat <<EOF

--------------------------
 Antobody installed! Enjoy!
--------------------------

EOF
