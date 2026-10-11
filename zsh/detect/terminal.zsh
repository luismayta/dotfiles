# =============================================================================
# Terminal Detection
# =============================================================================
# Reliable terminal detection via parent process.
# Env vars like TERM_PROGRAM leak to child processes
# (e.g., when launching Alacritty from a WezTerm shell). The parent process
# of zsh is always the terminal emulator that spawned it — this cannot leak.
#
# Sets:
#   __ZSH_TMUX_AUTOSTART — always "false": tmux auto-start is permanently
#     blocked, for every terminal. There is no opt-in path; this variable
#     exists only so the tmux helper has an explicit value to read.
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
    __ZSH_TMUX_AUTOSTART="false"
    ;;
  *)
    __ZSH_TMUX_AUTOSTART="false"
    ;;
esac

unset __ZSH_PARENT_COMM
