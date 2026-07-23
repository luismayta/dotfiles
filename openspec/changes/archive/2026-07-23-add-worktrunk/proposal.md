## Why

Worktrunk is a CLI tool for managing Git worktrees, designed for parallel AI agent workflows. It enables developers to work on multiple features simultaneously by creating isolated Git worktrees, reducing context switching and improving productivity.

Adding worktrunk to the devops module provides automated lifecycle management (install, upgrade, configuration) following the established three-layer architecture pattern, ensuring consistency with other tools in the module.

## What Changes

- Add `worktrunk` to the devops module with full lifecycle management
- Register `worktrunk` in the `DEVOPS_TOOLS` array for automated tool management
- Implement PATH-only pattern (no shell hooks required) following the bruno reference

## Capabilities

### New Capabilities

- `devops-worktrunk`: Git worktree management CLI integration with automated installation and lifecycle management

### Modified Capabilities

- `devops`: Add `worktrunk` to `DEVOPS_TOOLS` array for automated tool management

## Impact

- **Affected files**:
  - `zsh/modules/devops/config/worktrunk.zsh` (new)
  - `zsh/modules/devops/internal/worktrunk.zsh` (new)
  - `zsh/modules/devops/pkg/worktrunk.zsh` (new)
  - `zsh/modules/devops/config/base.zsh` (modified - add to `DEVOPS_TOOLS`)

- **Dependencies**: `worktrunk` CLI (installed via Homebrew or Cargo)
- **Installation methods**:
  - Homebrew: `brew install worktrunk`
  - Cargo: `cargo install worktrunk`
  - After install: `wt config shell install` for shell integration
