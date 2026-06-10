# shellcheck shell=bash

function backup {
    typeset today
    typeset path_today
    typeset file_backup

    if [ ! -d "${DOTFILES_BACKUP_DIR}" ]; then
        message_info "not exist path ~/.backup"
        return
    fi
    if [ -z "${1}" ] || [ ! -r "${1}" ]; then
        message_info "is it necessary file"
        return
    fi

    today=$(date +%Y%m%d)
    path_today="${DOTFILES_BACKUP_DIR}/${today}"
    mkdir -p "${path_today}"
    file_backup="${path_today}/${1##*/}"
    cp -rf "${1}" "$file_backup"
}
