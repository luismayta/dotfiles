## Context

During HAD-62, all per-module `MESSAGE_BREW` and similar tool-install message variables were centralized into `CORE_MESSAGE_*` in `zsh/core/config/env.zsh`. Individual module configs were cleaned up, but a secondary audit found 14 variables that remained as dead code — either missed during cleanup or never consumed after creation.

The dead variables fall into 4 groups:
1. **Core orphans** (4): `CORE_MESSAGE_YAY`, `CORE_MESSAGE_RVM`, `CORE_MESSAGE_NVM`, `CORE_MESSAGE_PYENV` — created as centralized replacements but no module ever used them
2. **Devops sub-tool brew vars** (4): `DEVOPS_K9S_MESSAGE_BREW`, `DEVOPS_KUBECTL_MESSAGE_BREW`, `DEVOPS_HELM_MESSAGE_BREW`, `DEVOPS_TFENV_MESSAGE_BREW` — missed during HAD-62 cleanup
3. **Devops sub-tool not_found vars** (3): `DEVOPS_K9S_MESSAGE_NOT_FOUND`, `DEVOPS_KUBECTL_MESSAGE_NOT_FOUND`, `DEVOPS_HELM_MESSAGE_NOT_FOUND` — created with tool files but never referenced (internal code uses inline strings)
4. **Module orphans** (3): `ZSH_ALIASES_MESSAGE_NOT_FOUND`, `FNM_MESSAGE_NOT_FOUND`, `FNM_MESSAGE_CORE` — never referenced by their own modules

## Goals / Non-Goals

**Goals:**
- Remove all 14 dead `*_MESSAGE_*` variable definitions
- Reduce confusion for future developers reading config files

**Non-Goals:**
- No changes to message logic or behavior
- No changes to inline message strings in internal/pkg files
- No spec changes — behavior is unchanged

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Removal vs replacement | **Remove entirely** | All 14 are dead code (zero references). The active variables (`CORE_MESSAGE_BREW`, `CORE_MESSAGE_RUST`, `CORE_MESSAGE_CARGO`, `CLEAN_MESSAGE_NOT_IMPLEMENTED`, `DEVOPS_KUBECTL_MESSAGE_GO_NOT_FOUND`) already cover all use cases. |
| Keep `CORE_MESSAGE_YAY/RVM/NVM/PYENV` for future? | **No — YAGNI** | These were created speculatively. If a module ever needs a custom message, it can be added then. Keeping dead code creates maintenance burden without benefit. |
| Keep `DEVOPS_*_MESSAGE_NOT_FOUND`? | **No** | The internal tool files use inline strings like `"this not found installed"` or `core::exists` directly — they never reference these variables. |

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| A future module could need `CORE_MESSAGE_YAY` | Can be re-added when a module actually uses it. The pattern is well-documented. |
| Accidental removal of referenced variable | Verified with `git grep` — zero references for all 14. Pre-commit hooks will catch any issues. |
