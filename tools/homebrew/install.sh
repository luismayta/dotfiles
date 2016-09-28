#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=script/bootstrap.sh
[ -r "$SCRIPT_DIR/bootstrap.sh" ] && source "$SCRIPT_DIR/bootstrap.sh"

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
