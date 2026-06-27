## Why

The `scmbreeze` module wraps the external SCM Breeze tool (`scm_breeze.sh`), which provides numbered git file shortcuts and additional git aliases. The git module already provides equivalent functionality via `scmpuff` (numbered file shortcuts) and its own `pkg/alias.zsh` (git aliases). Maintaining both creates duplication, unnecessary external dependency, and extra startup time. Removing the scmbreeze module simplifies the dotfiles without losing any git productivity features.

## What Changes

- Migrate any missing git aliases from SCM Breeze's alias set into the git module's `pkg/alias.zsh`
- scmpuff stays — it already covers the numbered file shortcut use case (`gs`, `ga`, `gd`, `gA`)
- Remove the entire `zsh/modules/scmbreeze/` directory and all its files
- Standard git aliases like `gst`, `gfa`, `gm`, `grm`, `gcp`, `gbl` will be added to align with common SCM Breeze conventions

## Capabilities

### New Capabilities
- `scm-breeze-alias-migration`: Port missing git aliases from SCM Breeze convention into the git module's alias file without conflicting with scmpuff

### Modified Capabilities
- (none — no existing specs in `openspec/specs/`)

## Impact

- **Remove**: `zsh/modules/scmbreeze/` (12 files across config, internal, pkg directories)
- **Modify**: `zsh/modules/git/pkg/alias.zsh` — add missing aliases from SCM Breeze conventions
- The scmbreeze module is auto-loaded by `zsh/zshrc` via the modules directory loop; removing the directory eliminates the load automatically
- No changes needed to `zshrc` itself — module discovery is automatic
- If `~/.scm_breeze/` directory exists, it becomes orphaned and can be cleaned up manually
