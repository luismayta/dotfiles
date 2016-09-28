#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=script/bootstrap.sh
[ -r "$SCRIPT_DIR/bootstrap.sh" ] && source "$SCRIPT_DIR/bootstrap.sh"

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
