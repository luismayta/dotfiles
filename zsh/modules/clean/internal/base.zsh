#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
#
# Safety configuration defaults
export ZSH_CLEAN_DRY_RUN="${ZSH_CLEAN_DRY_RUN:-false}"
export ZSH_CLEAN_CONFIRM="${ZSH_CLEAN_CONFIRM:-true}"
export ZSH_CLEAN_VERBOSE="${ZSH_CLEAN_VERBOSE:-true}"
export ZSH_CLEAN_FORCE="${ZSH_CLEAN_FORCE:-false}"

# ── Internal Safety Helpers ───────────────────────────────────────────────

_cleanup::is_dry_run() {
    [[ "${ZSH_CLEAN_DRY_RUN}" == "true" ]]
}

_cleanup::needs_confirmation() {
    [[ "${ZSH_CLEAN_FORCE}" != "true" && "${ZSH_CLEAN_CONFIRM}" != "false" ]]
}

# Prompt for confirmation — returns 0 if approved, 1 if declined
_cleanup::confirm() {
    local message="$1"
    local count="${2:-}"

    if ! _cleanup::needs_confirmation; then
        return 0
    fi

    if [[ -n "${count}" ]]; then
        message="${message} (${count} items)"
    fi

    echo -n "${message} [y/N]: "
    read -r response
    [[ "${response}" =~ ^[Yy]$ ]] && return 0
    return 1
}

# Refuse to run tree cleanup from $HOME — personal caches live there.
_cleanup::guard_home() {
    [[ "${PWD}" == "${HOME}" ]] || return 0
    if [[ "${ZSH_CLEAN_FORCE:-false}" == "true" ]]; then
        message_warning "WARNING: Cleaning from HOME (${HOME}) — caches like ~/.cache, ~/.npm, ~/.cargo may be removed."
        return 0
    fi
    message_warning "Refusing to clean the current directory: it is your HOME (${HOME})."
    message_warning "Personal caches (~/.cache, ~/.npm, ~/.cargo) live here and would be deleted."
    message_warning "Run from a project directory, use cleanup::all, or set ZSH_CLEAN_FORCE=true to override."
    return 1
}

# Safe removal with dry-run + verbose support
# NOTE: param named `target` — `local path=...` would clobber PATH (path is
# the tied special array for PATH in zsh) and break `rm` lookup.
_cleanup::safe_remove() {
    local target="$1"

    [[ -z "${target}" || "${target}" == "/" ]] && return 0

    if [[ ! -e "${target}" ]]; then
        return 0
    fi

    if _cleanup::is_dry_run; then
        message_info "[DRY RUN] Would remove: ${target}"
        return 0
    fi

    _cleanup::confirm "Remove: ${target}?" || return 0

    rm -rf "${target}"
    [[ "${ZSH_CLEAN_VERBOSE}" == "true" ]] && message_success "Removed: ${target}"
}

# Safe find-and-remove using arrays (no eval) with dry-run support
_cleanup::safe_find_remove() {
    local search_path="${1:-.}"
    local pattern="$2"
    local type="${3:-}"

    local -a find_args=(find "${search_path}")
    [[ -n "${type}" ]] && find_args+=(-type "${type}")
    find_args+=(-name "${pattern}")

    local count
    count=$("${find_args[@]}" 2>/dev/null | wc -l)

    if [[ "${count}" -eq 0 ]]; then
        return 0
    fi

    if _cleanup::is_dry_run; then
        message_info "[DRY RUN] Would remove ${count} items matching '${pattern}'"
        "${find_args[@]}" 2>/dev/null | while IFS= read -r item; do
            message_info "  - ${item}"
        done
        return 0
    fi

    _cleanup::confirm "Remove ${count} items matching '${pattern}'?" "${count}" || return 0
    "${find_args[@]}" -exec rm -rf {} + 2>/dev/null
    [[ "${ZSH_CLEAN_VERBOSE}" == "true" ]] && message_success "Removed ${count} items matching '${pattern}'"
}

# Safe find-and-delete for files (uses -delete instead of -exec rm)
_cleanup::safe_find_delete() {
    local search_path="${1:-.}"
    local pattern="$2"

    local -a find_args=(find "${search_path}" -name "${pattern}")

    local count
    count=$("${find_args[@]}" 2>/dev/null | wc -l)

    if [[ "${count}" -eq 0 ]]; then
        return 0
    fi

    if _cleanup::is_dry_run; then
        message_info "[DRY RUN] Would delete ${count} files matching '${pattern}'"
        "${find_args[@]}" 2>/dev/null | while IFS= read -r item; do
            message_info "  - ${item}"
        done
        return 0
    fi

    _cleanup::confirm "Delete ${count} files matching '${pattern}'?" "${count}" || return 0
    "${find_args[@]}" -delete 2>/dev/null
    [[ "${ZSH_CLEAN_VERBOSE}" == "true" ]] && message_success "Deleted ${count} files matching '${pattern}'"
}

# Validate a path exists and is accessible
# Usage: _cleanup::validate_path "/path/to/dir" "optional label"
function _cleanup::validate_path {
    local target="$1"
    local label="${2:-path}"

    if [[ -z "${target}" ]]; then
        return 1
    fi

    if [[ ! -e "${target}" ]]; then
        [[ "${ZSH_CLEAN_VERBOSE}" == "true" ]] && message_warning "${label} does not exist: ${target}"
        return 1
    fi

    if [[ ! -d "${target}" ]] && [[ ! -f "${target}" ]]; then
        [[ "${ZSH_CLEAN_VERBOSE}" == "true" ]] && message_warning "${label} is not a file or directory: ${target}"
        return 1
    fi

    return 0
}

# Remove unnecessary directories and files using config patterns (no eval)
function _cleanup::unnecessary {
    message_info "Clean files unnecessary"
    # Merge base + opt-in aggressive + user dir patterns (each pattern processed once,
    # so duplicates never cause double sweeps)
    local combined="${ZSH_CLEAN_BASE_DIR_PATTERNS}|${ZSH_CLEAN_AGGRESSIVE_PATTERNS}|${ZSH_CLEAN_USER_DIR_PATTERNS}"
    IFS='|' read -rA dir_patterns <<< "${combined}"
    for pattern in "${dir_patterns[@]}"; do
        [[ -n "${pattern}" ]] && _cleanup::safe_find_remove "." "${pattern}" "d"
    done

    IFS='|' read -rA file_patterns <<< "${ZSH_CLEAN_BASE_FILE_PATTERNS}|${ZSH_CLEAN_USER_FILE_PATTERNS}"
    for pattern in "${file_patterns[@]}"; do
        [[ -n "${pattern}" ]] && _cleanup::safe_find_delete "." "${pattern}"
    done
    message_success "Clean files unnecessary"
}
