#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "script/bootstrap.sh" ] && source "script/bootstrap.sh"

cat <<EOF

--------------------------
    Test Install
--------------------------

EOF

if [ ! -e "$HOME/.dotfiles/.git" ]; then
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
    if [[ "${path}" == "PATH_RVM" ]]; then
        continue
    fi
    path="${!path}"
    if [[ ! -r $path ]]; then
        error "${path}"
    else
        success "${path}"
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

# shellcheck source=/dev/null
source "$HOME/.zshrc"