#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# ── Override Notice ────────────────────────────────────────────────────────
# The pattern lists (ZSH_CLEAN_BASE_DIR_PATTERNS, ZSH_CLEAN_BASE_FILE_PATTERNS,
# ZSH_CLEAN_AGGRESSIVE_PATTERNS) are unset and re-derived on every load
# (anti-stale), so they are NOT overridable before sourcing — only extendable
# via ZSH_CLEAN_USER_DIR_PATTERNS / ZSH_CLEAN_USER_FILE_PATTERNS.
# The variables below CAN be overridden by setting them BEFORE sourcing this
# module (they are guarded with a :- default):
#   ZSH_CLEAN_ENABLED, ZSH_CLEAN_DRY_RUN, ZSH_CLEAN_CONFIRM, ZSH_CLEAN_VERBOSE, ZSH_CLEAN_FORCE,
#   ZSH_CLEAN_BASE_CACHE_NPM, ZSH_CLEAN_BASE_CACHE_YARN, ZSH_CLEAN_BASE_CACHE_PIP,
#   ZSH_CLEAN_BASE_CACHE_PRE_COMMIT, ZSH_CLEAN_BASE_CACHE_TERRAFORM, ZSH_CLEAN_BASE_CACHE_VIRTUALENVS,
#   ZSH_CLEAN_BASE_CACHE_CARGO, ZSH_CLEAN_BASE_CACHE_CCACHE, ZSH_CLEAN_BASE_CACHE_BUN, ZSH_CLEAN_BASE_CACHE_PNPM
# Legacy CLEAN_* aliases are no longer exported or read (single source of truth: ZSH_CLEAN_*).

ZSH_CLEAN_ENABLED="${ZSH_CLEAN_ENABLED:-true}"

export ZSH_CLEAN_MESSAGE_NOT_IMPLEMENTED="Function not available for ${OSTYPE}. Check for updates or contribute implementation."
export ZSH_CLEAN_PACKAGE_NAME=clean

# Re-derive defaults every load — prevents stale exports from freezing old pattern lists.
# The legacy CLEAN_* aliases were removed (single source of truth: ZSH_CLEAN_*); the
# unsets below are kept defensively to clear pre-migration env exports from old shells.
unset ZSH_CLEAN_BASE_DIR_PATTERNS ZSH_CLEAN_BASE_FILE_PATTERNS ZSH_CLEAN_AGGRESSIVE_PATTERNS \
      CLEAN_BASE_DIR_PATTERNS CLEAN_BASE_FILE_PATTERNS CLEAN_AGGRESSIVE_PATTERNS

# ── Build Artifact Directories ────────────────────────────────────────────
# These are matched by name in the current directory tree
# Generic names (build, dist, out, release, debug, target, vendor, tmp,
# temp, coverage, eggs, venv) are NOT included here — they are valid values
# for ZSH_CLEAN_AGGRESSIVE_PATTERNS (see below) and only match when explicitly set.
export ZSH_CLEAN_BASE_DIR_PATTERNS="${ZSH_CLEAN_BASE_DIR_PATTERNS:-node_modules|jspm_packages|typings|.npm|.vagrant|.wercker|.eggs|*.egg-info|.pytest_cache|.hypothesis|htmlcov|.mypy_cache|.lib-cov|bower_components|.venv|venv.back|.next|.nuxt|.cache|.grunt|.fusebox|.dynamodb|.cache-loader|.turbo|.parcel-cache|.svelte-kit|.angular|.ruff_cache|.pyre|.tox|.nox|.scannerwork|.terragrunt-cache|.gradle|.cargo|.lycheecache|.cq|.coverage|.tmp|pip-wheel-metadata|CMakeFiles|cmake-build-*|Testing|__pycache__|.external_modules}"

# ── Aggressive Patterns (opt-in) ──────────────────────────────────────────
# Generic directory names matched at any depth. Dangerous from $HOME (e.g.
# build/, dist/, vendor/, tmp/) — only removed when explicitly enabled:
#   export ZSH_CLEAN_AGGRESSIVE_PATTERNS="build|dist|out|release|debug|target|vendor|tmp|temp|coverage|eggs|venv"
# Default is empty: no generic patterns are removed.
export ZSH_CLEAN_AGGRESSIVE_PATTERNS="${ZSH_CLEAN_AGGRESSIVE_PATTERNS:-}"

# ── Temporary/Unnecessary Files ───────────────────────────────────────────
# These glob patterns are matched for removal
export ZSH_CLEAN_BASE_FILE_PATTERNS="${ZSH_CLEAN_BASE_FILE_PATTERNS:-.DS_Store|*.pyc|*.orig|*.retry|*.tmp|*.egg|*.log|Thumbs.db|Desktop.ini|coverage.out}"

# ── User Extension Patterns ───────────────────────────────────────────────
# Merged with defaults at runtime (anti-stale). No legacy aliases — these are
# new variables, and no unset — users export them explicitly per session.
export ZSH_CLEAN_USER_DIR_PATTERNS="${ZSH_CLEAN_USER_DIR_PATTERNS:-}"
export ZSH_CLEAN_USER_FILE_PATTERNS="${ZSH_CLEAN_USER_FILE_PATTERNS:-}"

# ── Tool Cache Paths ──────────────────────────────────────────────────────
# Standard cache directories used by common development tools
export ZSH_CLEAN_BASE_CACHE_NPM="${ZSH_CLEAN_BASE_CACHE_NPM:-${HOME}/.npm/_cacache}"
export ZSH_CLEAN_BASE_CACHE_YARN="${ZSH_CLEAN_BASE_CACHE_YARN:-${HOME}/.cache/yarn}"
export ZSH_CLEAN_BASE_CACHE_PIP="${ZSH_CLEAN_BASE_CACHE_PIP:-${HOME}/.cache/pip}"
export ZSH_CLEAN_BASE_CACHE_PRE_COMMIT="${ZSH_CLEAN_BASE_CACHE_PRE_COMMIT:-${HOME}/.cache/pre-commit}"
export ZSH_CLEAN_BASE_CACHE_TERRAFORM="${ZSH_CLEAN_BASE_CACHE_TERRAFORM:-${HOME}/.terraform.d}"
export ZSH_CLEAN_BASE_CACHE_VIRTUALENVS="${ZSH_CLEAN_BASE_CACHE_VIRTUALENVS:-${HOME}/.local/share/virtualenvs}"
export ZSH_CLEAN_BASE_CACHE_CARGO="${ZSH_CLEAN_BASE_CACHE_CARGO:-${HOME}/.cargo/registry/cache}"
export ZSH_CLEAN_BASE_CACHE_CCACHE="${ZSH_CLEAN_BASE_CACHE_CCACHE:-${HOME}/.ccache}"
export ZSH_CLEAN_BASE_CACHE_BUN="${ZSH_CLEAN_BASE_CACHE_BUN:-${HOME}/.bun/install/cache}"
export ZSH_CLEAN_BASE_CACHE_PNPM="${ZSH_CLEAN_BASE_CACHE_PNPM:-${HOME}/.pnpm-store}"
