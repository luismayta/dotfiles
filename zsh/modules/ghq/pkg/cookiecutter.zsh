# shellcheck shell=bash
# shellcheck disable=SC2154 # ZSH_GHQ_FILE_COOKIECUTTER defined in config/base.zsh
# Cookiecutter integration for ghq

function ghq::cookiecutter::list {
    if [ ! -f "${ZSH_GHQ_FILE_COOKIECUTTER:-}" ]; then
        message_warning "Cookiecutter data file not found at ZSH_GHQ_FILE_COOKIECUTTER"
        return 1
    fi
    # shellcheck disable=SC2002
    cat "${ZSH_GHQ_FILE_COOKIECUTTER}" \
        | jq -r '.projects[] | [.name, .type, .description, .repository] | @tsv' \
        | sed 's/"//g'
}

function ghq::cookiecutter::find {
    if ! core::exists fzf; then
        message_warning "fzf is required for cookiecutter::find"
        return 1
    fi
    local command_value
    command_value=$(ghq::cookiecutter::list \
        | fzf \
        | awk 'BEGIN{FS="\t"; OFS=""} {print $4}' \
        | ghead -c -1
    )

    if [ -n "${command_value}" ]; then
        ZSH_GHQ_COOKIECUTTER_TEMPLATE="${command_value}"
        message_info "Selected cookiecutter template: ${ZSH_GHQ_COOKIECUTTER_TEMPLATE}"
    fi
}
