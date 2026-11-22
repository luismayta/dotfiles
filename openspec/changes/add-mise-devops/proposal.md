# Proposal

## Why

The devops module has no tool version manager, so runtime versions (node, python, go, etc.) are managed ad hoc outside the dotfiles. `mise` (https://mise.jdx.dev/) provides a single asdf-compatible manager with per-project config and native zsh activation, and the module already ships a documented three-layer tool pattern that makes adding it low-risk.

## What Changes

- New three-layer tool integration: `zsh/modules/devops/config/mise.zsh`, `internal/mise.zsh`, `pkg/mise.zsh`, following the **Shell hooks** pattern (atuin-style `eval "$(mise activate zsh ...)"` in `internal/`).
- Installation prefers nix (`DEVOPS_MISE_NIX_PACKAGE="nixpkgs#mise"`) with fallback to `core::install`, per Step 2a of `docs/guides/implement-tool-in-module.md`.
- Register `mise` in the `DEVOPS_TOOLS` array in `zsh/modules/devops/config/base.zsh`.
- Wire one `source` line in each aggregator: `config/main.zsh`, `internal/main.zsh`, `pkg/main.zsh`.
- Public lifecycle wrappers `devops::mise::install`, `devops::mise::upgrade`, `devops::mise::post_install` with first-steps guidance (`mise use node@latest`).

No breaking changes: existing tools and load order are unaffected.

## Capabilities

### New Capabilities

- `devops-mise`: mise as a devops module tool — configuration variables, nix-first install with native fallback, zsh activation hook, public lifecycle API, and module registration.

### Modified Capabilities

- `devops`: adds registration coverage for `mise` in the `DEVOPS_TOOLS` array.

## Impact

- New files: `zsh/modules/devops/{config,internal,pkg}/mise.zsh`
- Modified files: `zsh/modules/devops/config/base.zsh`, `config/main.zsh`, `internal/main.zsh`, `pkg/main.zsh`
- Specs: `openspec/changes/add-mise-devops/specs/devops-mise/spec.md` (new), delta on `devops`
- Dependencies: nix preferred (`nixpkgs#mise`), native package manager as fallback; no new third-party runtime dependency beyond `mise` itself
- Runtime behavior: the factory may auto-install `mise` at shell startup when it is missing
