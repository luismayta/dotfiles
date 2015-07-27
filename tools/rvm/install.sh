#!/usr/bin/env bash

cat <<EOF

--------------------
 Rvm Version Manager
--------------------

EOF

[ -r "$ROOT/src/load.sh" ] && source "$ROOT/src/load.sh"

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
