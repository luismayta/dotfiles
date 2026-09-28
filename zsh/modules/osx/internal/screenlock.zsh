# shellcheck shell=bash
#
# osx / internal / screenlock — read-only report of the screen-lock policy.
#
# Why this file never writes. The source states the screen-lock password
# requirement twice, and the two places disagree on the delay
# (zsh-osx/internal/base.zsh:184 = -int 0 against :354 = -int 5), so the
# effective value depends on the order the source happens to run in rather than
# on any intent. On top of that, askForPassword is no longer the official
# route: the CIS Ventura Apple macOS 13 benchmark points at
# `sysadminctl -screenLock` or an MDM profile instead. Setting the key anyway
# would quietly perpetuate a dead default — a clean-looking preference the
# system no longer honours — which is worse than reporting the drift, because
# the drift report at least tells the truth.
#
# So this file only ever reads. There is deliberately no write invocation of
# any kind here, and adding one would destroy the single guarantee this
# capability exists to make. The useful half of the job is the remedy: every
# report names the supported mechanism next to the drift, so the output is a
# diagnostic with an attached fix rather than a bare statement that something
# is wrong.
#

osx::internal::screenlock::report() {
  local -r domain="com.apple.screensaver"

  if ! core::exists defaults; then
    message_error "defaults is required to report the screen-lock policy but was not found."
    return 1
  fi

  # The values actually in effect right now. A missing key is a legitimate
  # result — an unmanaged machine has no askForPassword at all — so an absent
  # key collapses to the empty string rather than aborting the report.
  local ask_password="" ask_password_delay=""
  ask_password=$(defaults read "${domain}" askForPassword 2>/dev/null) || ask_password=""
  ask_password_delay=$(defaults read "${domain}" askForPasswordDelay 2>/dev/null) || ask_password_delay=""

  message_info "Screen-lock policy — read-only report, no preference is changed."
  message_info "  ${domain} askForPassword      = ${ask_password:-<unset>}"
  message_info "  ${domain} askForPasswordDelay = ${ask_password_delay:-<unset>}"

  # Documented intent: a password is required when the screen locks. The source
  # carries that requirement at zsh-osx/internal/base.zsh:183 and :353 with the
  # same value at both, so the requirement itself is not in conflict — only the
  # delay below is. A satisfying value is 1/true.
  if [[ -z "${ask_password}" ]]; then
    message_warning "Drift: askForPassword has no effective value, so the requirement is unmanaged."
  elif [[ "${ask_password}" == "1" || "${ask_password}" == "true" ]]; then
    message_info "askForPassword matches the documented intent: a password is required at screen lock."
  else
    message_warning "Drift: askForPassword is '${ask_password}', but the documented intent is a required password (1)."
  fi

  # The delay is the structural defect. The source states it twice and the two
  # statements contradict each other, so whichever statement runs last is the
  # one that survives. Sync order places dock after screen, which is why 5 wins
  # over 0 in practice and why the effective value is a fact about the sync
  # sequence rather than about the intent.
  message_warning "Drift: the source states the delay twice with conflicting values, so the effective value follows execution order rather than intent."
  message_warning "  ${domain} askForPasswordDelay: zsh-osx/internal/base.zsh:184 = -int 0 against zsh-osx/internal/base.zsh:354 = -int 5"
  message_warning "  Sync order places dock after screen, so 5 is the value that currently wins over 0."

  message_info "Supported mechanism (CIS Ventura Apple macOS 13): sysadminctl -screenLock, or an MDM profile carrying the setting."
  message_info "The ${domain} route is no longer the supported path, which is why the drift is reported and the key is left alone."
  return 0
}
