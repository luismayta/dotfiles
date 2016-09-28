#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=script/bootstrap.sh
[ -r "$SCRIPT_DIR/bootstrap.sh" ] && source "$SCRIPT_DIR/bootstrap.sh"

cat <<EOF

----------------------------
 Mac-Cli Install
----------------------------

EOF

curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install

cat <<EOF

--------------------------
 Mac-Cli installed! Enjoy!
--------------------------

EOF
