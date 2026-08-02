#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function cleanup::system::trash {
    message_info "Empty the Trash via trash-cli or manual cleanup..."

    if type trash-put > /dev/null 2>&1; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would run: trash-empty"
        else
            trash-empty 2>/dev/null
            message_success "Trash emptied via trash-cli"
        fi
    else
        message_warning "trash-cli not found — falling back to manual Trash cleanup"
        [[ -n "${ZSH_CLEAN_LINUX_TRASH_FILES}" ]] && _cleanup::safe_remove "${ZSH_CLEAN_LINUX_TRASH_FILES}"
        [[ -n "${ZSH_CLEAN_LINUX_TRASH_INFO}" ]] && _cleanup::safe_remove "${ZSH_CLEAN_LINUX_TRASH_INFO}"
    fi

    message_success "Empty the Trash via trash-cli or manual cleanup..."
}

function cleanup::system::logs {
    message_info "Clean browser and system caches..."

    [[ -n "${ZSH_CLEAN_LINUX_CHROME_CACHE}" ]] && _cleanup::safe_remove "${ZSH_CLEAN_LINUX_CHROME_CACHE}"
    [[ -n "${ZSH_CLEAN_LINUX_FIREFOX_CACHE}" ]] && _cleanup::safe_remove "${ZSH_CLEAN_LINUX_FIREFOX_CACHE}"
    [[ -n "${ZSH_CLEAN_LINUX_THUMBNAILS}" ]] && _cleanup::safe_remove "${ZSH_CLEAN_LINUX_THUMBNAILS}"

    message_success "Clean browser and system caches..."
}

function cleanup::linux::journal {
    message_info "Clean systemd journal logs..."

    if type journalctl > /dev/null 2>&1; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would run: journalctl --vacuum-time=7d"
        else
            journalctl --vacuum-time=7d 2>/dev/null
            message_success "Systemd journal vacuumed to 7 days"
        fi
    else
        message_warning "journalctl not found — falling back to journal cache cleanup"
        [[ -n "${ZSH_CLEAN_LINUX_JOURNAL_CACHE}" ]] && _cleanup::safe_remove "${ZSH_CLEAN_LINUX_JOURNAL_CACHE}"
    fi

    message_success "Clean systemd journal logs..."
}

function cleanup::linux::tmp {
    message_info "Clean old temporary files from /tmp..."

    local -a find_args=(find "${ZSH_CLEAN_LINUX_TMP}" -type f -name "*" -mtime +7)

    local count
    count=$("${find_args[@]}" 2>/dev/null | wc -l)

    if [[ "${count}" -gt 0 ]]; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would remove ${count} old files from /tmp"
            "${find_args[@]}" 2>/dev/null | while IFS= read -r item; do
                message_info "  - ${item}"
            done
        else
            _cleanup::confirm "Remove ${count} old files from /tmp?" "${count}" || return 0
            "${find_args[@]}" -exec rm -rf {} + 2>/dev/null
            [[ "${ZSH_CLEAN_VERBOSE}" == "true" ]] && message_success "Removed ${count} old files from /tmp"
        fi
    fi

    message_success "Clean old temporary files from /tmp..."
}
