#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
#
# Safety configuration defaults
export CLEAN_DRY_RUN="${CLEAN_DRY_RUN:-false}"
export CLEAN_CONFIRM="${CLEAN_CONFIRM:-true}"
export CLEAN_VERBOSE="${CLEAN_VERBOSE:-true}"
export CLEAN_FORCE="${CLEAN_FORCE:-false}"

# ── Internal Safety Helpers ───────────────────────────────────────────────

# Check if dry-run mode is active
_cleanup::is_dry_run() {
    [[ "${CLEAN_DRY_RUN}" == "true" ]] && return 0
    return 1
}

# Check if confirmation is required
_cleanup::needs_confirmation() {
    [[ "${CLEAN_FORCE}" == "true" ]] && return 1
    [[ "${CLEAN_CONFIRM}" == "false" ]] && return 1
    return 0
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

# Safe removal with dry-run + verbose support
_cleanup::safe_remove() {
    local path="$1"

    [[ -z "${path}" || "${path}" == "/" ]] && return 0

    if [[ ! -e "${path}" ]]; then
        return 0
    fi

    if _cleanup::is_dry_run; then
        message_info "[DRY RUN] Would remove: ${path}"
        return 0
    fi

    rm -rf "${path}"
    [[ "${CLEAN_VERBOSE}" == "true" ]] && message_success "Removed: ${path}"
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
    [[ "${CLEAN_VERBOSE}" == "true" ]] && message_success "Removed ${count} items matching '${pattern}'"
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

    "${find_args[@]}" -delete 2>/dev/null
    [[ "${CLEAN_VERBOSE}" == "true" ]] && message_success "Deleted ${count} files matching '${pattern}'"
}

# Validate a path exists and is accessible
# Usage: _cleanup::validate_path "/path/to/dir" "optional label"
function _cleanup::validate_path {
    local path="$1"
    local label="${2:-path}"

    if [[ -z "${path}" ]]; then
        return 1
    fi

    if [[ ! -e "${path}" ]]; then
        [[ "${CLEAN_VERBOSE}" == "true" ]] && message_warning "${label} does not exist: ${path}"
        return 1
    fi

    if [[ ! -d "${path}" ]] && [[ ! -f "${path}" ]]; then
        [[ "${CLEAN_VERBOSE}" == "true" ]] && message_warning "${label} is not a file or directory: ${path}"
        return 1
    fi

    return 0
}

# Consolidated: remove unnecessary directories and files using config patterns (no eval)
function _cleanup::unnecessary {
    message_info "Clean files unnecessary"

    # Extra directory patterns not in config
    local extra_dirs="__pycache__|vendor|.external_modules"
    local combined_dir="${CLEAN_BASE_DIR_PATTERNS}|${extra_dirs}"

    # Remove directories matching patterns
    IFS='|' read -ra dir_patterns <<< "${combined_dir}"
    for pattern in "${dir_patterns[@]}"; do
        [[ -n "${pattern}" ]] && _cleanup::safe_find_remove "." "${pattern}" "d"
    done

    # Remove files matching patterns
    IFS='|' read -ra file_patterns <<< "${CLEAN_BASE_FILE_PATTERNS}"
    for pattern in "${file_patterns[@]}"; do
        [[ -n "${pattern}" ]] && _cleanup::safe_find_delete "." "${pattern}"
    done

    message_success "Clean files unnecessary"
}
