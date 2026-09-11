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

# chrome-headless-shell — persistent install for mermaid rendering
function nodejs::internal::chrome::install {
    if [ -d "${CHROME_HEADLESS_SHELL_PATH}" ]; then
        message_info "chrome-headless-shell already installed"
        return 0
    fi

    message_info "Installing chrome-headless-shell"
    bunx @puppeteer/browsers install chrome-headless-shell@stable --path "${CHROME_HEADLESS_SHELL_PATH}"
    message_success "Installed chrome-headless-shell"
}

function nodejs::internal::chrome::load {
    if [ -d "${CHROME_HEADLESS_SHELL_PATH}" ]; then
        message_success "chrome-headless-shell available at ${CHROME_HEADLESS_SHELL_PATH}"
    else
        message_warning "chrome-headless-shell not found"
    fi
}

function nodejs::internal::puppeteer::config {
    if [ -f "${PUPPETEER_CONFIG_PATH}" ]; then
        message_info "puppeteer config already exists"
        return 0
    fi

    local executable_path
    executable_path="$(find "${CHROME_HEADLESS_SHELL_PATH}" -type f -name "chrome-headless-shell" 2>/dev/null | head -1)"
    if [ -z "${executable_path}" ]; then
        message_error "chrome-headless-shell binary not found"
        return 1
    fi

    message_info "Generating puppeteer config at ${PUPPETEER_CONFIG_PATH}"
    cat > "${PUPPETEER_CONFIG_PATH}" <<EOF
{
  "executablePath": "${executable_path}"
}
EOF
    message_success "Generated puppeteer config"
}