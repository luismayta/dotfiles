#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=script/bootstrap.sh
[ -r "$SCRIPT_DIR/bootstrap.sh" ] && source "$SCRIPT_DIR/bootstrap.sh"

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
