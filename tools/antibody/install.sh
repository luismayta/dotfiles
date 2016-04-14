#!/usr/bin/env bash
# -*- coding: utf-8 -*-

cat <<EOF

----------------------------
 Antibody Plugin Manager ZSH
----------------------------

EOF

[ -r "$SRC_DIR/load.sh" ] && source "$SRC_DIR/load.sh"

curl -s https://raw.githubusercontent.com/getantibody/installer/master/install | bash -s

cat <<EOF

--------------------------
 Antobody installed! Enjoy!
--------------------------

EOF
