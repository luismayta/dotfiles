#!/usr/bin/env bash
# -*- coding: utf-8 -*-

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
