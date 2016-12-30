#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "$SCRIPT_DIR/bootstrap.sh" ] && source "$SCRIPT_DIR/bootstrap.sh"

cat <<EOF

--------------------
 Go Version Manager
--------------------

EOF

if [[ ! -e $PATH_GVM ]]; then
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
fi

cat <<EOF

--------------------------
 Gvm installed! Enjoy!
--------------------------

EOF
