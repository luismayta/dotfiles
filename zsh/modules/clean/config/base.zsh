#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# ── Override Notice ────────────────────────────────────────────────────────
# All variables below can be overridden by setting them BEFORE sourcing
# this module. Example:
#   export CLEAN_BASE_CACHE_PIP="/custom/pip/cache"

ZSH_CLEAN_ENABLED="${ZSH_CLEAN_ENABLED:-true}"

export CLEAN_MESSAGE_NOT_IMPLEMENTED="Function not available for ${OSTYPE}. Check for updates or contribute implementation."
export CLEAN_PACKAGE_NAME=clean

# ── Build Artifact Directories ────────────────────────────────────────────
# These are matched by name in the current directory tree
export CLEAN_BASE_DIR_PATTERNS="node_modules|jspm_packages|typings|.npm|.vagrant|.wercker|eggs|.eggs|*.egg-info|.pytest_cache|.hypothesis|docs/_build/|htmlcov|.mypy_cache|.lib-cov|bower_components|.venv|venv|env.back|venv.back|.next|.nuxt|.cache|.grunt|.vuepress/dist|.fusebox|.dynamodb|.task|coverage"

# ── Temporary/Unnecessary Files ───────────────────────────────────────────
# These glob patterns are matched for removal
export CLEAN_BASE_FILE_PATTERNS=".DS_Store|*.pyc|*.orig|*.retry|*.tmp|*.egg"

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
