#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# ── Public API: Cleanup Functions ─────────────────────────────────────────

function cleanup::all {
    message_info "Clean all files"
    if _cleanup::guard_home; then
        _cleanup::unnecessary
    else
        message_warning "Skipping tree cleanup phase — running from HOME."
    fi
    # Package managers
    cleanup::yarn
    cleanup::npm
    cleanup::pip
    cleanup::gem
    cleanup::brew
    # Modern tools
    cleanup::cargo
    cleanup::go
    cleanup::bun
    cleanup::pnpm
    cleanup::ccache
    # Development
    cleanup::pre_commit
    cleanup::terraform
    cleanup::docker
    cleanup::docker::volumes
    cleanup::python::virtualenvs
    cleanup::tasks
    # System
    cleanup::system::trash
    cleanup::system::logs
    # Platform-specific
    case "${OSTYPE}" in
        darwin*)
            cleanup::osx::adobe_cache
            cleanup::osx::ios_application
            cleanup::osx::ios_device_backup
            cleanup::osx::xcode
            ;;
        linux*)
            cleanup::linux::journal
            cleanup::linux::tmp
            ;;
    esac
    cleanup::projects
    message_success "Finish all files"
}

# Consolidated: cleanup delegates to _cleanup::unnecessary
function cleanup {
    _cleanup::guard_home || return 1
    message_info "Clean generated directories..."
    _cleanup::unnecessary
    message_success "Clean complete"
}

function cleanup::pip {
    message_info "Cleanup pip cache..."
    _cleanup::safe_remove "${ZSH_CLEAN_BASE_CACHE_PIP}"
    message_success "Cleanup pip cache..."
}

function cleanup::gem {
    if type gem > /dev/null; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would run: gem cleanup"
        else
            message_info "Cleanup any old versions of gems..."
            gem cleanup 2>/dev/null
            message_success "Cleanup any old versions of gems..."
        fi
    else
        message_warning "gem not found, skipping"
    fi
}

function cleanup::docker {
    if type docker > /dev/null; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would run: docker system prune -af"
        else
            _cleanup::confirm "Remove all unused Docker resources (containers, networks, images, build cache)?" || return 0
            message_info "Cleanup Docker..."
            docker system prune -af
            message_success "Cleanup Docker..."
        fi
    else
        message_warning "docker not found, skipping"
    fi
}

function cleanup::pre_commit {
    if [[ -n "${ZSH_CLEAN_BASE_CACHE_PRE_COMMIT}" ]]; then
        _cleanup::safe_remove "${ZSH_CLEAN_BASE_CACHE_PRE_COMMIT}"
    fi
}

function cleanup::tasks {
    message_info "Clean tasks files generated"
    _cleanup::safe_find_remove "." ".task"
    message_success "Clean files tasks"
}

function cleanup::python::pyenv {
    if type pyenv > /dev/null; then
        message_info "pyenv versions (informative — interpreters are NOT removed by default)"
        local versions
        versions="$(pyenv versions 2>/dev/null)"
        if [[ -n "${versions}" ]]; then
            message_info "Installed pyenv versions:"
            message_info "${versions}"
        else
            message_warning "No pyenv versions installed"
        fi
        message_warning "Removing Python interpreters (${HOME}/.pyenv/versions) is destructive and irreversible."
        if [[ "${ZSH_CLEAN_FORCE}" != "true" ]]; then
            message_info "Set ZSH_CLEAN_FORCE=true and run again to remove them."
        elif _cleanup::confirm "Remove all installed pyenv versions?"; then
            _cleanup::safe_remove "${HOME}/.pyenv/versions"
        fi
    else
        message_warning "pyenv not found, skipping"
    fi
}

function cleanup::python::virtualenvs {
    if [[ -n "${ZSH_CLEAN_BASE_CACHE_VIRTUALENVS}" ]]; then
        _cleanup::safe_remove "${ZSH_CLEAN_BASE_CACHE_VIRTUALENVS}"
    fi
}

function cleanup::npm {
    if type npm > /dev/null; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would run: npm cache clean --force"
        else
            message_info "Cleanup npm cache..."
            npm cache clean --force 2>/dev/null
            message_success "Cleanup npm cache..."
        fi
    else
        message_warning "npm not found, skipping"
    fi
}

function cleanup::yarn {
    if type yarn > /dev/null; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would run: yarn cache clean --force"
        else
            message_info "Cleanup Yarn Cache..."
            yarn cache clean --force 2>/dev/null
            message_success "Cleanup Yarn Cache..."
        fi
    else
        message_warning "yarn not found, skipping"
    fi
}

function cleanup::brew {
    if type brew > /dev/null; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would run: brew cleanup -s + rm brew cache"
        else
            message_info "Homebrew Cache..."
            brew cleanup -s 2>/dev/null
            _cleanup::safe_remove "$(brew --cache)"
            brew tap --repair 2>/dev/null
            message_success "Homebrew Cache..."
        fi
    else
        message_warning "brew not found, skipping"
    fi
}

function cleanup::terraform {
    message_info "Clean Terraform files"
    _cleanup::safe_find_remove "." ".terraform"
    message_success "Clean Terraform files"
}

function cleanup::projects {
    if [[ -z "${PROJECTS}" ]]; then
        message_warning "The path PROJECTS is not defined as an environment variable."
        return
    fi
    message_info "Clean files of ${PROJECTS}"
    local _oldwd="${PWD}"
    cd "${PROJECTS}" || return
    _cleanup::guard_home || { cd "${_oldwd}" || return; return 1; }
    cleanup
    cd "${_oldwd}" || return
    message_success "Clean files unnecessary"
}

function cleanup::cargo {
    if type cargo > /dev/null; then
        local cache="${ZSH_CLEAN_BASE_CACHE_CARGO:-${HOME}/.cargo/registry/cache}"
        if _cleanup::validate_path "${cache}" "Cargo cache"; then
            message_info "Cleanup Cargo registry cache..."
            _cleanup::safe_remove "${cache}"
            message_success "Cleanup Cargo registry cache..."
        fi
    else
        message_warning "cargo not found, skipping"
    fi
}

function cleanup::go {
    if type go > /dev/null; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would run: go clean -modcache"
        else
            message_info "Cleanup Go module cache..."
            go clean -modcache 2>/dev/null
            message_success "Cleanup Go module cache..."
        fi
    else
        message_warning "go not found, skipping"
    fi
}

function cleanup::bun {
    if type bun > /dev/null; then
        local cache="${ZSH_CLEAN_BASE_CACHE_BUN:-${HOME}/.bun/install/cache}"
        if _cleanup::validate_path "${cache}" "Bun cache"; then
            message_info "Cleanup Bun cache..."
            _cleanup::safe_remove "${cache}"
            message_success "Cleanup Bun cache..."
        fi
    else
        message_warning "bun not found, skipping"
    fi
}

function cleanup::pnpm {
    if type pnpm > /dev/null; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would run: pnpm store prune"
        else
            message_info "Cleanup pnpm store..."
            pnpm store prune 2>/dev/null
            local cache="${ZSH_CLEAN_BASE_CACHE_PNPM:-${HOME}/.pnpm-store}"
            if _cleanup::validate_path "${cache}" "pnpm store"; then
                _cleanup::safe_remove "${cache}"
            fi
            message_success "Cleanup pnpm store..."
        fi
    else
        message_warning "pnpm not found, skipping"
    fi
}

function cleanup::ccache {
    if type ccache > /dev/null; then
        local cache="${ZSH_CLEAN_BASE_CACHE_CCACHE:-${HOME}/.ccache}"
        if _cleanup::validate_path "${cache}" "ccache"; then
            message_info "Cleanup ccache..."
            _cleanup::safe_remove "${cache}"
            message_success "Cleanup ccache..."
        fi
    else
        message_warning "ccache not found, skipping"
    fi
}

function cleanup::docker::volumes {
    if type docker > /dev/null; then
        if _cleanup::is_dry_run; then
            message_info "[DRY RUN] Would run: docker volume prune -f"
        else
            _cleanup::confirm "Remove all unused Docker volumes?" || return 0
            message_info "Cleanup Docker volumes..."
            docker volume prune -f
            message_success "Cleanup Docker volumes..."
        fi
    else
        message_warning "docker not found, skipping"
    fi
}

function cleanup::help {
    message_info "Clean module — Available functions and config"
    echo ""
    echo "Core cleanup:"
    echo "  cleanup              - Remove unnecessary files (node_modules, .cache, etc.)"
    echo "  cleanup::all         - Full cleanup (all functions below)"
    echo "  cleanup::projects    - Clean project directories"
    echo ""
    echo "Package managers:"
    echo "  cleanup::npm         - npm cache"
    echo "  cleanup::yarn        - yarn cache"
    echo "  cleanup::pip         - pip cache"
    echo "  cleanup::gem         - gem cache"
    echo "  cleanup::brew        - Homebrew cache"
    echo ""
    echo "Modern tools:"
    echo "  cleanup::cargo       - Cargo registry cache"
    echo "  cleanup::go          - Go module cache"
    echo "  cleanup::bun         - Bun install cache"
    echo "  cleanup::pnpm        - pnpm store"
    echo "  cleanup::ccache      - ccache directory"
    echo ""
    echo "Development:"
    echo "  cleanup::pre_commit  - pre-commit hooks"
    echo "  cleanup::terraform   - Terraform plugins/cache"
    echo "  cleanup::docker      - Docker build cache"
    echo "  cleanup::docker::volumes - Docker volumes"
    echo "  cleanup::python::pyenv      - pyenv versions (informative; remove only with ZSH_CLEAN_FORCE=true)"
    echo "  cleanup::python::virtualenvs - virtualenvs"
    echo "  cleanup::tasks       - Task runner files"
    echo ""
    echo "System:"
    echo "  cleanup::system::trash - Empty Trash (cross-platform)"
    echo "  cleanup::system::logs  - Browser/system caches"
    echo ""
    echo "macOS (darwin only):"
    echo "  cleanup::osx::adobe_cache       - Adobe cache"
    echo "  cleanup::osx::ios_application    - iOS app caches"
    echo "  cleanup::osx::ios_device_backup  - iOS device backups"
    echo "  cleanup::osx::xcode              - Xcode derived data"
    echo ""
    echo "Linux only:"
    echo "  cleanup::linux::journal - systemd journal logs"
    echo "  cleanup::linux::tmp     - old /tmp files"
    echo ""
    echo "Safety flags:"
    echo "  export ZSH_CLEAN_DRY_RUN=true    # Show what would happen"
    echo "  export ZSH_CLEAN_CONFIRM=true    # Prompt before each deletion"
    echo "  export ZSH_CLEAN_VERBOSE=true    # Show detailed output"
    echo "  export ZSH_CLEAN_FORCE=true      # Skip confirmations (also overrides the \$HOME guard)"
    echo ""
    echo "Config vars (override before sourcing):"
    echo "  ZSH_CLEAN_BASE_DIR_PATTERNS, ZSH_CLEAN_BASE_FILE_PATTERNS, ZSH_CLEAN_AGGRESSIVE_PATTERNS"
    echo "  ZSH_CLEAN_AGGRESSIVE_PATTERNS   # Opt-in generic dirs (build|dist|tmp|...); empty by default"
    echo "  ZSH_CLEAN_USER_DIR_PATTERNS     # Extra dir patterns merged with defaults at runtime (anti-stale)"
    echo "  ZSH_CLEAN_USER_FILE_PATTERNS    # Extra file patterns merged with defaults at runtime (anti-stale)"
    echo "  # e.g. export ZSH_CLEAN_USER_DIR_PATTERNS=\"my_build|my_tmp\""
    echo "  # Defaults are re-derived on every load, so no manual unset is needed."
    echo "  ZSH_CLEAN_BASE_CACHE_NPM, ZSH_CLEAN_BASE_CACHE_YARN, ZSH_CLEAN_BASE_CACHE_PIP"
    echo "  ZSH_CLEAN_BASE_CACHE_PRE_COMMIT, ZSH_CLEAN_BASE_CACHE_TERRAFORM, ZSH_CLEAN_BASE_CACHE_VIRTUALENVS"
    echo "  ZSH_CLEAN_BASE_CACHE_CARGO, ZSH_CLEAN_BASE_CACHE_CCACHE, ZSH_CLEAN_BASE_CACHE_BUN, ZSH_CLEAN_BASE_CACHE_PNPM"
    echo "  ZSH_CLEAN_OSX_* (macOS), ZSH_CLEAN_LINUX_* (Linux)"
    echo "  Legacy CLEAN_* aliases are NOT supported — only ZSH_CLEAN_* variables are read (single source of truth)."
    echo ""
    echo "Guard: 'cleanup' aborts when run from \$HOME — recursive pattern matching"
    echo "  would delete personal caches (~/.cache, ~/.npm, ~/.cargo). Override with"
    echo "  ZSH_CLEAN_FORCE=true (a prominent warning is still shown)."
    echo "File-pattern cleanup (*.log, .DS_Store, ...) prompts for confirmation by"
    echo "  default; decline with 'n' or skip prompts with ZSH_CLEAN_FORCE=true."
}
