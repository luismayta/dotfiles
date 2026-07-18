## Why

`internal/base.zsh` in the `ai` module is a 637-line monolith containing 37 functions across 10+ unrelated domains (opencode, fabric, ollama, skills, openspec, graphify, hunk, pi, etc.). This violates the module guide's principle of domain separation and makes the file difficult to navigate, maintain, and extend. The `herdr` module already demonstrates the correct pattern: domain-specific files (`workspace.zsh`, `worktree.zsh`, `pane.zsh`, `install.zsh`) sourced from `main.zsh`. The `ai` module should follow the same convention for consistency across the codebase.

## What Changes

- Split `internal/base.zsh` (637 lines, 37 functions) into domain-specific files under `internal/`:
  - `internal/opencode.zsh` — opencode install, sync, load (4 functions)
  - `internal/fabric.zsh` — fabric install + pattern sync/pull (moved from `internal/helper.zsh`)
  - `internal/ollama.zsh` — ollama models list/pull/install (moved from `internal/helper.zsh`)
  - `internal/skills.zsh` — skills CLI install, add, use, list, update, search, publish, setup (11 functions)
  - `internal/openspec.zsh` — openspec install, upgrade, register, init, update, setup (7 functions)
  - `internal/graphify.zsh` — graphify install, upgrade, register skill, setup (4 functions)
  - `internal/tools.zsh` — batch install + simple tool installs (shimmy, hf, openclaw, codegraph, tmuxai, rtk, hunk, pi) + PATH loaders (12 functions)
  - Remove `internal/helper.zsh` (its content moves to `fabric.zsh` and `ollama.zsh`)
- Split `pkg/helper.zsh` (178 lines, 35 functions) into domain-specific files under `pkg/`:
  - `pkg/opencode.zsh` — opencode public wrappers + `editopencode`
  - `pkg/fabric.zsh` — fabric public wrappers
  - `pkg/ollama.zsh` — ollama public wrappers
  - `pkg/skills.zsh` — skills public wrappers
  - `pkg/openspec.zsh` — openspec public wrappers
  - `pkg/graphify.zsh` — graphify public wrappers
  - `pkg/hunk.zsh` — hunk public wrappers + review/show/daemon
  - `pkg/tools.zsh` — remaining tool wrappers (shimmy, hf, openclaw, codegraph, tmuxai, rtk, pi) + `ai::sync`
- Update `internal/main.zsh` to source all new domain files in dependency order
- Update `pkg/main.zsh` to source all new domain files
- No changes to `config/`, `plugin.zsh`, or `data/`

## Capabilities

### New Capabilities

- `ai-domain-split`: Refactor the ai module's internal and pkg layers into domain-separated files following the herdr pattern

### Modified Capabilities

<!-- None — no existing specs change -->

## Impact

- **Files modified**: `internal/base.zsh`, `internal/main.zsh`, `internal/helper.zsh` (deleted), `pkg/helper.zsh`, `pkg/main.zsh`
- **Files created**: 14 new domain-specific `.zsh` files across `internal/` and `pkg/`
- **No breaking changes**: All public function names and signatures remain identical. This is a pure structural refactor — no behavior changes.
- **No config or data changes**: `config/`, `data/`, and `plugin.zsh` are untouched.
