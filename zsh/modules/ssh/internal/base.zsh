# shellcheck shell=bash

function ssh::internal::ssh::upgrade {
    message_warning "method not implemented ${SSH_PACKAGE_NAME}"
}

function ssh::internal::ssh::list {
    < "${SSH_CONFIG_FILE}" grep -i '^host[[:space:]]*' 2>/dev/null | sed 's/^[Hh][Oo][Ss][Tt][[:space:]]*//;'
}

function ssh::internal::ssh::build {
    # Validate assh is Advanced SSH Config (moul/assh), not Anonymous Secure SHell
    if ! assh --version 2>&1 | grep -qi "advanced"; then
        message_error "ssh:build requires 'assh' from moul/assh (Advanced SSH Config). Install 'advanced-ssh-config' on Arch or 'assh' via brew."
        return 1
    fi
    # Backup existing config before overwriting
    if [[ -f "${SSH_CONFIG_FILE}" ]]; then
        cp "${SSH_CONFIG_FILE}" "${SSH_CONFIG_FILE}.backup.$(date +%Y%m%d%H%M%S)"
    fi
    assh config build > "${SSH_CONFIG_FILE}"
}

function ssh::internal::ssh::connect {
    local buffer
    buffer=$(ssh::internal::ssh::list | fzf)
    if [ -n "${buffer}" ]; then
        case "${OSTYPE}" in
            darwin*)
                print -n "ssh ${buffer}" | pbcopy
                ;;
            linux*)
                if core::exists wl-copy; then
                    print -n "ssh ${buffer}" | wl-copy
                elif core::exists xclip; then
                    print -n "ssh ${buffer}" | xclip -selection clipboard
                else
                    message_error "ssh:connect requires xclip (X11) or wl-copy (Wayland)"
                    return 1
                fi
                ;;
            *)
                message_error "ssh:connect not supported on ${OSTYPE}"
                return 1
                ;;
        esac
    fi
}

function ssh::internal::ssh::sync {
    rsync -avzh --progress "${SSH_DATA_PATH}/" "${HOME}/.ssh/"
}
