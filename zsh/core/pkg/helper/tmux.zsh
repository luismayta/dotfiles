#
# shellcheck shell=bash
# Tmux auto-start — connects to the terminal-specific tmux server.
#
# TMUX_SOCKET is set by the terminal emulator:
#   Ghostty → env.TMUX_SOCKET = "ghostty"
#   WezTerm → wezterm.set_environment_variables = { TMUX_SOCKET = "wezterm" }
#
# Falls back to "default" (original tmux behavior) when TMUX_SOCKET is unset.
#

if type -p tmux > /dev/null; then
    if [[ -z "${TMUX}" ]]; then
        tmux -L "${TMUX_SOCKET:-default}" new-session -A -s allsafe
    fi
fi
