#!/usr/bin/env bash
# -*- coding: utf-8 -*-

cat <<EOF

----------------------------
 Antigen Plugin Manager ZSH
----------------------------

EOF

[ -r "$ROOT/src/load.sh" ] && source "$ROOT/src/load.sh"

if [[ ! -e $FILE_ANTIGEN ]]; then
    `mkdir -p "$PATH_ANTIGEN"`
    curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > $FILE_ANTIGEN
fi

cat <<EOF

--------------------------
 Antigen installed! Enjoy!
--------------------------

EOF
