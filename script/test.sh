#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=script/bootstrap.sh
[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

cat <<EOF

--------------------------
    Test Install
--------------------------

EOF

ret="0"
if [ ! -e "$HOME/.dotfiles/.git" ]; then
    ret="1"
    error "Error in Install"
else
    success "Yeah Install Done"
fi

cat <<EOF

--------------------------
    Test Bootstrap
--------------------------

EOF

for path in ${!PATH_@}; do
    path="${!path}"
    ret="0"
    if [[ ! -r $path ]]; then
        ret="1"
        error $path
    else
        success $path
    fi
done
unset path

cat <<EOF

--------------------------
    Test Executed
--------------------------

EOF

cat <<EOF

--------------------------
    Test Load Source
--------------------------

EOF

source "$HOME/.zshrc"