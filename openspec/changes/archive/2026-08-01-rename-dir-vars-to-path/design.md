## Context

The repo established the `_PATH` suffix as its naming standard for shell env vars holding filesystem paths (archived change `2026-06-13-rename-zsh-dir-vars-to-path`, spec `rename-convention`). That pass renamed only core/TMUX/devops config vars (`DOTFILES_CORE_DIR`→`DOTFILES_CORE_PATH`, `TMUX_CONFIG_DIR`→`TMUX_CONFIG_PATH`, `DEVOPS_K9S_CONF_DIR`→`DEVOPS_K9S_CONF_PATH`, etc.). An inventory (KenThompson, 2026-08-01) found **16 repo-defined `_DIR` variables** still remaining across four surfaces: core bootstrap (`zsh/zshrc`), module config layers, `provision/script/`, and script-local bash vars — plus one stale live spec (`devops-k9s` still says `DEVOPS_K9S_CONF_DIR`).

## Goals / Non-Goals

**Goals:**
- Complete the `_DIR` → `_PATH` migration across the whole repo, leaving zero repo-owned `_DIR` env vars.
- Formalize the convention as a **live spec** (`path-naming-convention`) instead of an archived change.
- Achieve intra-module consistency (e.g. notify: `ZSH_NOTIFY_CONFIG_PATH` and `ZSH_NOTIFY_NOTI_CONFIG_PATH`).
- Sync the 5 live specs that reference renamed variables, plus the 2 docs guides.

**Non-Goals:**
- Rename `APPS_WEB_APPS_BUILD_DIR` (scratch/build directory — semantically a dir, not a config path).
- Rename third-party-owned vars: `SDKMAN_DIR`, `XDG_RUNTIME_DIR`, `XDG_CONFIG_HOME` (renaming would break the owning tools).
- Touch false positives: Lua params (`root_dir`), JSON field names (`working_dir`).
- Restructure `provision/script/` beyond variable names.

## Decisions

### D1: Core bootstrap vars ARE included (`DOTFILES_DIR` → `DOTFILES_PATH`, `DOTFILES_ZSH_DIR` → `DOTFILES_ZSH_PATH`, `DOTFILES_SYSTEM_DIR` → `DOTFILES_SYSTEM_PATH`)
The previous rename deliberately skipped them; that leaves the inconsistency on the most visible surface (`zsh/zshrc`, `paths.zsh`, 10 `bin/` scripts). Per the user's directive ("todo lo de DIR"), include them.
- **Alternative (rejected)**: keep `DOTFILES_DIR` as a "root" convention — rejected because the repo's own spec (`rename-convention`) says *all* path-holding vars end in `_PATH`, and a root dir is a filesystem path.
- **Mitigation**: leaf-first rename order (D7), `${DOTFILES_DIR:-${HOME}/.dotfiles}` fallbacks preserved in all 10 `bin/` scripts, and `~/.zshrc` updated in the same change (precedent: `2026-06-10-refactor-mod-shared-layer`).

### D2: Dead exports are deleted, not renamed
`EXTRAS_DIR` (0 usages) and `FONTS_DIR` (1 usage, superseded by `RESOURCES_FONTS_PATH`) get removed from `provision/script/`. Renaming dead code adds churn without value.

### D3: Module config dirs map to the existing `_CONFIG_PATH` / `_CONF_PATH` convention
| Old | New |
|---|---|
| `ZSH_NOTIFY_NOTI_CONFIG_DIR` | `ZSH_NOTIFY_NOTI_CONFIG_PATH` |
| `ZSH_YAZI_CONFIG_DIR` | `ZSH_YAZI_CONFIG_PATH` |
| `ZSH_HERDR_CONFIG_DIR` | `ZSH_HERDR_CONFIG_PATH` |
| `NIX_DIRENV_CONFIG_DIR` | `NIX_DIRENV_CONFIG_PATH` |
| `NIX_CONF_DIR` | `NIX_CONF_PATH` |
| `DEVOPS_ATUIN_CONFIG_DIR` | `DEVOPS_ATUIN_CONFIG_PATH` |

All match peers already using `_CONFIG_PATH`/`_CONF_PATH` (e.g. `ZSH_NOTIFY_CONFIG_PATH`, `DEVOPS_K9S_CONF_PATH`).

### D4: Provision vars renamed to `_PATH`
`SCRIPT_DIR`→`SCRIPT_PATH`, `ZSH_DIR`→`ZSH_PATH`, `TOOLS_DIR`→`TOOLS_PATH`, `ROOT_DIR`→`ROOT_PATH` in `provision/script/bootstrap.sh`, `functions.sh`, `run.sh`, `test.sh`.

### D5: Script-local bash vars included
`TESTS_DIR`→`TESTS_PATH` (`git/tests/run.sh`), `ANTIDOTE_DIR`→`ANTIDOTE_PATH` (`tools/antidote/install.sh`), local `SCRIPT_DIR`→`SCRIPT_PATH` (waybar scripts + git tests local). "Todo lo de DIR" includes locals; they are low-risk (file-scoped).

### D6: Exclusions are explicit and documented in the new spec
`APPS_WEB_APPS_BUILD_DIR` + external vars are the canonical exceptions the `path-naming-convention` spec will reference.

### D7: Rename order — leaf first, core last
Follows the archived change's own guidance: module/provision leaf vars first, core bootstrap last (referenced across many files).

### D8: Live specs and docs sync in the same change
`zshrc-load`, `shared-paths`, `core-api`, `devops-atuin` deltas + `devops-k9s` stale fix; `docs/guides/create-module.md` (herdr row), `docs/guides/implement-tool-in-module.md` (atuin row).

## Risks / Trade-offs

- **[High] Core bootstrap rename breaks 10 `bin/` scripts + user `~/.zshrc`** → Mitigation: sed across repo + manual `~/.zshrc` update in same change; preserve `${DOTFILES_DIR:-...}` fallback; leaf-first order; verify with real shell load before commit.
- **[Medium] Silent regression if a consumer still references old name** → Mitigation: after rename, grep repo for `_DIR` (must match only exclusions) + `zsh -n` syntax check + `source zsh/zshrc` smoke test.
- **[Low] External var exclusion misunderstood** → Mitigation: `SDKMAN_DIR`, `XDG_*` explicitly listed as exceptions in the spec and tasks.
- **[Low] Spec drift during a large rename** → Mitigation: delta specs updated in the same change; validate with `openspec validate`.
- **Rollback**: single revert of the rename commit + restore `~/.zshrc` from backup (one-line swap back).
