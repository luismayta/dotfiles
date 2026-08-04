---
type: Guide
title: Implement Module Update
description: Guide for adding an update function to zsh modules
tags: [guide, module, update]
---

# How to Implement an Update Function in a Module

This guide explains how to add an `update` function to any zsh module so it can bring its tool to the latest version. It follows the same three-layer architecture used for install — config variables, internal logic, and a thin public wrapper — closing the lifecycle gap between install and manual reinstall. The herdr module serves as the reference implementation.

## Table of Contents

- [Overview](#overview)
- [When Do You Need update?](#when-do-you-need-update)
- [File Structure](#file-structure)
- [Step 1: Config Layer](#step-1-config-layer)
- [Step 2: Internal Layer](#step-2-internal-layer)
- [Step 3: Public Layer](#step-3-public-layer)
- [Step 4: Registration](#step-4-registration)
- [Exit-Code Semantics](#exit-code-semantics)
- [Checklist](#checklist)
- [References](#references)

---

## Overview

`update` is the install lifecycle twin: it re-runs the module's official installer to bring the tool to its latest version. It reuses the exact mechanism and validation as install — only the intent changes (upgrade instead of first-time install).

```
config/   → installer URL and package name variables
internal/ → private implementation (install, update, helpers)
pkg/      → public API functions (install, update, post_install)
```

**Layer rules:**

| Layer | Contains | Who calls it |
|-------|----------|-------------|
| `config/` | `export` env vars with `ZSH_<MODULE>_` prefix | Shell config, user overrides |
| `internal/` | Functions prefixed `<module>::internal::` | Only `pkg/` functions |
| `pkg/` | Functions prefixed `<module>::` | End user |

---

## When Do You Need update?

Add an `update` function when:

- The tool ships an **official installer** (curl-pipe installer, setup script, package manager) that fetches the latest version.
- Users reinstall manually today to upgrade — `update` makes that a one-liner.
- The module already has `install`; `update` completes the lifecycle with the same proven mechanics.

**Decision tree:**

```
Does the tool have an official installer that fetches the latest version?
├─ Yes → Add update (re-run the installer, validate PATH, return 0/1)
└─ No  → update not applicable (e.g. PATH-only tool with no upgrade path)
```

---

## File Structure

```
zsh/modules/herdr/
├── config/
│   └── base.zsh          ← ZSH_HERDR_INSTALL_URL, ZSH_HERDR_PACKAGE_NAME
├── internal/
│   ├── install.zsh       ← herdr::internal::install
│   ├── update.zsh        ← herdr::internal::update  (NEW)
│   └── main.zsh          ← sources internal/*.zsh
└── pkg/
    └── base.zsh          ← herdr::install, herdr::update (public API)
```

---

## Step 1: Config Layer

`update` reuses the installer variables already defined for `install` — no new config is required.

### Reference (herdr)

```zsh
# zsh/modules/herdr/config/base.zsh
export ZSH_HERDR_PACKAGE_NAME=herdr
export ZSH_HERDR_INSTALL_URL="https://herdr.dev/install.sh"
```

The pattern: a `ZSH_<MODULE>_PACKAGE_NAME` for messages and a `ZSH_<MODULE>_INSTALL_URL` pointing at the official installer. `update` consumes both, just like `install`.

---

## Step 2: Internal Layer

Create `internal/update.zsh` in a new file per lifecycle concern (install vs update), matching the module's per-concern file convention.

### Reference (herdr)

```zsh
# shellcheck shell=bash

# ──────────────────────────────────────────────
# Update helpers
# ──────────────────────────────────────────────

function herdr::internal::update {
    core::ensure curl

    message_info "Updating ${ZSH_HERDR_PACKAGE_NAME}..."
    if curl -fsSL "${ZSH_HERDR_INSTALL_URL}" | sh; then
        if core::exists herdr; then
            message_success "${ZSH_HERDR_PACKAGE_NAME} updated successfully"
            return 0
        fi
        message_warning "${ZSH_HERDR_PACKAGE_NAME} update script ran but binary not found in PATH"
    fi

    message_error "Failed to update ${ZSH_HERDR_PACKAGE_NAME}"
    return 1
}
```

### Key differences from install

| Aspect | `install` | `update` |
|--------|-----------|----------|
| Already-installed check | Early-returns `0` if tool exists | **Always** re-runs the installer (latest version) |
| Installer | `curl -fsSL "${ZSH_<MODULE>_INSTALL_URL}" \| sh` | Same installer |
| Success | `core::exists <tool>` passes after installer | Same |

Unlike install, `update` must **never** short-circuit on "already installed" — the whole point is to fetch the latest version even when the tool is present.

---

## Step 3: Public Layer

Add a thin public wrapper in `pkg/base.zsh` next to the module's existing public functions, following the `install` pattern.

### Reference (herdr)

```zsh
function herdr::install {
  herdr::internal::install
}

function herdr::update {
    herdr::internal::update
}
```

The wrapper stays thin: delegate to the internal function, keep the public API stable.

---

## Step 4: Registration

Source the new internal file from `internal/main.zsh`, next to its lifecycle twin, and update the ordering comment:

```zsh
# Sourcing order respects dependencies:
#   base (utilities) → install → update → workspace → worktree → pane
source "${ZSH_HERDR_PATH}/internal/base.zsh"
source "${ZSH_HERDR_PATH}/internal/install.zsh"
source "${ZSH_HERDR_PATH}/internal/update.zsh"
```

Without this registration the function won't exist at runtime.

---

## Exit-Code Semantics

`update` MUST return exit code `0` **only** when the tool is available in PATH after running the installer. It MUST return `1` when:

1. The installer command itself fails.
2. The installer completes without error, but the binary is not found in PATH afterward (e.g. PATH not refreshed or binary placed elsewhere).

This mirrors the proven install semantics, so callers can branch on the result:

```zsh
if herdr::update; then
  # tool is at the latest version
else
  # update failed or tool unavailable — surface to the user
fi
```

---

## Checklist

### Files Created / Modified

- [ ] `internal/update.zsh` — `internal::update` running the official installer
- [ ] `internal/main.zsh` — sources the new file (registration)
- [ ] `pkg/base.zsh` — public `update` wrapper delegating to internal

### Code Quality

- [ ] Reuses `ZSH_<MODULE>_INSTALL_URL` and `ZSH_<MODULE>_PACKAGE_NAME` from config
- [ ] Function name `internal::update` with double-colon prefix
- [ ] `core::ensure curl` before using curl
- [ ] `core::exists <tool>` validates availability before returning success
- [ ] `message_info` / `message_success` / `message_error` for user feedback
- [ ] Returns `0` only on verified availability; `1` on installer failure or missing binary
- [ ] Does NOT early-return when already installed (always re-runs installer)

### Never Do This (Anti-patterns)

- [ ] ❌ Don't early-return when the tool is already installed — that makes `update` a no-op
- [ ] ❌ Don't hardcode the installer URL — use the config variable
- [ ] ❌ Don't report success without `core::exists` validation
- [ ] ❌ Don't mix update logic into `install.zsh` — use a dedicated `internal/update.zsh`
- [ ] ❌ Don't use `echo` for output — always use `message_*` helpers

---

## References

- **herdr implementation** (reference example): `zsh/modules/herdr/internal/update.zsh`, `zsh/modules/herdr/pkg/base.zsh`, `zsh/modules/herdr/config/base.zsh`
- **Install pattern**: `zsh/modules/herdr/internal/install.zsh` (the semantics `update` mirrors)
- **Existing guide**: `docs/guides/implement-tool-in-module.md` (three-layer architecture for adding a tool)
- **Existing guide**: `docs/guides/create-module.md` (for creating new modules)
- **Core utilities**: `zsh/system/core/` (message_*, core::exists, core::ensure)
