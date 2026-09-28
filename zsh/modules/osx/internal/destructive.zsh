# shellcheck shell=bash
#
# Internal: gated destructive operations.
#
# Two operations, both irreversible-in-effect and both gated:
#
#   _osx::internal::destructive::rebuild_launch_services
#   _osx::internal::destructive::wipe_dock
#
# The functions are ALWAYS defined. The security does not come from the
# function being absent — it comes from ZSH_OSX_DESTRUCTIVE defaulting to
# false. Keeping them defined keeps the capability discoverable (osx::sync can
# list it, the README can document it) and testable (a test invokes them with
# the switch off and asserts the report-and-return-1 path).
#
# ZSH_OSX_REFRESH is deliberately NOT consumed here: the Finder/Dock restart
# is not destructive and lives in pkg/base.zsh as osx::refresh.
#
# ── The three gates, in the order they are evaluated ────────────────────────
#
#   1. ZSH_OSX_DESTRUCTIVE (default false) — the KILL SWITCH. When false the
#      operation is not available at all: it reports and returns 1 WITHOUT
#      ever prompting. This is what makes an irreversible operation
#      unreachable by accident in a session, a script or a CI run.
#   2. ZSH_OSX_FORCE (default false) — skips the prompt. Exists for explicit
#      non-interactive use; never set in ~/.customrc by default.
#   3. ZSH_OSX_CONFIRM (default true) — controls whether to ask, once the
#      capability is enabled.
#
# Note the asymmetry between 2 and 3, which is deliberate: CONFIRM=false
# means "don't ask", NOT "proceed without a TTY". Turned off inside a pipe or
# `zsh -c`, CONFIRM=false still refuses, because a refused read is exactly the
# situation the TTY check exists to catch. FORCE is the flag that authorizes
# unattended execution, and it must be set by hand.
#
# ── Non-interactive sessions ───────────────────────────────────────────────
#
# Detected with `[[ -t 0 ]]`. With no TTY (pipe, `zsh -c`, CI, cron, an SSH
# session without an interactive terminal, a tool hook) the prompt cannot run:
# read either fails or hangs, and both outcomes are unacceptable for an
# operation that destroys a Dock. The helper does not prompt, returns 1, and
# names the flag to set. A destructive operation must never depend on a read
# happening to return a y.

# ══════════════════════════════════════════════════════════════════════════
# Helpers
# ══════════════════════════════════════════════════════════════════════════

# Prompt for confirmation — returns 0 if approved, 1 if declined.
# Same shape as _cleanup::confirm (zsh/modules/clean/internal/base.zsh:22-38):
# read -r, accept ONLY [Yy]. Any other answer, INCLUDING AN EMPTY ENTER, is a
# no. That asymmetry is intentional — the default of the prompt is "no", and a
# y/N-style "yes to everything" affordance would relax the protection in the
# name of consistency with nothing.
#
# $1 message  — what is about to happen, in the user's terms.
# $2 context  — optional qualifier, rendered in parentheses.
_osx::confirm() {
  local message="$1"
  local context="${2:-}"

  if [[ -n "${context}" ]]; then
    message="${message} (${context})"
  fi

  # User-visible text goes through the message helpers like everything else.
  # The newline the helper emits puts the typed answer on the next line; that
  # costs one keystroke of polish and buys a file with zero raw output calls.
  message_info "${message} [y/N]:"
  read -r response
  [[ "${response}" =~ ^[Yy]$ ]] && return 0
  return 1
}

# The shared gate. $1 action label (for the report), $2 prompt message.
# Returns 0 to let the caller execute, 1 to stop it. Never executes anything.
_osx::internal::destructive::gate() {
  local action="$1"
  local prompt="$2"

  # 1. Kill switch. Reports and stops WITHOUT prompting — reaching this branch
  #    is the normal state of a default install, so the message says how to
  #    enable the capability rather than apologising for anything.
  if [[ "${ZSH_OSX_DESTRUCTIVE:-false}" != "true" ]]; then
    message_warning "Destructive operation '${action}' is disabled: it is gated behind ZSH_OSX_DESTRUCTIVE=true."
    return 1
  fi

  # 2. Explicit non-interactive authorization. Skips the prompt entirely.
  if [[ "${ZSH_OSX_FORCE:-false}" == "true" ]]; then
    return 0
  fi

  # 3. No TTY: the prompt cannot run. Refuse and name the flag that bypasses
  #    this check, rather than letting read fail silently or block on a pipe.
  if [[ ! -t 0 ]]; then
    message_warning "Refusing to run '${action}': this is not an interactive session, so the confirmation prompt cannot be shown."
    message_warning "Re-run it from an interactive terminal, or set ZSH_OSX_FORCE=true for an explicit unattended run."
    return 1
  fi

  # 4. Prompts turned off inside an interactive session: proceed unasked.
  if [[ "${ZSH_OSX_CONFIRM:-true}" == "false" ]]; then
    return 0
  fi

  # 5. Ask.
  _osx::confirm "${prompt}" || return 1
  return 0
}

# ══════════════════════════════════════════════════════════════════════════
# Operations
# ══════════════════════════════════════════════════════════════════════════

# Rebuild the Launch Services database:
#   lsregister -kill -r -domain local -domain system -domain user
# (source: zsh-osx/internal/base.zsh:38)
#
# The binary is checked by ABSOLUTE PATH, never with core::exists or
# core::ensure. lsregister is not in PATH — it lives inside
# CoreServices.framework — so core::ensure would try to brew-install a
# package that does not exist. core::exists answers "is this tool on PATH",
# which is a different question from "does this absolute system path exist";
# the core helper is not extended to cover it.
#
# Scope: all three domains — local, system and user. Every application
# association on the machine is dropped and re-read.
#
# Disruption is transient, not destructive: app resolution and "Open with"
# behave oddly for a few seconds and Spotlight reindexes in the background.
# Nothing is erased, and the database rebuilds itself.
_osx::internal::destructive::rebuild_launch_services() {
  local lsregister="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

  _osx::internal::destructive::gate \
    "osx::rebuild_launch_services" \
    "Rebuild the Launch Services database for the local, system and user domains? App resolution breaks briefly and Spotlight reindexes in the background." \
    || return 1

  if [[ ! -x "${lsregister}" ]]; then
    message_error "lsregister not found at ${lsregister} — this operation only exists on macOS."
    return 1
  fi

  message_info "Rebuilding Launch Services across the local, system and user domains (${lsregister})..."
  if "${lsregister}" -kill -r -domain local -domain system -domain user; then
    message_success "Launch Services database rebuilt. App resolution settles in a few seconds; Spotlight reindexes in the background."
    return 0
  fi

  message_error "lsregister exited non-zero; the Launch Services database may be only partially rebuilt."
  return 1
}

# Wipe every Dock icon:
#   defaults write com.apple.dock static-only   -bool true
#   defaults write com.apple.dock persistent-apps -array
# (source: zsh-osx/internal/base.zsh:320-323)
#
# This is the operation with no way back: the source saves nothing before
# clearing the array, so the icons are gone from the Dock and recovery is
# re-dragging each one from /Applications. The prompt says exactly that,
# because a user who has not been told cannot make an informed decision.
_osx::internal::destructive::wipe_dock() {
  _osx::internal::destructive::gate \
    "osx::wipe_dock" \
    "Wipe EVERY icon from the Dock? There is NO BACKUP: nothing is saved before the clear, and recovery is manual — you must re-drag each icon back into the Dock yourself." \
    || return 1

  if ! core::exists defaults; then
    message_error "defaults not found — this operation only exists on macOS."
    return 1
  fi

  message_info "Clearing the Dock icon list (com.apple.dock)..."
  if defaults write com.apple.dock static-only -bool true &&
    defaults write com.apple.dock persistent-apps -array; then
    message_success "Dock cleared. Re-drag the icons you want back from /Applications."
    return 0
  fi

  message_error "defaults exited non-zero; the Dock may be only partially cleared."
  return 1
}

# Public aliases, so the capability is reachable under the bare
# osx::internal::destructive:: names as well as the private ones. The gate is
# unchanged either way — the alias is a second name for the same function.
osx::internal::destructive::rebuild_launch_services() {
  _osx::internal::destructive::rebuild_launch_services "$@"
}

osx::internal::destructive::wipe_dock() {
  _osx::internal::destructive::wipe_dock "$@"
}
