#!/usr/bin/env bash

APP_NAME='.dotfiles'
PATH_REPO="$HOME/$APP_NAME"

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

for font in $FILES_FONTS; do
    ret='0'
    cp $font $FONTS_DIR || die "Could not install $file"
    success "Installed $font successfully"
done

cat <<EOF

--------------------------
 Fonts installed! Enjoy!
--------------------------

EOF
