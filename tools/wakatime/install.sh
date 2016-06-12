#!/usr/bin/env bash
# -*- coding: utf-8 -*-

[ -r "$SRC_DIR/load.sh" ] && source "$SRC_DIR/load.sh"

cat <<EOF

--------------------
 Wakatime install
--------------------

EOF

if [[ ! -e $PATH_WAKATIME ]]; then
    mkdir -p $PATH_WAKATIME
    cd $PATH_WAKATIME
    wget -O $NAME_WAKATIME_BASH $URL_WAKATIME_BASH
fi

cat <<EOF

--------------------------
 Gvm installed! Enjoy!
--------------------------

EOF
