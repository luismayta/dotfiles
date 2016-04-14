#!/usr/bin/env bash
# -*- coding: utf-8 -*-

[ -r "$SRC_DIR/load.sh" ] && source "$SRC_DIR/load.sh"

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
