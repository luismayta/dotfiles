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

for font in $FILES_FONTS; do
    ret='0'
    cp $font $FONTS_DIR || die "Could not install $font"
    success "Installed $font successfully"
done

cat <<EOF

--------------------------
 Fonts installed! Enjoy!
--------------------------

EOF
