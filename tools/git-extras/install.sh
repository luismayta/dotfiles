#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=script/bootstrap.sh
[ -r "$SCRIPT_DIR/bootstrap.sh" ] && source "$SCRIPT_DIR/bootstrap.sh"

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
