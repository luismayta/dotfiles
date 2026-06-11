## Why

Six modules currently sync configuration files to user home directories using `rsync`, but their source files live in ad-hoc directories (`conf/`, `assets/fonts/`, `sync/`, `template/`) instead of a standardized `data/` directory. The `ai` module established the convention of using `data/` for sync sources (`data/opencode/`, `data/patterns/`), and `tmux` (`data/conf/`, `data/sync/`) and `hyprland` (`data/hypr/`) already follow this pattern. Standardizing all modules to use `data/` improves discoverability, reduces cognitive overhead, and makes the sync architecture self-documenting.

## What Changes

- Rename `zsh/modules/ghostty/conf/` → `ghostty/data/` and update all internal references
- Rename `zsh/modules/resources/assets/fonts/` → `resources/data/fonts/` and update all internal references
- Rename `zsh/modules/ssh/conf/` → `ssh/data/` and update all internal references
- Rename `zsh/modules/git/sync/` → `git/data/sync/`, move `git/template/git/hooks/` → `git/data/hooks/`, and update all internal references
- Rename `zsh/modules/devops/conf/k9s/` → `devops/data/k9s/` and update all internal references
- Create `zsh/modules/starship/data/starship.toml` if missing — mirror the `conf/` directory that the sync function references but does not yet exist
- Add config variables (`*_DATA_PATH`) pointing to the new `data/` directories, matching the `AI_PATH/data/...` and `TMUX_PATH/data/...` convention
- Add `core::exists rsync` guard to `plugin.zsh` for affected modules where missing

**No breaking changes** — all existing config variables retain their semantics; only the directory structure moves.

## Capabilities

### New Capabilities

- `ghostty-data`: Standardize Ghostty config sync source under `data/`
- `resources-data`: Standardize resources font sync source under `data/fonts/`
- `starship-data`: Ensure starship sync has an existing `data/` source directory
- `ssh-data`: Standardize SSH config sync source under `data/`
- `git-data`: Unify Git hooks and config sync sources under `data/`
- `devops-data`: Standardize devops k9s config sync source under `data/k9s/`

### Modified Capabilities

<!-- No existing specs are changing — this is pure structural standardization -->

## Impact

- **6 modules** with directory renames: ghostty, resources, starship, ssh, git, devops
- **Config files**: `*_DATA_PATH` variables added to `config/base.zsh` for each module
- **Internal files**: Path references updated in `internal/base.zsh` and `pkg/base.zsh` (rsync source paths)
- **No breaking changes**: All existing public APIs and config variables remain unchanged
- Convention becomes: `data/` = `rsync` source for file synchronization