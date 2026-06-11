## Context

Six standalone zsh modules currently live in external repos under `hadenlabs/zsh-{name}`. Each follows a consistent but independent structure: `zsh-{name}.zsh` entry point → `config/main.zsh` (env vars) → `internal/main.zsh` (implementation) → `pkg/main.zsh` (public API). Two modules have extra layers: ghostty adds `core/` (redundant init) and issues adds `provider/` + `workflow/` (GitHub/GitLab provider abstraction and git flow detection).

The dotfiles repo already has two in-tree modules under `zsh/modules/`: `rust/` and `docker/`, which use a refined pattern: `plugin.zsh` → `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`.

All 6 external repos carry identical boilerplate (`.editorconfig`, `.gitignore`, `LICENSE`, `Taskfile.yml`, CI config, docs infrastructure) that is irrelevant when colocated in the dotfiles repo.

## Goals / Non-Goals

**Goals:**
- Migrate all 6 modules into `zsh/modules/<name>/` preserving all public functions, keybindings, and data directories
- Normalize each module to match the `zsh/modules/rust/` convention: `plugin.zsh` with `__ZSH_<NAME>_LOADED` guard, config/ → internal/ → pkg/ sourcing chain
- Rename namespace from `ZSH_<NAME>_PATH` to `<UPPER_NAME>_PATH` for consistency with rust/docker modules
- Fix shebangs from `#!/usr/bin/env ksh` to `# shellcheck shell=bash` (matching rust module style)
- Remove external boilerplate (CI config, docs, license, etc.) that is unnecessary in-tree

**Non-Goals:**
- No functional changes to module behavior (pure migration)
- No changes to existing rust or docker modules
- No changes to the zshrc loading mechanism beyond path updates
- No removal or deprecation of external repos (handled separately)

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **ghostty core/ layer** | Fold into config/ | core/ in ghostty is a duplicate of config/ with near-empty files; no benefit to keep as separate layer |
| **issues provider/ + workflow/ layers** | Keep under zsh/modules/issues/provider/ and zsh/modules/issues/workflow/ | These are genuine abstractions (GitHub vs GitLab, githubflow vs gitflow) — flattening them would break modularity. They stay as subdirectories under the module. |
| **Data directories** | Copy alongside module code | `conf/` (ghostty, ssh), `templates/` (templates), `resources/` (issues), `assets/` (resources) are runtime data, not code — but they ship with the module |
| **Entry point name** | `plugin.zsh` | Matches rust/docker convention. The external `zsh-{name}.zsh` becomes `plugin.zsh` |
| **Idempotency** | `__ZSH_<NAME>_LOADED` guard | Matches rust module: `[[ -n "${__ZSH_RUST_LOADED:-}" ]] && return` |
| **Module root var** | `<UPPER_NAME>_PATH` | e.g., `GHOSTTY_PATH="$(dirname "${0}")"`. Consistent with `RUST_PATH`, `DOCKER_PATH` |
| **Shebangs** | Remove `#!/usr/bin/env ksh`, use `# shellcheck shell=bash` | The ksh shebang is incorrect (these are zsh scripts). Rust module doesn't use shebangs on sourced files |
| **Auto-install** | Keep at bottom of `pkg/main.zsh` | Matches rust module pattern of auto-calling init functions after sourcing |
| **OS dispatch** | `case "${OSTYPE}" in darwin*|linux*)` | Consistent across all modules; unchanged from external repos |

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| [Minor] Namespace rename (`ZSH_*_PATH` → `*_PATH`) could break external scripts or workflows that reference old vars | No known external consumers; internal zshrc references are updated as part of migration |
| [Low] Ghostty core/ layer removal could lose something if core/ is later extended | core/ is empty (base.zsh, linux.zsh, osx.zsh all empty); nothing to lose |
| [Low] Template/resources paths change from repo-relative to module-relative | Templates uses `TEMPLATES_TEMPLATES_PATH="${TEMPLATES_PATH}/templates"` — will be updated to `${<NAME>_PATH}/templates` |
| [Low] Keybind conflicts if two modules bind same ^X combos | No conflicts: ssh uses `^Xs`, templates uses `^Xt`, bitwarden uses `^Xk` — all distinct |