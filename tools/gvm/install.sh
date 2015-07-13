#!/usr/bin/env bash

APP_NAME='.dotfiles'
PATH_REPO="$HOME/$APP_NAME"

[ -r "$PATH_REPO/src/load.sh" ] && source "$PATH_REPO/src/load.sh"

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
