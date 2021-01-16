#!/usr/bin/env bash

PATH_REPO="$HOME/$app_name"

[ -r "$PATH_REPO/src/load.sh" ] && source "$PATH_REPO/src/load.sh"

cat <<EOF

--------------------------
 Install Programming Fonts!
--------------------------

EOF

# Create font dir if not exists
if [[ ! -e $FONTS_DIR ]]; then
    mkdir $FONTS_DIR || die "Could not make $FONTS_DIR"
fi

local font

for font in $FILES_FONTS; do
    msg font
    mv $font $FONTS_DIR || die "Could not install $file"
    success "Installed $file successfully"
done

cat <<EOF

--------------------------
 Fonts installed! Enjoy!
--------------------------

EOF
