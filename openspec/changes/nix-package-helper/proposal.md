# Proposal

## Why

Pure-CLI tools are currently installed via ad-hoc nix calls that are duplicated across modules (git delta, nix direnv, notify), inconsistent, and impossible to upgrade at scale. Introduce a shared `core::nix::package` helper as the preferred (not forced) install mechanism, document the nix pattern in the tool-implementation guide, and migrate the ~101 existing `core::install` sites support nix as fallback while preserving the decision rule.

## What Changes

- **New capability**: `core-nix` — behavior for installing nix packages via a shared profile-based helper with existence guards, nix-darwin respect, idempotent binary detection, upgrade hook.
- **Modified capability**: `nix-direnv` — guard/detection through the helper instead of inline `nix profile list` checks.
- **New file**: `zsh/system/core/pkg/nix.zsh` — public API `core::nix::package::{exists,install,upgrade}` (extends existing `core::nix::{install,exists,ensure}`).
- **New file**: `zsh/system/core/internal/nix.zsh` — cross-OS implementation (adds `core::internal::nix::package::*`).
- **Modified file**: `zsh/modules/git/config/base.zsh` — add `GIT_DELTA_NIX_PACKAGE="nixpkgs#delta"`.
- **Modified file**: `zsh/modules/git/internal/delta.zsh` — replace inline nix install with `core::nix::package::install`.
- **Modified file**: `zsh/modules/nix/internal/linux.zsh` — replace `nix::direnv::internal::install` inline checks with `core::nix::package::install "${NIX_DIRENV_NIX_PACKAGE}"`.
- **Modified file**: `zsh/modules/nix/internal/osx.zsh` — same migration.
- **Modified file**: `zsh/modules/notify/internal/adapter/noti.zsh` — nix-or-core fallback uses `core::nix::package::install` when nix is present (replace inline `nix profile add`).
- **Modified file**: `zsh/modules/devops/internal/linux.zsh` — replace inline `nix profile install/add` in `devops::direnv::internal::install` with helper (keep cask `core::install` for direnv on Linux).
- **Modified file**: `zsh/modules/devops/internal/osx.zsh` — same migration.
- **Modified file**: `docs/guides/implement-tool-in-module.md` — new section "Step 2a: Choosing an Install Mechanism" before current Step 2 (decision table; nix pattern code block with config var + `core::nix::package::install` + factory guard; naming rules `*_NIX_PACKAGE` vs `*_PACKAGE_NAME`; guard rules incl. `ZSH_NIX_DARWIN_AVAILABLE`; "When NOT to use nix"; new anti-patterns: no hardcoded `nix profile install` in modules, no OS branching for the verb, no nix inside `core::install`), and update lines stating native pkg mgr as the only path (~lines 138 and 581 — verified at implementation time).

## Capabilities

### New Capabilities

- `core-nix`: System-level utility for installing and managing nix-based CLI tools via profile installs, with guards for binary existence, nix-darwin availability, and nix tooling support.

### Modified Capabilities

- `nix-direnv`: REQUIREMENT "Detección correcta del plugin" changes behavior: validation moves through `core::nix::package::exists` (alias for binary `direnv`), install goes through `core::nix::package::install`, no inline `nix profile list` checks.

## Impact

- Affected code: `zsh/system/core/pkg/nix.zsh`, `zsh/system/core/internal/nix.zsh`, `zsh/modules/git/config/base.zsh`, `zsh/modules/git/internal/delta.zsh`, `zsh/modules/nix/internal/linux.zsh`, `zsh/modules/nix/internal/osx.zsh`, `zsh/modules/notify/internal/adapter/noti.zsh`, `zsh/modules/devops/internal/linux.zsh`, `zsh/modules/devops/internal/osx.zsh`, `docs/guides/implement-tool-in-module.md`.
- New runtime dependency pattern: per-tool `*_NIX_PACKAGE` config var + `core::nix::package::install` wrapper.
- Non-breaking: nix installs replace ad-hoc inline calls, but fallback to `core::install` when nix unavailable (notify logic already has fallback; devops Linux keeps `core::install` for cask).
- Minimal implementation boundaries: helper stays in `core::nix::package::*` (not polluting `core::install`), nix command verb detected via feature probe (`nix profile --help`), separate "binary exists" from "package installed" guard.