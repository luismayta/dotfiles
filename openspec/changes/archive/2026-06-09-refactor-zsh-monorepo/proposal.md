## Why

The current `mod/config/` + `mod/internal/` structure works well, but there's no pattern for adding standalone ZSH modules (like `zsh-brew`, `zsh-rust`, `zsh-git`). Without a convention, modules get bolted on ad-hoc making them hard to discover, load, or remove.

## What Changes

- Create `zsh/modules/` directory as the home for all ZSH modules
- Each module lives in its own subdirectory with a `plugin.zsh` entry point
- Update `zshrc` to source `modules/` after `mod/` (modules extend, they don't replace core)
- Keep `mod/config/` and `mod/internal/` exactly as they are — zero churn
- No `pkg/` layer, no factory pattern, no OS dispatch refactor

## Capabilities

### New Capabilities

- `module-registry`: Simple directory-based loader — iterate `modules/*/plugin.zsh` and source them

### Modified Capabilities

*(none)*

## Impact

- **`zsh/`** — added `modules/` directory; `mod/` untouched
- **`zsh/zshrc`** — added one block to source `modules/*/plugin.zsh` after `mod/main.zsh`
- **Everything else** — unchanged

Minimal diff: create `modules/`, add a sourcing loop to `zshrc`. Modules become self-contained `module-name/plugin.zsh` directories that can be added or removed without touching any other file.