# shellcheck shell=bash
# shellcheck disable=SC2154 # SCMBREEZE_PACKAGE_NAME defined in config/base.zsh

function scmbreeze::internal::install {
    message_info "Installing ${SCMBREEZE_PACKAGE_NAME}"
    git clone "${SCMBREEZE_INSTALL_URL}" "${SCMBREEZE_ROOT}"
    "${SCMBREEZE_ROOT}/install.sh"
    message_success "Installed ${SCMBREEZE_PACKAGE_NAME}"
}

function scmbreeze::internal::load {
    # Add SCMBREEZE to PATH for scripting
    # shellcheck source=/dev/null
    [ -s "${SCMBREEZE_ROOT}/scm_breeze.sh" ] && source "${SCMBREEZE_ROOT}/scm_breeze.sh"
}
