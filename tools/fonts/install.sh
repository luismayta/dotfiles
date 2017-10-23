#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# shellcheck source=/dev/null
[ -r "$SCRIPT_DIR/bootstrap.sh" ] && source "$SCRIPT_DIR/bootstrap.sh"

cat <<EOF

--------------------------
 Install Programming Fonts!
--------------------------

EOF

find_command="find \"${PATH_FONTS_REPO}\" \( -name '*.[o,t]tf' -or -name '*.pcf.gz' \) -type f -print0"

eval "${find_command}" | xargs -0 -I % cp "%" "${FONTS_DIR}/" || die "Could not copy fonts to $FONTS_DIR"

# Reset font cache on Linux
if [[ -n $(which fc-cache) ]]; then
    fc-cache -f "${FONTS_DIR}"
fi

cd "$FONTS_DIR/" && curl -fLo "Sauce Code Pro Medium Nerd Font Complete Mono.ttf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SourceCodePro/Medium/complete/Sauce%20Code%20Pro%20Medium%20Nerd%20Font%20Complete%20Mono.ttf

cat <<EOF

--------------------------
 Fonts installed! Enjoy!
--------------------------

EOF
