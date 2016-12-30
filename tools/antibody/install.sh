#!/usr/bin/env bash
# -*- coding: utf-8 -*-

cat <<EOF

----------------------------
 Antibody Plugin Manager ZSH
----------------------------

EOF

# shellcheck source=/dev/null
[ -r "$SCRIPT_DIR/bootstrap.sh" ] && source "$SCRIPT_DIR/bootstrap.sh"

curl -s https://raw.githubusercontent.com/getantibody/installer/master/install | bash -s

cat <<EOF

--------------------------
 Antobody installed! Enjoy!
--------------------------

EOF
