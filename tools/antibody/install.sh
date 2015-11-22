#!/usr/bin/env bash
# -*- coding: utf-8 -*-

cat <<EOF

----------------------------
 Antibody Plugin Manager ZSH
----------------------------

EOF

[ -r "$ROOT/src/load.sh" ] && source "$ROOT/src/load.sh"

if [[ ! -e $FILE_ANTIBODY ]]; then
    wget -O antibody.tar.gz "http://antibody.elasticbeanstalk.com/latest/$(uname -s)/$(uname -m)"
    `mkdir -p "$PATH_ANTIBODY"`
    tar xzvf antibody.tar.gz -C $PATH_ANTIBODY
fi

cat <<EOF

--------------------------
 Antobody installed! Enjoy!
--------------------------

EOF
