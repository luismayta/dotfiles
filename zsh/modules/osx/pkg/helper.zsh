# shellcheck shell=bash
#
# osx / pkg / helper — the setup orchestrator.
#
# This file holds the one public function that composes other public functions,
# which is exactly what docs/guides/create-module.md section 5 (lines 411-445)
# places in pkg/helper.zsh. No pkg/setup.zsh is created: `zed` has one, but
# zed/pkg/helper.zsh is now a single line reading "Setup moved to
# pkg/setup.zsh", which makes it a migration artifact rather than a pattern to
# copy (design D5).
#
# The orchestrator configures; the refresh entry point resets the live session.
# Those are different moments and different intents, so this function never
# touches the refresh. Installing a module must not cost the user their Finder
# and Dock windows as a side effect, and the module-load path reaches this
# function automatically — a restart hidden inside an install would fire from
# every shell and every provisioning script, which is the failure mode design D4
# exists to prevent.
#
# Each public function name appears in this file exactly once, on purpose. The
# greps over this file are the assertions for task 6.4 — one definition of the
# orchestrator, one call of each of the two it composes, zero occurrences of the
# refresh entry point — and a comment naming any of them would make those counts
# ambiguous. The rationale above therefore says "the refresh entry point" rather
# than repeating the function's name.
#
osx::setup() {
  local -i rc

  message_info "osx: setting up..."

  osx::install
  rc="${?}"
  if (( rc != 0 )); then
    message_error "osx: setup stopped at the precondition check — nothing was applied."
    return 1
  fi

  osx::sync
  rc="${?}"
  if (( rc != 0 )); then
    message_error "osx: setup ran but finished with errors — see the report above."
    return 1
  fi

  message_success "osx: setup complete. The live session still runs the previous configuration until the refresh entry point is invoked."
  return 0
}
