# Proposal: implement-module-update

## Why

Zsh modules under `zsh/modules/` have no `update` function to bring a tool to its latest version. For example, the herdr module cannot reinstall/update the tool through its official installer (`curl -fsSL https://herdr.dev/install.sh | sh`). A generic, repeatable `update` pattern closes the lifecycle gap between install and manual reinstall, applied first to herdr.

## What Changes

- Introduce a generic `update` function pattern applicable to any zsh module under `zsh/modules/`.
- Implement `herdr::update` in `zsh/modules/herdr/` that executes the official installer: `curl -fsSL https://herdr.dev/install.sh | sh`.
- `herdr::update` returns exit code `0` when herdr is available in PATH after the update, and `1` when installation fails or the binary is not in PATH.
- Document the generic `update` function pattern in `docs/guides/`.
- Expose `herdr::update` alongside existing public functions (`herdr::install`, `herdr::plugin::update::all`) in `zsh/modules/herdr/pkg/base.zsh`, backed by `herdr::internal::update` in the internal layer.

## Capabilities

### New Capabilities

- `module-update`: generic `update` function contract for zsh modules — how a module updates its tool to the latest version, including the success/failure exit-code semantics and the first implementation in the herdr module.

### Modified Capabilities

<!-- No existing spec-level behavior changes: herdr::update is a new addition, not a change to an existing requirement. -->

## Impact

- Code: `zsh/modules/herdr/pkg/base.zsh` (public `herdr::update`), `zsh/modules/herdr/internal/` (new `update.zsh` or addition to `install.zsh` following the `herdr::internal::install` pattern).
- Docs: `docs/guides/` — new guide documenting the generic module `update` pattern.
- Dependencies: `curl` (already ensured by the herdr module install flow via `core::ensure`).
- Traceability: RD-61 (epic RD-30).
