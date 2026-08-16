# shellcheck shell=bash
# shellcheck disable=SC2154 # NODEJS_TOOL_NAME defined in config/base.zsh

function nodejs::internal::fnm::install {
    message_info "Installing ${NODEJS_TOOL_NAME}"
    curl -fsSL "${FNM_INSTALL_URL}" | bash
    nodejs::internal::fnm::load
    message_success "Installed ${NODEJS_TOOL_NAME}"
}

function nodejs::internal::fnm::load {
  if [ -d "${FNM_PATH}" ]; then
    export PATH="${FNM_PATH}:${PATH}"
    eval "$(fnm env)"
    eval "$(fnm env --use-on-cd --shell zsh)"
  fi
}

function nodejs::internal::packages::install {
    message_info "Installing required bun packages"
    bun install -g "${NODEJS_PACKAGES[@]}"
    message_success "Installed required bun packages"
}

function nodejs::internal::bunx::load {
    [ -e "${BUN_BIN_PATH}" ] && export PATH="${BUN_BIN_PATH}:${PATH}"
}

function nodejs::internal::bun::install {
    if core::exists bun; then
        return 0
    fi

    message_info "Installing bun..."
    if curl -fsSL "${BUN_INSTALL_URL}" | bash; then
        if core::exists bun; then
            message_success "bun installed successfully"
            return 0
        fi
        message_warning "bun install script ran but binary not found in PATH"
    fi

    message_error "Failed to install bun"
    return 1
}

function nodejs::internal::version::all::install {
    if ! core::exists fnm; then
        message_warning "not found fnm"
        return
    fi

    for version in "${NODEJS_VERSIONS[@]}"; do
        message_info "Install version of nodejs ${version}"
        fnm install "${version}"
        message_success "Installed version of nodejs ${version}"
    done
    fnm use "${NODEJS_VERSION_GLOBAL}"
    message_success "Installed versions of nodejs"

}

function nodejs::internal::version::global::install {
    if ! core::exists fnm; then
        message_warning "not found fnm"
        return
    fi
    message_info "Installing version global of nodejs ${NODEJS_VERSION_GLOBAL}"
    fnm install "${NODEJS_VERSION_GLOBAL}"
    fnm alias default "${NODEJS_VERSION_GLOBAL}"
    message_success "Installed version global of nodejs ${NODEJS_VERSION_GLOBAL}"
}

function nodejs::internal::fnm::upgrade {
    message_info "command not implemented ${NODEJS_TOOL_NAME}"
}

# nodejs::internal::sync — sync npm config to home
function nodejs::internal::sync {
    rsync -avzh --progress "${NODEJS_DATA_PATH}/sync/" "${HOME}/"
}