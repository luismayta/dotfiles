#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "$SCRIPT_DIR/bootstrap.sh" ] && source "$SCRIPT_DIR/bootstrap.sh"

cat <<EOF

-------
 Rust
-------

EOF

RESPONSE_PATH=is_program_exist "rustc"

if [[ ! -e "$RESPONSE_PATH" ]]; then
    bash < <(curl -s -S -L https://static.rust-lang.org/rustup.sh)
fi

cat <<EOF

--------------------------
 Rust installed! Enjoy!
--------------------------

EOF
