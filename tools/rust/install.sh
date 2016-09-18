#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=src/load.sh
[ -r "$SRC_DIR/load.sh" ] && source "$SRC_DIR/load.sh"

cat <<EOF

-------
 Rust
-------

EOF
RESPONSE_PATH=is_program_exist "rustc"
if [ ! "$RESPONSE_PATH" -eq '0' ]; then
    curl -sSf https://static.rust-lang.org/rustup.sh | sh
fi

cat <<EOF

--------------------------
 Rust installed! Enjoy!
--------------------------

EOF
