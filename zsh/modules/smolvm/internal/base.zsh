# shellcheck shell=bash

# ──────────────────────────────────────────────
# Verify helpers
# ──────────────────────────────────────────────

function smolvm::internal::verify {
  if ! core::exists smolvm; then
    message_warning "${ZSH_SMOLVM_PACKAGE_NAME} not found in PATH; cannot verify"
    return 1
  fi

  local version
  version="$(smolvm --version 2>&1)"
  if [[ "$version" != *"${ZSH_SMOLVM_VERSION}" ]]; then
    message_error "Unexpected ${ZSH_SMOLVM_PACKAGE_NAME} version: ${version} (expected ${ZSH_SMOLVM_VERSION})"
    return 1
  fi

  if ! smolvm machine run --help >/dev/null 2>&1; then
    message_error "${ZSH_SMOLVM_PACKAGE_NAME} machine run --help did not respond"
    return 1
  fi

  message_success "${ZSH_SMOLVM_PACKAGE_NAME} ${ZSH_SMOLVM_VERSION} verified"
  return 0
}
