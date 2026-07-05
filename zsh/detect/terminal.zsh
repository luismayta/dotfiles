# =============================================================================
# Terminal Detection
# =============================================================================
# Reliable terminal detection via parent process.
# Env vars like TERM_PROGRAM and TMUX_SOCKET leak to child processes
# (e.g., when launching Alacritty from a WezTerm shell). The parent process
# of zsh is always the terminal emulator that spawned it — this cannot leak.
#
# Sets:
#   __ZSH_TMUX_AUTOSTART — "true" to allow tmux auto-start, "false" to block
# =============================================================================

# shellcheck shell=bash

if [[ -f /proc/$PPID/comm ]]; then
  __ZSH_PARENT_COMM=$(< /proc/$PPID/comm)
  __ZSH_PARENT_COMM="${__ZSH_PARENT_COMM:l}"  # lowercase
fi

case "${__ZSH_PARENT_COMM:-}" in
  wezterm*)
    __ZSH_TMUX_AUTOSTART="false"
    ;;
  alacritty*)
    __ZSH_TMUX_AUTOSTART="false"
    ;;
  ghostty*)
    __ZSH_TMUX_AUTOSTART="true"
    ;;
  *)
    __ZSH_TMUX_AUTOSTART="true"
    ;;
esac

unset __ZSH_PARENT_COMM
