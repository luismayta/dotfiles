# shellcheck shell=bash
#
# osx / pkg / base — the module's public API.
#
# Four of the five public functions live here: the precondition check, the run,
# the runtime refresh, and the post-install wrapper. The fifth, the setup
# orchestrator, composes public functions rather than wrapping one, so it lives
# in pkg/helper.zsh per docs/guides/create-module.md section 5.
#
# This layer holds no macOS logic of its own. It orchestrates the internal area
# functions and it reports; it issues no `defaults` invocation, no `killall`, no
# `lsregister` and no `sudo` of any kind. That is what makes the security
# properties of the internal layer checkable by reading a single file: this one
# has nothing to audit, because everything that does anything lives one level
# down behind the gates.
#
# ── The return-code trap (design D7) applies to every function here ────────
# `message_error` returns 0 — zsh/system/core/internal/api.zsh:45-48 emits the
# line and then `return 0`. It does NOT fail the function that called it. So a
# path that only reports an error reads as success to every caller, and the
# failure is lost silently. Every failure path below therefore ends with an
# explicit `return 1`: the message is the output, the return is the signal. The
# two always come as a pair, never one without the other.
#
# Every user-facing line goes through the message helpers. This file contains no
# direct output primitive of any kind, and adds no reimplementation of a core
# helper (requirement: Conformidad con las convenciones del core).
#

# ══════════════════════════════════════════════════════════════════════════
# osx::install
# ══════════════════════════════════════════════════════════════════════════
#
# Verifies the preconditions and installs nothing.
#
# This module has no binary. It is a data table and a reporter, so there is
# nothing to download, nothing to unpack and nothing to link. The guide's
# `install` convention assumes a `curl | bash`; an install function that
# pretended otherwise would be worse than one that admits it. A user running
# setup on a malformed machine gets a diagnosis, not a fetch to nowhere
# (design D5).
#
# Three preconditions:
#
#   1. `defaults` on PATH — the only way host-scoped writes and both read-only
#      reports reach the preference store. It ships with macOS.
#   2. `killall` on PATH  — the runtime refresh is the module's central value
#      (design D4): without it a live session cannot be brought up to date. It
#      also ships with macOS.
#   3. the data directory exists, is readable and is writable. It is
#      ZSH_OSX_DATA_PATH, exported by config/base.zsh.
#
# core::exists is reused, not reimplemented: it is the project's existence
# helper (zsh/system/core/pkg/base.zsh:14-16 over internal/api.zsh:29-39) and it
# carries a session cache that a local copy would not have.
#
# core::ensure is deliberately NOT used, even though it is on the list of
# reusable core helpers. It is `core::exists || core::install`, and
# `core::install` on macOS is `brew install`
# (zsh/system/core/internal/osx.zsh:4-10) — so `core::ensure defaults` would ask
# Homebrew for a formula that does not exist, to fix a binary that ships with the
# operating system. This is the same distinction internal/destructive.zsh records
# for lsregister: the existence helper answers "is this tool on PATH", the
# install helper answers "is there a package that provides it". For macOS system
# tools only the first question has a useful answer.
#
# The preconditions are deliberately not memoised in a module variable.
# core::exists caches positive results, so a tool removed mid-session still
# reads as present; re-probing on every call is the cheaper of the two failure
# modes (design D7).
#
# Returns 0 when every precondition holds, 1 otherwise. Every failure is
# reported, not just the first: a user on a broken machine should see the whole
# list at once instead of discovering it one re-run at a time.
osx::install() {
  local -i failed=0
  local -r data_path="${ZSH_OSX_DATA_PATH:-}"

  if ! core::exists defaults; then
    message_error "osx: 'defaults' is not on PATH. It ships with macOS, so this is a damaged or non-macOS system, not a missing package."
    failed=$((failed + 1))
  fi

  if ! core::exists killall; then
    message_error "osx: 'killall' is not on PATH. It ships with macOS, and the runtime refresh cannot work without it."
    failed=$((failed + 1))
  fi

  if [[ -z "${data_path}" ]]; then
    message_error "osx: ZSH_OSX_DATA_PATH is unset — config/base.zsh was not sourced, so the data directory is unknown."
    failed=$((failed + 1))
  elif [[ ! -d "${data_path}" ]]; then
    message_error "osx: the data directory ${data_path} does not exist."
    failed=$((failed + 1))
  elif [[ ! -r "${data_path}" ]]; then
    message_error "osx: the data directory ${data_path} is not readable."
    failed=$((failed + 1))
  elif [[ ! -w "${data_path}" ]]; then
    message_error "osx: the data directory ${data_path} is not writable, so the module cannot maintain the artifacts it owns there."
    failed=$((failed + 1))
  fi

  if (( failed > 0 )); then
    message_error "osx: ${failed} precondition(s) unmet. Nothing was installed, because this module installs nothing."
    return 1
  fi

  message_success "osx: preconditions satisfied. There is nothing to install — this module is a data table and a reporter."
  return 0
}

# ══════════════════════════════════════════════════════════════════════════
# osx::sync
# ══════════════════════════════════════════════════════════════════════════
#
# The routine run. Three callees, in this order:
#
#   1. osx::internal::host::sync         — the five host-scoped writes, each one
#                                           read back so a TCC/FDA denial cannot
#                                           read as success (R-TCC)
#   2. osx::internal::privileged::report — the 12 inherited privileged ops as
#                                           documented manual steps, never run
#   3. osx::internal::screenlock::report — the screen-lock drift, read only
#
# The order is the module's order. Host-scoped writes come first because they are
# the only thing here that changes state, and a user who wants to stop the run
# should be able to see those results first. The privileged report follows
# because it is the longest output and reads as a checklist against the state
# the writes just left. The drift report is last because it is a diagnostic
# about a preference nobody should be writing.
#
# ── No header, no footer. Deliberately. ────────────────────────────────────
# Every line above this function is emitted by a callee. There is no
# "syncing osx..." banner and no closing summary here, and that is the design,
# not an omission (design D5). The source this module inherits used only
# info/success reporting and its own run emitted nothing around them. The
# consequence is that the output is composable: `osx::sync > sync.log` contains
# the actions taken and the warnings raised, with no scaffolding mixed in, so the
# file is readable on its own. A banner and a summary would be the two lines
# that make it unreadable, and they would carry the least information of
# anything printed.
#
# One consequence needs stating, because a reader may think it is a missed
# message. This function returns 1 without saying so when a callee failed. That
# is not a silent failure path: the callee already emitted its own
# `message_error` naming the operation, and adding a "sync failed" line here
# would be precisely the footer this function does not have. The message half of
# the D7 rule is satisfied by the callee; the signal half is the return.
#
# ── What a routine run never does (design D4) ─────────────────────────────
# It does not restart anything and it runs nothing irreversible. No refresh
# process is killed and neither gated destructive operation is invoked: not as a
# trailing step, not behind a flag, not as a side effect. A run the user asked
# for must not cost them their desktop. The refresh and the destructive
# operations are reached only by naming them explicitly.
osx::sync() {
  local -i failed=0

  # Each callee runs unconditionally: a host-write failure must not cost the
  # user the privileged-op checklist, and a report failure must not hide the
  # drift. `||` here counts, it does not short-circuit — the left side is the
  # call itself.
  osx::internal::host::sync || failed=$((failed + 1))
  osx::internal::privileged::report || failed=$((failed + 1))
  osx::internal::screenlock::report || failed=$((failed + 1))

  if (( failed > 0 )); then
    return 1
  fi

  return 0
}

# ══════════════════════════════════════════════════════════════════════════
# osx::refresh
# ══════════════════════════════════════════════════════════════════════════
#
# Restarts Finder and Dock so the live session reflects the configuration that
# was just written. Delegates entirely to the internal refresh area, which owns
# the process list, the per-process reporting and the ZSH_OSX_REFRESH gate.
#
# ── Why this function is in THIS file and not in pkg/osx.zsh ──────────────
# Read this before tidying it. Moving it to pkg/osx.zsh is the obvious cleanup
# and it is wrong.
#
# `osx::sync` is macOS-only and `osx::refresh` is macOS-only. If the only
# macOS-only entry point lived in the macOS-only file, the public API would have
# a different shape on each platform: `type osx::refresh` would resolve on a Mac
# and fail on Linux, so every script, alias and test touching the API would need
# a platform branch to discover whether the function exists. Platform protection
# belongs to the config layer, which already has it —
# config/linux.zsh sets ZSH_OSX_ENABLED=false and plugin.zsh returns on
# `$ZSH_OSX_ENABLED || return` before pkg/main.zsh is ever sourced, so on Linux
# this function is not defined at all through the module. The gate is the
# mechanism; the absence of a function is not, and using absence as the gate
# would mean the gate lives in the wrong layer (design D5).
osx::refresh() {
  osx::internal::refresh::processes "$@"
}

# ══════════════════════════════════════════════════════════════════════════
# osx::post_install
# ══════════════════════════════════════════════════════════════════════════
#
# Thin wrapper around the run, per the guide's convention. The module's install
# hook calls it after a checkout, and the useful part is still the run — so this
# is the run, with a word of framing around it.
#
# The convention's template interpolates a package-name variable. This module
# does not have one and does not gain one: there is no package to install, so
# the variable would be dead, and a message that interpolates a variable is
# exactly the pattern that renders empty in `zed` because the variable is
# exported after the message runs. The literal is used instead, for the same
# reason plugin.zsh uses the literal in its load message (design D6).
#
# The return status of the run is checked rather than assumed. The guide's
# template ends in a success message, which would report success over a failed
# run — the worst kind of report, because it is the one the user trusts.
osx::post_install() {
  local -i rc

  message_info "osx: post-install — applying the settings this module owns."

  osx::sync
  rc="${?}"

  if (( rc != 0 )); then
    message_error "osx: post-install finished with errors — see the report above for the operation that failed."
    return 1
  fi

  message_success "osx: post-install complete."
  return 0
}

# ── What this API deliberately does not contain ────────────────────────────
#
# Package installation is not here. The source carried a package-install
# function for this module, but it was a stub with zero callers anywhere, and
# zsh/modules/apps/ already installs casks per platform through core::ensure.
# Reimplementing it here would duplicate a core helper's job and create a second
# package-install path on macOS. The delegation to apps::packages::install is
# documented in the module README instead of being duplicated in code (design
# D5). The old name is deliberately not written out anywhere above, so that the
# task 6.5 assertion — a recursive search of the module for that name finding
# nothing — has nothing to match in this layer.
#
# Neither is a Git alias. The source wrote one into the user's global
# configuration; a macOS settings module has no business writing someone's Git
# configuration, and nothing in this module would reverse it if the module were
# removed. It belongs to zsh/modules/git/, which already exists.
