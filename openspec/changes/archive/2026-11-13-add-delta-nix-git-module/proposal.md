# Proposal

## Why

`delta` (git-delta) ownership is currently claimed by the rust module, but its config function (`rust::internal::delta::load`) is dead code that is never invoked, and the `git-delta` cargo entry is an unused duplicate. Meanwhile the git module — the rightful owner of git pager configuration — has no delta install or config path. This leaves delta installation inconsistent and ownership ambiguous. Migrate ownership to the git module as a nix dependency (`nixpkgs#delta`), removing the duplicated/dead delta property from the rust module.

## What Changes

- `zsh/modules/git/config/base.zsh`: declare `GIT_DELTA_NIX_PACKAGE="nixpkgs#delta"` (following the devops direnv nix pattern).
- New `zsh/modules/git/internal/delta.zsh`: `git::internal::delta::install` (nix install when missing) and `git::internal::delta::load` applying `core.pager = delta`, `interactive.diffFilter = delta --color-only`, `delta.navigate = true`, `merge.conflictStyle = zdiff3` (migrated from the dead rust function).
- `zsh/modules/git/internal/main.zsh`: source the new file and invoke install/load alongside existing `core::ensure` calls.
- `zsh/modules/git/data/sync/.gitconfig:13`: change `pager = hunk pager` to `pager = delta`, keeping `hunk pager` as a commented alternative.
- `zsh/modules/git/README.yaml`: add delta to `requirements`.
- `zsh/modules/rust/config/base.zsh`: remove `git-delta` from `RUST_CARGO_PACKAGES_SIMPLE`.
- `zsh/modules/rust/internal/packages.zsh`: delete the dead `rust::internal::delta::load`.
- `zsh/modules/rust/plugin.zsh`: clean up the orphan comment referencing delta.

## Capabilities

### New Capabilities
- `git-module`: The git module owns installation and configuration of `delta` as a nix dependency, including the four git config values and the synced `.gitconfig` pager setting.

### Modified Capabilities
<!-- none: rust-module spec sync is a documented follow-up (see Impact). -->

## Impact

- Affected code: `zsh/modules/git/` (config, internal, data/sync, README) and `zsh/modules/rust/` (config, internal, plugin).
- New runtime dependency path: `nixpkgs#delta` via `nix profile install`.
- Non-blocking follow-up: `openspec/specs/rust-module/spec.md` (requirement "Delta git pager configuration", lines ~42-47) becomes stale after this change and must be synchronized via OpenSpec afterwards (remove that requirement). Not performed in this change.
