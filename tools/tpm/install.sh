#!/usr/bin/env bash

APP_NAME='.dotfiles'
PATH_REPO="$HOME/$APP_NAME"

[ -r "$PATH_REPO/src/load.sh" ] && source "$PATH_REPO/src/load.sh"

cat <<EOF

-----------------------
    Tmux Plugin Manager
-----------------------

EOF

if [[ ! -e $PATH_TPM ]]; then
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi


cat <<EOF

----------------------------------
    Install Tmux Plugin Manager
----------------------------------

EOF
