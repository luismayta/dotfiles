# shellcheck shell=bash
# shellcheck disable=SC2154 # FNM_PACKAGE_NAME defined in config/base.zsh

function fnm::internal::fnm::install {
    message_info "Installing ${FNM_PACKAGE_NAME}"
    curl -fsSL "${FNM_INSTALL_URL}" | bash
    fnm::internal::fnm::load
    message_success "Installed ${FNM_PACKAGE_NAME}"
}

function fnm::internal::fnm::load {
  if [ -d "${FNM_PATH}" ]; then
    export PATH="${FNM_PATH}:${PATH}"
    eval "$(fnm env)"
    eval "$(fnm env --use-on-cd --shell zsh)"
  fi
}

function fnm::internal::packages::install {
    if ! core::exists yarn; then
        npm install --global yarn
    fi

    message_info "Installing required yarn packages"
    yarn global add "${FNM_PACKAGES[@]}"
    message_success "Installed required yarn packages"
}

function fnm::internal::version::all::install {
    if ! core::exists fnm; then
        message_warning "not found fnm"
        return
    fi

    for version in "${FNM_VERSIONS[@]}"; do
        message_info "Install version of fnm ${version}"
        fnm install "${version}"
        message_success "Installed version of fnm ${version}"
    done
    fnm use "${FNM_VERSION_GLOBAL}"
    message_success "Installed versions of fnm"

}

function fnm::internal::version::global::install {
    if ! core::exists fnm; then
        message_warning "not found fnm"
        return
    fi
    message_info "Installing version global of fnm ${FNM_VERSION_GLOBAL}"
    fnm install "${FNM_VERSION_GLOBAL}"
    fnm alias default "${FNM_VERSION_GLOBAL}"
    message_success "Installed version global of fnm ${FNM_VERSION_GLOBAL}"
}

function fnm::internal::fnm::upgrade {
    message_info "command not implemented ${FNM_PACKAGE_NAME}"
}
