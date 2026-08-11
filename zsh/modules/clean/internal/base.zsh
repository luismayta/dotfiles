#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
#
# shellcheck disable=SC2296,SC2053 # zsh-only expansions (${(@f)}, ${(j:)}, ${~}); RHS glob match is intentional
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

# Dedupe a pattern list preserving first-seen order and dropping empty entries.
# Exact-match dedupe (`[(Ie)]`, no globbing) so a pattern repeated across the
# merged BASE|AGGRESSIVE|USER lists is evaluated only once. Prints one pattern
# per line for capture with ${(@f)...}.
_cleanup::dedupe_patterns() {
    local -a seen=()
    local p
    for p in "$@"; do
        [[ -z "${p}" ]] && continue
        (( ${seen[(Ie)${p}]} )) && continue
        seen+=("${p}")
        print -r -- "${p}"
    done
}

# Print, one per line, the patterns that have at least one match among $items.
# Usage: _cleanup::affected_groups <item>... -- <pattern>...
# Unique basenames are derived with ${item:t}; `[(I)pat]` applies native zsh
# globbing so patterns like `*.log` / `cmake-build-*` match without deps.
_cleanup::affected_groups() {
    local -a items=()
    while (( $# > 0 )); do
        [[ "$1" == "--" ]] && { shift; break; }
        items+=("$1")
        shift
    done
    local -a patterns=("$@")

    local -a basenames=()
    local item base
    for item in "${items[@]}"; do
        base="${item:t}"
        (( ${basenames[(Ie)${base}]} )) || basenames+=("${base}")
    done

    local pattern
    for pattern in "${patterns[@]}"; do
        [[ "${basenames[(I)${pattern}]}" -gt 0 ]] && print -r -- "${pattern}"
    done
}

# Build a combined find expression as an array (no eval). Prints one arg per
# line so callers capture it with ${(@f)...}.
#   _cleanup::find_expr <path> [<type>] <pattern>...
# With >1 pattern the -name terms are grouped with escaped parens — required
# by find precedence: without `\( ... \)` a trailing -exec/-delete would bind
# only to the last -name and the remaining patterns would be evaluated without
# any delete action.
_cleanup::find_expr() {
    local search_path="${1:-.}"
    local type="${2:-}"
    shift 2
    local -a patterns=("$@")

    local -a expr=(find "${search_path}")
    [[ -n "${type}" ]] && expr+=(-type "${type}")

    if (( ${#patterns[@]} > 1 )); then
        expr+=(\()
        local first=1 p
        for p in "${patterns[@]}"; do
            (( first )) || expr+=(-o)
            expr+=(-name "${p}")
            first=0
        done
        expr+=(\))
    elif (( ${#patterns[@]} == 1 )); then
        expr+=(-name "${patterns[1]}")
    fi

    # -l: one argument per line so ${(@f)...} round-trips the array intact.
    print -rl -- "${expr[@]}"
}

# Dry-run report for a consolidated sweep: one summary line (total + affected
# groups) plus the matched items grouped under each affected pattern. No
# destructive action is performed.
_cleanup::report_dry_run() {
    local label="$1"
    local count="$2"
    shift 2
    local -a items=()
    while (( $# > 0 )); do
        [[ "$1" == "--" ]] && { shift; break; }
        items+=("$1")
        shift
    done
    local -a patterns=("$@")

    local -a groups
    groups=("${(@f)$(_cleanup::affected_groups "${items[@]}" -- "${patterns[@]}")}")

    message_info "[DRY RUN] Would remove ${count} items (${label}) matching: ${(j:, :)groups}"

    local pattern item
    for pattern in "${groups[@]}"; do
        for item in "${items[@]}"; do
            [[ "${item:t}" == ${~pattern} ]] && message_info "  - ${item}"
        done
    done
}

# Safe find-and-remove over MULTIPLE patterns in ONE find invocation
# (dirs: `-type d` + `-exec rm -rf {} +`) with a single consolidated prompt.
# Usage: _cleanup::safe_find_remove <path> <pattern>...
_cleanup::safe_find_remove() {
    local search_path="${1:-.}"
    shift
    local -a patterns=("$@")

    (( ${#patterns[@]} > 0 )) || return 0

    local -a expr
    expr=("${(@f)$(_cleanup::find_expr "${search_path}" "d" "${patterns[@]}")}")

    local -a items
    items=("${(@f)$("${expr[@]}" 2>/dev/null)}")
    # Drop blank lines: ${(@f)$(cmd)} yields a phantom "" element when the
    # command outputs nothing, which would fake a 1-item sweep.
    items=("${(@)items:#}")

    local count=${#items[@]}
    if (( count == 0 )); then
        return 0
    fi

    if _cleanup::is_dry_run; then
        _cleanup::report_dry_run "dirs" "${count}" "${items[@]}" -- "${patterns[@]}"
        return 0
    fi

    local -a groups
    groups=("${(@f)$(_cleanup::affected_groups "${items[@]}" -- "${patterns[@]}")}")

    # NOTE: the total is already inline in the message — do NOT pass count to
    # _cleanup::confirm or it would append a duplicate "(N items)".
    _cleanup::confirm "Remove ${count} items (dirs) matching: ${(j:, :)groups}?" || return 0

    "${expr[@]}" -exec rm -rf {} + 2>/dev/null
    [[ "${ZSH_CLEAN_VERBOSE}" == "true" ]] && message_success "Removed ${count} items (dirs) matching: ${(j:, :)groups}"
}

# Safe find-and-delete over MULTIPLE patterns in ONE find invocation
# (files: `-delete`, no `-type`) with a single consolidated prompt.
# Usage: _cleanup::safe_find_delete <path> <pattern>...
# NOTE (pre-existing quirk, do NOT change): a directory (empty or not) whose
# name matches a file pattern can be counted or deleted by `-delete`.
_cleanup::safe_find_delete() {
    local search_path="${1:-.}"
    shift
    local -a patterns=("$@")

    (( ${#patterns[@]} > 0 )) || return 0

    local -a expr
    expr=("${(@f)$(_cleanup::find_expr "${search_path}" "" "${patterns[@]}")}")

    local -a items
    items=("${(@f)$("${expr[@]}" 2>/dev/null)}")
    # Drop blank lines (phantom "" element on empty output — see safe_find_remove).
    items=("${(@)items:#}")

    local count=${#items[@]}
    if (( count == 0 )); then
        return 0
    fi

    if _cleanup::is_dry_run; then
        _cleanup::report_dry_run "files" "${count}" "${items[@]}" -- "${patterns[@]}"
        return 0
    fi

    local -a groups
    groups=("${(@f)$(_cleanup::affected_groups "${items[@]}" -- "${patterns[@]}")}")

    # NOTE: same as safe_find_remove — total is inline, no count argument.
    _cleanup::confirm "Remove ${count} items (files) matching: ${(j:, :)groups}?" || return 0

    "${expr[@]}" -delete 2>/dev/null
    [[ "${ZSH_CLEAN_VERBOSE}" == "true" ]] && message_success "Removed ${count} items (files) matching: ${(j:, :)groups}"
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

# Remove unnecessary directories and files using config patterns (no eval).
# Each sweep (dirs, files) runs ONE consolidated find (combined -o expression)
# and ONE consolidated confirmation with total + affected groups.
function _cleanup::unnecessary {
    message_info "Clean files unnecessary"
    # Merge base + opt-in aggressive + user dir patterns (same merge as before),
    # then dedupe preserving first-seen order so no pattern is evaluated twice
    # and the report/prompt are not inflated.
    local -a dir_patterns file_patterns
    IFS='|' read -rA dir_patterns <<< "${ZSH_CLEAN_BASE_DIR_PATTERNS}|${ZSH_CLEAN_AGGRESSIVE_PATTERNS}|${ZSH_CLEAN_USER_DIR_PATTERNS}"
    dir_patterns=("${(@f)$(_cleanup::dedupe_patterns "${dir_patterns[@]}")}")
    dir_patterns=("${(@)dir_patterns:#}")

    IFS='|' read -rA file_patterns <<< "${ZSH_CLEAN_BASE_FILE_PATTERNS}|${ZSH_CLEAN_USER_FILE_PATTERNS}"
    file_patterns=("${(@f)$(_cleanup::dedupe_patterns "${file_patterns[@]}")}")
    file_patterns=("${(@)file_patterns:#}")

    (( ${#dir_patterns[@]} > 0 )) && _cleanup::safe_find_remove "." "${dir_patterns[@]}"
    (( ${#file_patterns[@]} > 0 )) && _cleanup::safe_find_delete "." "${file_patterns[@]}"
    message_success "Clean files unnecessary"
}
