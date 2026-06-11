# shellcheck shell=bash

function ssh::internal::ssh::upgrade {
    message_warning "method not implemented ${SSH_PACKAGE_NAME}"
}

function ssh::internal::ssh::list {
    less "${SSH_CONFIG_FILE}" | grep -i '^host[[:space:]]*' | sed 's/^[Hh][Oo][Ss][Tt][[:space:]]*//;'
}

function ssh::internal::ssh::build {
    assh config build > "${SSH_CONFIG_FILE}"
}

function ssh::internal::ssh::connect {
    local buffer
    buffer=$(ssh::internal::ssh::list | fzf)
    if [ -n "${buffer}" ]; then
        echo -e "ssh ${buffer}" | ghead -c -1 | pbcopy
    fi
}

function ssh::internal::ssh::sync {
    rsync -avzh --progress "${SSH_DATA_PATH}/" "${HOME}/.ssh/"
}
