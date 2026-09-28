# shellcheck shell=bash
#
# osx / internal / refresh — explicit runtime refresh of the macOS processes.
#
# Why this file exists. nix-darwin writes the plists; it cannot restart the
# processes already holding the old state. Until something restarts them the
# live desktop keeps running on the previous configuration, and closing that
# gap is the core value of this module.
#
# Why the refresh is never automatic (D4). A shell-startup hook would fire on
# every new shell, and once per pane whenever tmux rebuilds a layout, so six
# panes would mean six competing killalls. A `zsh -c` script or an SSH session
# would kill somebody else's GUI session outright. Nothing that touches the
# desktop runs unless a human asks for it at that moment — so this file only
# defines the operation and never invokes it: no module-load call, no
# `osx::sync` side effect, no startup hook. Loading it is side-effect free by
# construction, which is what makes the guarantee checkable.
#
# Why there is no confirmation (D4). Neither killall is destructive in the
# sense the destructive area uses: the process comes back, the user's
# preferences are never touched, and the only loss is the previous window
# state. That is an expected cost for a refresh the user explicitly asked for,
# so a prompt would add a step to the one operation already decided. The
# ZSH_OSX_REFRESH gate (default true) still applies, for symmetry with the rest
# of the module: a true default on an action that must be explicitly invoked
# is a safe default.
#

osx::internal::refresh::processes() {
  local refresh_enabled="${ZSH_OSX_REFRESH:-true}"

  if [[ "${refresh_enabled}" != "true" ]]; then
    message_warning "Refresh disabled: ZSH_OSX_REFRESH is '${refresh_enabled}' (documented default is true)."
    message_warning "No process was restarted; the live session keeps the previous configuration."
    return 1
  fi

  if ! core::exists killall; then
    message_error "killall is required to refresh the session but was not found."
    return 1
  fi

  # (zsh-osx/internal/base.zsh:306, :412) — the two processes the module
  # documents. Each is reported on its own, and one failure does not cancel the
  # other: a Dock left on the old configuration is still worth restarting even
  # when Finder refused.
  local -a processes
  processes=(Finder Dock)

  local process
  local failures=0

  for process in "${processes[@]}"; do
    if killall "${process}" >/dev/null 2>&1; then
      message_success "Restarted ${process} — the live session now reflects the new configuration."
    else
      message_error "Failed to restart ${process}."
      failures=$((failures + 1))
    fi
  done

  if (( failures > 0 )); then
    message_warning "Refresh finished with ${failures} failure(s): the session is only partially up to date."
    return 1
  fi

  message_info "Session refreshed: every affected process restarted and re-read the applied configuration."
  return 0
}
