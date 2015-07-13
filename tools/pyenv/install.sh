#!/usr/bin/env bash

APP_NAME='.dotfiles'
PATH_REPO="$HOME/$APP_NAME"

[ -r "$PATH_REPO/src/load.sh" ] && source "$PATH_REPO/src/load.sh"

cat <<EOF

-----------------------
    Pyenv Application
-----------------------

EOF

if [[ ! -e $PATH_PYENV ]]; then
    curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
fi


cat <<EOF

-----------------------------
    Install Pyenv Application
-----------------------------

EOF
