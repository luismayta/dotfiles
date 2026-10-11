#
# shellcheck shell=bash
# Tmux auto-start helper — DISABLED by default (permanently off, no opt-in).
#
# Per-emulator socket routing is no longer active: no terminal emulator sets
# TMUX_SOCKET anymore (commit 5082cd20 removed the producers; they now set
# HERDR_WORKSPACE instead). Nothing sets TMUX_SOCKET, so this helper always
# resolves to the "default" socket.
#
# Guard: __ZSH_TMUX_AUTOSTART is set by zsh/detect/terminal.zsh (parent-process
# detection) and is always "false", so auto-start is blocked by default for
# every terminal. The ZSH_DISABLED_MODULES guard below is retained as
# defence-in-depth only — it is NOT the primary control.
#
# Known latent defect: this file is sourced at zsh/zshrc:23, but ~/.customrc
# (where a user would set ZSH_DISABLED_MODULES) is only sourced at
# zsh/zshrc:49. The guard therefore reads the variable before it exists and
# does NOT actually block auto-start. Harmless today because auto-start is off
# by default; tracked for a future change (do not fix the load order here).
#

# Skip if tmux module is disabled (consistent with ZSH_DISABLED_MODULES in zshrc)
# NOTE: see ordering-defect note above — this runs before ~/.customrc is sourced.
if [[ -n "${ZSH_DISABLED_MODULES:-}" ]] && [[ ",${ZSH_DISABLED_MODULES// /,}," == *",tmux,"* ]]; then
    return
fi

if type -p tmux > /dev/null; then
    if [[ -z "${TMUX}" ]] && [[ "${__ZSH_TMUX_AUTOSTART:-false}" != "false" ]]; then
        tmux -L "${TMUX_SOCKET:-default}" new-session -A -s allsafe
    fi
fi
