#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# ── Override Notice ────────────────────────────────────────────────────────
# Only the variables below can be overridden by setting them BEFORE sourcing
# this module (they are guarded with a :- default). All other variables in
# this module are internal to clean and should not be set externally.
#   ZSH_CLEAN_ENABLED, ZSH_CLEAN_BASE_DIR_PATTERNS, ZSH_CLEAN_BASE_FILE_PATTERNS,
#   ZSH_CLEAN_AGGRESSIVE_PATTERNS, ZSH_CLEAN_DRY_RUN, ZSH_CLEAN_CONFIRM, ZSH_CLEAN_VERBOSE, ZSH_CLEAN_FORCE

ZSH_CLEAN_ENABLED="${ZSH_CLEAN_ENABLED:-true}"

export ZSH_CLEAN_MESSAGE_NOT_IMPLEMENTED="Function not available for ${OSTYPE}. Check for updates or contribute implementation."
export CLEAN_MESSAGE_NOT_IMPLEMENTED="${ZSH_CLEAN_MESSAGE_NOT_IMPLEMENTED}"  # remove in next cleanup cycle
export ZSH_CLEAN_PACKAGE_NAME=clean
export CLEAN_PACKAGE_NAME="${ZSH_CLEAN_PACKAGE_NAME}"  # remove in next cleanup cycle

# Re-derive defaults every load — prevents stale exports from freezing old pattern lists
unset ZSH_CLEAN_BASE_DIR_PATTERNS ZSH_CLEAN_BASE_FILE_PATTERNS ZSH_CLEAN_AGGRESSIVE_PATTERNS

# ── Build Artifact Directories ────────────────────────────────────────────
# These are matched by name in the current directory tree
# Generic names (build, dist, out, release, debug, target, vendor, tmp,
# temp, coverage, eggs, venv) are NOT included here — they are valid values
# for ZSH_CLEAN_AGGRESSIVE_PATTERNS (see below) and only match when explicitly set.
export ZSH_CLEAN_BASE_DIR_PATTERNS="${ZSH_CLEAN_BASE_DIR_PATTERNS:-${CLEAN_BASE_DIR_PATTERNS:-node_modules|jspm_packages|typings|.npm|.vagrant|.wercker|.eggs|*.egg-info|.pytest_cache|.hypothesis|htmlcov|.mypy_cache|.lib-cov|bower_components|.venv|venv.back|.next|.nuxt|.cache|.grunt|.fusebox|.dynamodb|.cache-loader|.turbo|.parcel-cache|.svelte-kit|.angular|.ruff_cache|.pyre|.tox|.nox|.scannerwork|.terragrunt-cache|.gradle|.cargo|.lycheecache|.cq|.coverage|.tmp|pip-wheel-metadata|CMakeFiles|cmake-build-*|Testing|__pycache__|.external_modules}}"
export CLEAN_BASE_DIR_PATTERNS="${ZSH_CLEAN_BASE_DIR_PATTERNS}"  # remove in next cleanup cycle

# ── Aggressive Patterns (opt-in) ──────────────────────────────────────────
# Generic directory names matched at any depth. Dangerous from $HOME (e.g.
# build/, dist/, vendor/, tmp/) — only removed when explicitly enabled:
#   export ZSH_CLEAN_AGGRESSIVE_PATTERNS="build|dist|out|release|debug|target|vendor|tmp|temp|coverage|eggs|venv"
# Default is empty: no generic patterns are removed.
export ZSH_CLEAN_AGGRESSIVE_PATTERNS="${ZSH_CLEAN_AGGRESSIVE_PATTERNS:-${CLEAN_AGGRESSIVE_PATTERNS:-}}"
export CLEAN_AGGRESSIVE_PATTERNS="${ZSH_CLEAN_AGGRESSIVE_PATTERNS}"  # remove in next cleanup cycle

# ── Temporary/Unnecessary Files ───────────────────────────────────────────
# These glob patterns are matched for removal
export ZSH_CLEAN_BASE_FILE_PATTERNS="${ZSH_CLEAN_BASE_FILE_PATTERNS:-${CLEAN_BASE_FILE_PATTERNS:-.DS_Store|*.pyc|*.orig|*.retry|*.tmp|*.egg|*.log|Thumbs.db|Desktop.ini|coverage.out}}"
export CLEAN_BASE_FILE_PATTERNS="${ZSH_CLEAN_BASE_FILE_PATTERNS}"  # remove in next cleanup cycle

# ── User Extension Patterns ───────────────────────────────────────────────
# Merged with defaults at runtime (anti-stale). No legacy aliases — these are
# new variables, and no unset — users export them explicitly per session.
export ZSH_CLEAN_USER_DIR_PATTERNS="${ZSH_CLEAN_USER_DIR_PATTERNS:-}"
export ZSH_CLEAN_USER_FILE_PATTERNS="${ZSH_CLEAN_USER_FILE_PATTERNS:-}"

# ── Tool Cache Paths ──────────────────────────────────────────────────────
# Standard cache directories used by common development tools
export ZSH_CLEAN_BASE_CACHE_NPM="${HOME}/.npm/_cacache"
export CLEAN_BASE_CACHE_NPM="${ZSH_CLEAN_BASE_CACHE_NPM}"  # remove in next cleanup cycle
export ZSH_CLEAN_BASE_CACHE_YARN="${HOME}/.cache/yarn"
export CLEAN_BASE_CACHE_YARN="${ZSH_CLEAN_BASE_CACHE_YARN}"  # remove in next cleanup cycle
export ZSH_CLEAN_BASE_CACHE_PIP="${HOME}/.cache/pip"
export CLEAN_BASE_CACHE_PIP="${ZSH_CLEAN_BASE_CACHE_PIP}"  # remove in next cleanup cycle
export ZSH_CLEAN_BASE_CACHE_PRE_COMMIT="${HOME}/.cache/pre-commit"
export CLEAN_BASE_CACHE_PRE_COMMIT="${ZSH_CLEAN_BASE_CACHE_PRE_COMMIT}"  # remove in next cleanup cycle
export ZSH_CLEAN_BASE_CACHE_TERRAFORM="${HOME}/.terraform.d"
export CLEAN_BASE_CACHE_TERRAFORM="${ZSH_CLEAN_BASE_CACHE_TERRAFORM}"  # remove in next cleanup cycle
export ZSH_CLEAN_BASE_CACHE_VIRTUALENVS="${HOME}/.local/share/virtualenvs"
export CLEAN_BASE_CACHE_VIRTUALENVS="${ZSH_CLEAN_BASE_CACHE_VIRTUALENVS}"  # remove in next cleanup cycle
export ZSH_CLEAN_BASE_CACHE_CARGO="${HOME}/.cargo/registry/cache"
export CLEAN_BASE_CACHE_CARGO="${ZSH_CLEAN_BASE_CACHE_CARGO}"  # remove in next cleanup cycle
export ZSH_CLEAN_BASE_CACHE_CCACHE="${HOME}/.ccache"
export CLEAN_BASE_CACHE_CCACHE="${ZSH_CLEAN_BASE_CACHE_CCACHE}"  # remove in next cleanup cycle
export ZSH_CLEAN_BASE_CACHE_BUN="${HOME}/.bun/install/cache"
export CLEAN_BASE_CACHE_BUN="${ZSH_CLEAN_BASE_CACHE_BUN}"  # remove in next cleanup cycle
export ZSH_CLEAN_BASE_CACHE_PNPM="${HOME}/.pnpm-store"
export CLEAN_BASE_CACHE_PNPM="${ZSH_CLEAN_BASE_CACHE_PNPM}"  # remove in next cleanup cycle
