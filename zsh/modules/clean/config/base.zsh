#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# ── Override Notice ────────────────────────────────────────────────────────
# Only the variables below can be overridden by setting them BEFORE sourcing
# this module (they are guarded with a :- default). All other variables in
# this module are internal to clean and should not be set externally.
#   ZSH_CLEAN_ENABLED, CLEAN_BASE_DIR_PATTERNS, CLEAN_BASE_FILE_PATTERNS,
#   CLEAN_AGGRESSIVE_PATTERNS, CLEAN_DRY_RUN, CLEAN_CONFIRM, CLEAN_VERBOSE, CLEAN_FORCE

ZSH_CLEAN_ENABLED="${ZSH_CLEAN_ENABLED:-true}"

export CLEAN_MESSAGE_NOT_IMPLEMENTED="Function not available for ${OSTYPE}. Check for updates or contribute implementation."
export CLEAN_PACKAGE_NAME=clean

# ── Build Artifact Directories ────────────────────────────────────────────
# These are matched by name in the current directory tree
# Generic names (build, dist, out, release, debug, target, vendor, tmp,
# temp, coverage, eggs, venv) are NOT included here — they are valid values
# for CLEAN_AGGRESSIVE_PATTERNS (see below) and only match when explicitly set.
export CLEAN_BASE_DIR_PATTERNS="${CLEAN_BASE_DIR_PATTERNS:-node_modules|jspm_packages|typings|.npm|.vagrant|.wercker|.eggs|*.egg-info|.pytest_cache|.hypothesis|htmlcov|.mypy_cache|.lib-cov|bower_components|.venv|venv.back|.next|.nuxt|.cache|.grunt|.fusebox|.dynamodb|.cache-loader|.turbo|.parcel-cache|.svelte-kit|.angular|.ruff_cache|.pyre|.tox|.nox|.scannerwork|.terragrunt-cache|.gradle|.cargo|.lycheecache|.cq|.coverage|.tmp|pip-wheel-metadata|CMakeFiles|cmake-build-*|Testing|__pycache__|.external_modules}"

# ── Aggressive Patterns (opt-in) ──────────────────────────────────────────
# Generic directory names matched at any depth. Dangerous from $HOME (e.g.
# build/, dist/, vendor/, tmp/) — only removed when explicitly enabled:
#   export CLEAN_AGGRESSIVE_PATTERNS="build|dist|out|release|debug|target|vendor|tmp|temp|coverage|eggs|venv"
# Default is empty: no generic patterns are removed.
export CLEAN_AGGRESSIVE_PATTERNS="${CLEAN_AGGRESSIVE_PATTERNS:-}"

# ── Temporary/Unnecessary Files ───────────────────────────────────────────
# These glob patterns are matched for removal
export CLEAN_BASE_FILE_PATTERNS="${CLEAN_BASE_FILE_PATTERNS:-.DS_Store|*.pyc|*.orig|*.retry|*.tmp|*.egg|*.log|Thumbs.db|Desktop.ini|coverage.out}"

# ── Tool Cache Paths ──────────────────────────────────────────────────────
# Standard cache directories used by common development tools
export CLEAN_BASE_CACHE_NPM="${HOME}/.npm/_cacache"
export CLEAN_BASE_CACHE_YARN="${HOME}/.cache/yarn"
export CLEAN_BASE_CACHE_PIP="${HOME}/.cache/pip"
export CLEAN_BASE_CACHE_PRE_COMMIT="${HOME}/.cache/pre-commit"
export CLEAN_BASE_CACHE_TERRAFORM="${HOME}/.terraform.d"
export CLEAN_BASE_CACHE_VIRTUALENVS="${HOME}/.local/share/virtualenvs"
export CLEAN_BASE_CACHE_CARGO="${HOME}/.cargo/registry/cache"
export CLEAN_BASE_CACHE_CCACHE="${HOME}/.ccache"
export CLEAN_BASE_CACHE_BUN="${HOME}/.bun/install/cache"
export CLEAN_BASE_CACHE_PNPM="${HOME}/.pnpm-store"
