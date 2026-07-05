# shellcheck shell=bash
# Linux-specific herdr configuration
export HERDR_CLIPBOARD_COPY_CMD="${HERDR_CLIPBOARD_COPY_CMD:-xclip -selection clipboard}"
export HERDR_CLIPBOARD_PASTE_CMD="${HERDR_CLIPBOARD_PASTE_CMD:-xclip -selection clipboard -o}"
