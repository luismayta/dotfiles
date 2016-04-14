#!/usr/bin/env bash
# -*- coding: utf-8 -*-

[ -r "$SRC_DIR/load.sh" ] && source "$SRC_DIR/load.sh"

cat <<EOF

--------------------
    Git Extras
--------------------

EOF

curl -sSL http://git.io/git-extras-setup | sudo bash /dev/stdin

cat <<EOF

--------------------------
 Git Extras installed! Enjoy!
--------------------------

EOF
