#!/usr/bin/env bash
# -*- coding: utf-8 -*-

[ -r "$ROOT/src/load.sh" ] && source "$ROOT/src/load.sh"

cat <<EOF

--------------------
 tmux themepack
--------------------

EOF

if [[ ! -e $PATH_THEMEPACK ]]; then
    git clone https://github.com/jimeh/tmux-themepack.git $PATH_THEMEPACK
fi

cat <<EOF

----------------------------------
 tmux themepack installed! Enjoy!
----------------------------------

EOF
