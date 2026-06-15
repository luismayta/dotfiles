## Why

`apps::internal::packages::install()` currently calls `core::install` unconditionally for every package in `APPS_PACKAGES`. This means it attempts to install packages even when they already exist, producing unnecessary noise and redundant work. The `core::ensure` helper already exists in `zsh/core/pkg/base.zsh` — it checks `core::exists` first and only installs if missing.

## What Changes

- Replace `core::install` with `core::ensure` inside `apps::internal::packages::install()` in `zsh/modules/apps/internal/base.zsh`
- No changes to the public API — `apps::internal::packages::install` keeps the same signature and behavior, just skips already-present packages

## Capabilities

### New Capabilities

None — this is an internal quality improvement with no new user-facing capability.

### Modified Capabilities

None — behavior at the spec level is unchanged. The function still "installs required packages"; it now skips already-installed ones as an implementation detail.

## Impact

- Only one file modified: `zsh/modules/apps/internal/base.zsh`
- Single-line change: `core::install` -> `core::ensure`
- Reduces console noise for repeated runs
- Consistent with patterns already used across the codebase (e.g., `core::ensure curl` in `apps/internal/main.zsh`)
