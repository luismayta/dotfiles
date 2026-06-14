# shellcheck shell=bash

function backup {
    typeset today
    typeset path_today
    typeset file_backup

    if [ ! -d "${DOTFILES_BACKUP_PATH}" ]; then
        message_info "not exist path ~/.backup"
        return
    fi
    if [ -z "${1}" ] || [ ! -r "${1}" ]; then
        message_info "is it necessary file"
        return
    fi

    today=$(date +%Y%m%d)
    path_today="${DOTFILES_BACKUP_PATH}/${today}"
    mkdir -p "${path_today}"
    file_backup="${path_today}/${1##*/}"
    cp -rf "${1}" "$file_backup"
}

#
# Project-level backup — rsync-based snapshot
#

core::backup::snapshot() {
  if [[ -z "${CORE_PROJECTS_BACKUP_PATH}" ]]; then
    core::internal::message::error "CORE_PROJECTS_BACKUP_PATH is not set"
    return 1
  fi

  local module_path
  module_path="$(git::internal::get_module_path)"

  local branch="no-git"
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch="$(git rev-parse --abbrev-ref HEAD | tr '/' '-')"
  fi

  local dest="${CORE_PROJECTS_BACKUP_PATH}/${module_path}/${branch}"

  core::internal::message::info "Syncing backup → ${dest}"

  mkdir -p "${dest}"

  rsync -avhP --delete \
    --exclude=".git" \
    --exclude=".task" \
    --exclude=".terraform" \
    --exclude=".venv" \
    --exclude="__pycache__" \
    --exclude=".mypy_cache" \
    --exclude=".pytest_cache" \
    --exclude="node_modules" \
    --exclude=".DS_Store" \
    ./ "${dest}"

  core::internal::message::success "Backup saved to ${dest}"
}
