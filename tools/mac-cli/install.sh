#!/usr/bin/env bash
# -*- coding: utf-8 -*-

cat <<EOF

----------------------------
 Mac-Cli Install
----------------------------

EOF

# shellcheck source=src/load.sh
[ -r "$SRC_DIR/load.sh" ] && source "$SRC_DIR/load.sh"

curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install

cat <<EOF

--------------------------
 Mac-Cli installed! Enjoy!
--------------------------

EOF
