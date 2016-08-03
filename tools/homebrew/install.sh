#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=src/load.sh
[ -r "$SRC_DIR/load.sh" ] && source "$SRC_DIR/load.sh"

cat <<EOF

----------
 HomeBrew
----------

EOF

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

cat <<EOF

---------------------------
 HomeBrew installed! Enjoy!
---------------------------

EOF
