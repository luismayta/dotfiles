# shellcheck shell=bash
# Linux-specific herdr configuration
export ZSH_HERDR_CLIPBOARD_COPY_CMD="${ZSH_HERDR_CLIPBOARD_COPY_CMD:-xclip -selection clipboard}"
export ZSH_HERDR_CLIPBOARD_PASTE_CMD="${ZSH_HERDR_CLIPBOARD_PASTE_CMD:-xclip -selection clipboard -o}"

# Backward-compatible aliases
export HERDR_CLIPBOARD_COPY_CMD="${ZSH_HERDR_CLIPBOARD_COPY_CMD}"
export HERDR_CLIPBOARD_PASTE_CMD="${ZSH_HERDR_CLIPBOARD_PASTE_CMD}"
