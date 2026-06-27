#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=/dev/null
[ -r "${ROOT_DIR}/common/colors.sh" ] || { echo "FATAL: lib/colors.sh not found" >&2; exit 1; }
source "${ROOT_DIR}/common/colors.sh"

# shellcheck source=/dev/null
[ -r "${ROOT_DIR}/common/messages.sh" ] || { echo "FATAL: lib/messages.sh not found" >&2; exit 1; }
source "${ROOT_DIR}/common/messages.sh"

cat <<EOF

--------------------------
    Test Install
--------------------------

EOF

if [ ! -e "$HOME/.dotfiles/.git" ]; then
    msg::error "Error in Install"
else
    msg::success "Yeah Install Done"
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
        msg::error "${path}"
    else
        msg::success "${path}"
    fi
done
unset path

cat <<EOF

--------------------------
    Test Executed
--------------------------

EOF
