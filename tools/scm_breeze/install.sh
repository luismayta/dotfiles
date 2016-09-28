#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=script/bootstrap.sh
[ -r "$SCRIPT_DIR/bootstrap.sh" ] && source "$SCRIPT_DIR/bootstrap.sh"

cat <<EOF

--------------------
 Install scm breeze
--------------------

EOF

if [[ ! -e $PATH_SCM_BREEZE ]]; then
    git clone git://github.com/ndbroadbent/scm_breeze.git $PATH_SCM_BREEZE
    $PATH_SCM_BREEZE/install.sh
fi

cat <<EOF

--------------------------
 Scm Breeze installed! Enjoy!
--------------------------

EOF
