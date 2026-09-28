# shellcheck shell=bash
#
# osx module — host-scoped `defaults -currentHost write` writes.
#
# This is the only file in the module that writes anything, and it writes only
# the `-currentHost` form. The source repo (zsh-osx) has exactly six
# `-currentHost write` calls; after reconciling them there are five distinct
# writes, and those five live in the table below. Every write is read back and
# compared (R-TCC): a `defaults write` that TCC/FDA denies can exit 0 having
# written nothing, so exit status alone proves nothing here.
#
# The table lives here rather than in config/base.zsh. The privileged-ops table
# sits in config/ because it must expand ${ZSH_OSX_COMPUTER_NAME} late, so a
# user can export it from ~/.customrc (design.md line 122). Nothing here is
# user-overridable — every value is a literal — so that justification does not
# transfer, and config/base.zsh is documented as the module's env-var surface.
# Keeping the table beside the only loop that reads it also keeps group 2 to a
# single file instead of splitting a five-row table from its renderer.
#
# Two structural properties, both deliberate:
#
#   * The associative is keyed by the preference key, so a duplicated key is
#     not expressible — dedup is structural, not a convention. All five keys are
#     unique, which is what makes that safe.
#   * A key already holding the intended value is not rewritten, so a second
#     consecutive run issues zero writes and reports them as `unchanged`.
#

# ============ Write table ============
#
# Five colon-separated fields, read back with ${(@s.:.)...}:
#
#   origin  — source line(s) in zsh-osx/internal/base.zsh; `+` joins the
#             byte-identical pair that collapsed into one write
#   domain  — the `-currentHost` domain
#   key     — the preference key; also the associative key above
#   type    — the type flag the source line uses (-bool / -int)
#   value   — the literal the source writes
#
# CONSTRAINT, carried over from ZSH_OSX_PRIVILEGED_OPS: no field may contain a
# colon, because colon is the separator. A missing field would also be silently
# dropped by zsh's split rather than yielding an empty one, shifting every
# later field one position left — the loop indexes positionally, so that reads
# the wrong column instead of failing.
typeset -gA ZSH_OSX_HOST_DEFAULTS
# shellcheck disable=SC2034 # consumed by osx::internal::host::sync below
ZSH_OSX_HOST_DEFAULTS=(
  # Source lines 45 and 510 are byte-identical, so they collapse into one write
  # rather than two. Keeping one row is the whole dedup: the same key must not
  # be written twice from two places in the source.
  [disableHotPlug]='45+510:com.apple.ImageCapture:disableHotPlug:-bool:true'

  # The source also writes this same key at line 162, but as a PLAIN
  # `defaults write NSGlobalDomain` — same domain, key and value, different
  # plist. That form is a user-domain default owned by darwin-system-config and
  # is out of scope for this module by design; only the `-currentHost` form is
  # applied here.
  [com.apple.mouse.tapBehavior]='161:NSGlobalDomain:com.apple.mouse.tapBehavior:-int:1'

  [com.apple.trackpad.trackpadCornerClickBehavior]='167:NSGlobalDomain:com.apple.trackpad.trackpadCornerClickBehavior:-int:1'
  [com.apple.trackpad.enableSecondaryClick]='168:NSGlobalDomain:com.apple.trackpad.enableSecondaryClick:-bool:true'
  [com.apple.trackpad.threeFingerHorizSwipeGesture]='172:NSGlobalDomain:com.apple.trackpad.threeFingerHorizSwipeGesture:-int:1'
)

# `defaults read` prints a boolean as 1/0, so a row that writes `-bool true`
# must be compared against `1`, not against the token `true` handed to `write`.
# Comparing the write token against the read output would fail on every boolean
# row and report a false mismatch. Sets `reply`.
_osx::internal::host::expected_read() {
  case "${1}" in
    -bool) [[ "${2}" == "true" ]] && reply="1" || reply="0" ;;
    *) reply="${2}" ;;
  esac
}

# Applies one row: pre-write read, write, post-write read-back.
#
# Return status is what the caller counts on, so it is documented here:
#   0 — write issued, read-back matched
#   1 — write failed, or read-back did not match the intended value
#   2 — already at the intended value; no write issued
#
# Status 1 is returned explicitly. message_error returns 0 (see
# zsh/system/core/internal/api.zsh:45-48), so the message is the output and
# the return is the signal; an error path carrying only message_error would
# read as success to every caller.
_osx::internal::host::apply_row() {
  local domain="${1}"
  local key="${2}"
  local type="${3}"
  local value="${4}"
  local expected="${5}"
  local current

  # Pre-write read. stderr is dropped because a key that does not exist yet
  # makes `defaults read` complain, and on a first run that is the normal case,
  # not a fault.
  current=$(defaults -currentHost read "${domain}" "${key}" 2>/dev/null)
  if [[ "${current}" == "${expected}" ]]; then
    return 2
  fi

  if ! defaults -currentHost write "${domain}" "${key}" "${type}" "${value}"; then
    message_error "Failed to write ${key} (${domain}) from source line ${6}"
    return 1
  fi

  # The read-back is the point of this file: the write above returning 0 does
  # not mean the value landed (R-TCC).
  current=$(defaults -currentHost read "${domain}" "${key}" 2>/dev/null)
  if [[ "${current}" != "${expected}" ]]; then
    message_error "Read-back mismatch on ${key} (${domain}, source line ${6}): expected '${expected}', got '${current}' — the write was denied or did not take effect (TCC/Full Disk Access)"
    return 1
  fi

  return 0
}

# Applies the whole table and reports four counts separately: `written` (writes
# actually issued), `verified` (keys whose effective value was read back and
# matched), `unchanged` (already correct, so not written) and `failed`.
#
# `written` and `verified` are never merged, because the gap between them is the
# signal that a write was denied: verified=0 is meant to be visible at a glance.
osx::internal::host::sync() {
  local written=0
  local verified=0
  local unchanged=0
  local failed=0
  local row origin domain key type value expected rc
  local -a fields

  if ! core::exists defaults; then
    message_error "defaults is required but not installed"
    return 1
  fi

  # shellcheck disable=SC2296 # zsh-only: (ko) iterates the assoc's keys, sorted
  for row in ${(ko)ZSH_OSX_HOST_DEFAULTS}; do
    # shellcheck disable=SC2296 # zsh-only field split
    fields=("${(@s.:.)ZSH_OSX_HOST_DEFAULTS[${row}]}")
    origin="${fields[1]}"
    domain="${fields[2]}"
    key="${fields[3]}"
    type="${fields[4]}"
    value="${fields[5]}"

    _osx::internal::host::expected_read "${type}" "${value}"
    expected="${reply}"

    # The read-back on the unchanged path is the pre-write read: the value was
    # read and it matched, so the key is verified just the same.
    _osx::internal::host::apply_row "${domain}" "${key}" "${type}" "${value}" "${expected}" "${origin}"
    rc="${?}"

    case "${rc}" in
      0)
        written=$((written + 1))
        verified=$((verified + 1))
        message_success "Host default applied and verified: ${key} (${domain})"
        ;;
      2)
        unchanged=$((unchanged + 1))
        verified=$((verified + 1))
        message_info "Host default already applied, not rewritten: ${key} (${domain})"
        ;;
      *)
        failed=$((failed + 1))
        # Stop writing on the first unverifiable key: a denied write is a
        # session-wide condition (TCC/FDA), so the rest would fail the same
        # way. The summary below still reports both counts, which is what makes
        # verified=0 legible.
        break
        ;;
    esac
  done

  if [[ "${failed}" -gt 0 ]]; then
    message_error "Host defaults incomplete: written=${written} verified=${verified} unchanged=${unchanged} failed=${failed} (see error above)"
    return 1
  fi

  message_success "Host defaults: written=${written} verified=${verified} unchanged=${unchanged} failed=0"
  return 0
}
