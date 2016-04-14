#!/usr/bin/env bash
# -*- coding: utf-8 -*-

[ -r "$SRC_DIR/load.sh" ] && source "$SRC_DIR/load.sh"

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
