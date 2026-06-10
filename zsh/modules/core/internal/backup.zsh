#
# Project backup
#

core::backup::snapshot() {
  if [[ -z "${CORE_PROJECTS_BACKUP_PATH}" ]]; then
    core::internal::message::error "CORE_PROJECTS_BACKUP_PATH is not set"
    return 1
  fi

  local module_path
  module_path="$(core::git::get_module_path)"

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
