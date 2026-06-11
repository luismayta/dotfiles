## Context

Six modules in `zsh/modules/` perform `rsync`-based file synchronization but store their source files in non-standard directories (`conf/`, `assets/fonts/`, `sync/`, `template/`). The `ai` module established a convention: source files for sync operations live under `data/` (e.g., `data/opencode/`, `data/patterns/`). Two other modules (`tmux`, `hyprland`) already follow this convention. This change aligns the remaining six modules to the `data/` convention.

Current state of each target module:
- **ghostty**: `conf/` synced to `~/.config/ghostty/`
- **resources**: `assets/fonts/` synced to system fonts dir
- **starship**: `conf/` referenced in sync but directory does not exist yet
- **ssh**: `conf/` synced to `~/.ssh/`
- **git**: `sync/` + `template/git/hooks/` (hooks dir missing) synced to `$HOME/` and provision dir
- **devops**: `conf/k9s/` synced to k9s config dir

## Goals / Non-Goals

**Goals:**
- Rename all ad-hoc sync source directories to `data/` following the AI module convention
- Add `*_DATA_PATH` config variables referencing the new `data/` paths
- Update all internal references (config, internal, pkg files) to use the new path
- Add `core::exists rsync` guard to `plugin.zsh` where missing
- Ensure backward compatibility — no behavior changes, only structural

**Non-Goals:**
- No functional changes to sync behavior or rsync flags
- No changes to destination paths (what gets synced where)
- No changes to modules that only install rsync but don't sync data (bitwarden, nvim, issues, templates)
- No changes to the AI, tmux, or hyprland modules (already conform to `data/` convention)
- No changes to the `templates/templates/` directory (read directly, not synced)

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Directory naming | `data/` | Matches existing convention from `ai`, `tmux`, `hyprland` modules. Self-documenting intent. |
| Config variable naming | `<MODULE>_DATA_PATH` | Follows `AI_PATH`, `TMUX_PATH` pattern. Clear separation from other path vars. |
| Resource fonts | `data/fonts/` instead of flat `data/` | Avoids polluting `data/` root with hundreds of font files. Matches `data/k9s/` pattern. |
| Git hooks | Keep under `git/data/hooks/` | Unifies both sync sources under `data/`. Hooks directory needs to be created if missing. |
| starship | Create `data/starship.toml` if missing | The sync function already references a `conf/` dir; we provision an actual config to make the sync meaningful. |
| `rsync` guard | Add to `plugin.zsh` for each module | Ensures rsync is available before sync operations. Already present in `ai`, `tmux`, `hyprland`. |

## Risks / Trade-offs

- **git hooks dir missing**: The hooks template directory referenced by config does not exist yet. Creating `data/hooks/` requires determining what hooks are needed. → Start with an empty `data/hooks/.gitkeep` and populate as needed.
- **starship conf missing**: The starship sync references a non-existent `conf/` directory. → Create `data/starship.toml` with a minimal default prompt config so the sync has something to copy.
- **Resource font count**: 100+ font files in `assets/fonts/`. A `mv` is straightforward but generates a large git diff. → Use `git mv` to preserve history.
- **Backward compat**: No external consumers rely on these directory paths directly (they're referenced through module-internal config variables). Low risk.