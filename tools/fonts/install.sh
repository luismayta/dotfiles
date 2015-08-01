#!/usr/bin/env bash
# -*- coding: utf-8 -*-

cat <<EOF

--------------------------
 Install Programming Fonts!
--------------------------

EOF

[ -r "$ROOT/src/load.sh" ] && source "$ROOT/src/load.sh"

# Create font dir if not exists
if [[ ! -e $FONTS_DIR ]]; then
    mkdir $FONTS_DIR || die "Could not make $FONTS_DIR"
fi

find_command="find \"$PATH_FONTS_REPO\" \( -name '*.[o,t]tf' -or -name '*.pcf.gz' \) -type f -print0"

eval $find_command | xargs -0 -I % cp "%" "$FONTS_DIR/"

# Reset font cache on Linux
if [[ -n `which fc-cache` ]]; then
    fc-cache -f $FONTS_DIR
fi

cat <<EOF

--------------------------
 Fonts installed! Enjoy!
--------------------------

EOF
