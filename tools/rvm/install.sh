#!/usr/bin/env bash

[ -r "$SRC_DIR/load.sh" ] && source "$SRC_DIR/load.sh"

cat <<EOF

--------------------
 Rvm Version Manager
--------------------

EOF

if [[ -e $PATH_RVM ]]; then
    msg "Installed RVM"
    exit 1
fi

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

\curl -sSL https://get.rvm.io | bash -s stable

cat <<EOF

--------------------------
 RVM installed! Enjoy!
--------------------------

EOF
