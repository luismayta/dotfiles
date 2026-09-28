# shellcheck shell=bash
# shellcheck disable=SC2016 # single quotes are deliberate: every `${...}` in this
# file is text the table stores verbatim for the renderer to resolve, or a
# literal pattern matched on purpose. None of them should expand at parse time.
#
# Renderer for ZSH_OSX_PRIVILEGED_OPS — the 12 inherited privileged operations.
#
# This file has exactly one mode: it reports. It never executes anything.
#
# The security property, stated once so a reviewer can check it in one read:
#
#   There is no `eval`, no `${(e)}`, no `command`, no backtick, and no bare
#   expansion of field 6 anywhere in this file. Field 6 — the command — is only
#   ever moved through a string substitution and then passed as a *quoted
#   argument* to a message_* helper, which itself only printf's it. The string
#   `sudo` in the table is text the user reads and types by hand; it is never a
#   word this shell dispatches.
#
# The substitution is deliberately not a general expansion. A row interpolating
# a variable this file does not know about is left literal and therefore visible
# in the output, instead of being evaluated. A new interpolatable variable is a
# deliberate addition to the list below, not an implicit capability.
#
# Three zsh details the table and this loop depend on:
#
#   1. `${(s.:.)}` discards empty fields instead of yielding them, which is why
#      the table writes `-` and never a blank for a missing target. A blank
#      field would collapse the row to five elements and shift every later index
#      one position left, so this file reads `fields[2]` as the sentinel `-`
#      meaning "no plist/domain", never as a real domain.
#
#   2. The split result must stay quoted. Unquoted, zsh would word-split the
#      single-space value of `mute-startup-chime` into two elements — the same
#      class of bug as (1), one layer up.
#
#   3. The `value` field is single-quoted in the table, so `${...}` is stored as
#      literal text and resolved HERE, at render time, never at load time. That
#      late resolution is the whole point: it is what lets the loop find an empty
#      result and report the operation as `skipped` instead of `documented`.
#
# Values come back through `reply`, the same convention `internal/host.zsh`
# uses, so this file adds no new return-value idiom to the module.

# Resolve the one variable a table field is allowed to interpolate. Sets `reply`.
#
# This is a literal string replacement, not an expansion: nothing in the
# substituted text is evaluated. zsh-osx's four hostname rows are the only place
# it applies, and they reach this function still single-quoted from the table,
# so this is the *only* point at which they are resolved.
_osx::internal::privileged::expand() {
  local -r placeholder='${ZSH_OSX_COMPUTER_NAME}'

  # The pattern comes from a variable so no `${` has to be escaped inside double
  # quotes, where zsh would retain the backslash.
  reply="${1//${placeholder}/${ZSH_OSX_COMPUTER_NAME}}"
}

# R-EMPTY: is the value this operation would write unset? Returns 0 for unset.
#
# $1 — the raw `value` field, before resolution.
# $2 — that field after resolution.
#
# Two distinct cases, and the second one is the subtle half:
#
#   * Zero length is always unset. No operation in the table wants the empty
#     string, and the inherited source has a verified bug — the variable backing
#     the four hostname calls is referenced four times and assigned zero times —
#     that would otherwise render four commands writing `""`.
#
#   * Whitespace-only is unset *only when the field was interpolating a
#     variable*. That means the user left the variable blank, not that the
#     operation wants a blank. A literal whitespace value is the documented
#     intent of `mute-startup-chime` (`nvram SystemAudioVolume=" "`), and
#     `SystemAudioVolume=" "` is exactly how the startup chime is muted — so
#     treating whitespace as always-empty would silently drop a real operation
#     out of the documented set and land the count on 7/4 instead of 8/4.
_osx::internal::privileged::value_is_unset() {
  local -r raw_value="${1}"
  local -r value="${2}"

  [[ -z "${value}" ]] && return 0

  if [[ -n "${value}" && -z "${value//[[:space:]]/}" && "${raw_value}" == *'${'* ]]; then
    return 0
  fi

  return 1
}

# Report every privileged operation as a manual procedure. Never executes one.
#
# Returns 0 unconditionally. A `skipped` operation is a *documented* outcome of
# this module, not a failure of it: the count is the finding. Returning non-zero
# would make `osx::sync` report an error for the very state it is meant to
# surface. (Per D7 the rule is that a message_* on its own is not a signal — but
# here there is no error to signal, so there is no `return 1` to pair with one.)
osx::internal::privileged::report() {
  local -i applied=0
  local -i documented=0
  local -i skipped=0
  local reply op origin target key type raw_value value command
  local -a fields

  if (( ! ${#ZSH_OSX_PRIVILEGED_OPS} )); then
    message_info "osx: no privileged operations registered — nothing to document"
    return 0
  fi

  message_info "osx: ${#ZSH_OSX_PRIVILEGED_OPS} inherited privileged operations. This module runs none of them — each one below is a manual step for you to run yourself."

  # shellcheck disable=SC2296 # zsh-only: (ko) iterates the assoc's keys, sorted
  for op in ${(ko)ZSH_OSX_PRIVILEGED_OPS}; do
    # shellcheck disable=SC2296 # zsh-only field split
    fields=("${(@s.:.)ZSH_OSX_PRIVILEGED_OPS[$op]}")

    # Field 1 — origin line in zsh-osx/internal/base.zsh: the operation's stable
    # and verifiable identity.
    origin="${fields[1]}"

    # Field 2 — `-` is the sentinel for "no plist/domain". It stands for a
    # host-level tool call (nvram, systemsetup, scutil), not a defaults domain.
    target="${fields[2]}"
    [[ "${target}" == "-" ]] && target="- (no plist/domain; host-level tool)"

    # Field 3 — the preference key, or the tool's option name.
    key="${fields[3]}"

    # Field 4 — the defaults type flag the source line uses, or -flag for the
    # lines that take none.
    type="${fields[4]}"

    # Field 5 — resolved here, at render time, never at table load time. This is
    # the only assignment to `value`, and the only place the late resolution
    # that makes empty-value detection possible happens.
    raw_value="${fields[5]}"
    _osx::internal::privileged::expand "${raw_value}"
    value="${reply}"

    # Field 6 — the complete command for the user to run. Resolved the same way
    # so the command reported always matches the value reported, and so no
    # unresolved `${...}` placeholder can leak into the output. It is rendered,
    # never dispatched: it goes straight into a message_* argument.
    _osx::internal::privileged::expand "${fields[6]}"
    command="${reply}"

    if _osx::internal::privileged::value_is_unset "${raw_value}" "${value}"; then
      (( skipped++ ))

      # The variable is named on exactly ONE line per skipped operation, and the
      # fix rides on that same line, so the whole report has exactly one line per
      # skipped op that names ZSH_OSX_COMPUTER_NAME. That is what makes
      # `... | grep -c ZSH_OSX_COMPUTER_NAME` a usable assertion: it returns the
      # skipped count, not a multiple of it.
      message_warning "Privileged op skipped: ${op} (zsh-osx:${origin}) — ZSH_OSX_COMPUTER_NAME is unset, so there is no value to write. Fix: export ZSH_OSX_COMPUTER_NAME=<name> in ~/.customrc, then re-run osx::sync."
      message_warning "    Do NOT run the command below as-is. An empty value here is not a no-op: it erases the configured name and leaves the machine in a degraded network state."
      message_info "    target:  ${target}"
      message_info "    key:     ${key}"
      message_info "    type:    ${type}"
      message_info "    value:   <empty — nothing written>"
      # Shown even though it must not be run: the whole point of R-EMPTY is that
      # this exact command is the dangerous one, and seeing it makes the risk
      # concrete instead of abstract.
      message_info "    command: ${command}"
      continue
    fi

    (( documented++ ))

    message_warning "Privileged op documented (manual step required): ${op} (zsh-osx:${origin})"
    message_warning "    This module never runs sudo. Run the command below yourself, by hand."
    message_info "    target:  ${target}"
    message_info "    key:     ${key}"
    message_info "    type:    ${type}"
    message_info "    value:   ${value}"
    message_info "    command: ${command}"
  done

  # Three counts, three distinct keys, never fused into one number: `applied` is
  # 0 by definition (this module executes no privileged write), and merging it
  # into the total would imply the module performs work it deliberately does not.
  # No variable in this file can ever increment `applied`.
  message_info "osx privileged ops summary — applied: ${applied} (by definition: this module executes no privileged write) | documented: ${documented} | skipped: ${skipped}"

  return 0
}
