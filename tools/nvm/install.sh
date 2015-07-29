#!/usr/bin/env bash
# -*- coding: utf-8 -*-

[ -r "$ROOT/src/load.sh" ] && source "$ROOT/src/load.sh"

cat <<EOF

--------------------------
    Install Nvm!
--------------------------

EOF

# Create font dir if not exists
if [[ ! -e $PATH_NVM ]]; then

    curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

fi

cat <<EOF

--------------------------
 Nvm installed! Enjoy!
--------------------------

EOF
