## Why

A dead-code audit of all `*_MESSAGE_*` variables across the codebase revealed 14 variables that are defined but never referenced. Most were created as part of the core message centralization (HAD-62) or during module restructuring but were never consumed by any internal/pkg code. Removing dead code reduces maintenance burden and eliminates confusion for future developers.

## What Changes

**zsh/core/config/env.zsh** — Remove 4 dead `CORE_MESSAGE_*` variables (the centralized replacements exist but no module consumes them):
- `CORE_MESSAGE_YAY` (line 7) — no module uses it
- `CORE_MESSAGE_RVM` (line 8) — no module uses it
- `CORE_MESSAGE_NVM` (line 10) — no module uses it
- `CORE_MESSAGE_PYENV` (line 12) — no module uses it

**zsh/modules/devops/config/base.zsh** — Remove 7 dead `DEVOPS_*_MESSAGE_*` variables:
- `DEVOPS_K9S_MESSAGE_BREW` (line 24) — never referenced
- `DEVOPS_K9S_MESSAGE_NOT_FOUND` (line 25) — never referenced
- `DEVOPS_KUBECTL_MESSAGE_BREW` (line 31) — never referenced
- `DEVOPS_KUBECTL_MESSAGE_NOT_FOUND` (line 32) — never referenced
- `DEVOPS_HELM_MESSAGE_BREW` (line 85) — never referenced
- `DEVOPS_HELM_MESSAGE_NOT_FOUND` (line 86) — never referenced
- `DEVOPS_TFENV_MESSAGE_BREW` (line 92) — never referenced

**zsh/modules/aliases/config/base.zsh** — Remove 1 dead variable:
- `ZSH_ALIASES_MESSAGE_NOT_FOUND` (line 5) — never referenced

**zsh/modules/fnm/config/base.zsh** — Remove 2 dead variables:
- `FNM_MESSAGE_NOT_FOUND` (line 3) — never referenced
- `FNM_MESSAGE_CORE` (line 6) — never referenced

Variables that stay (still in use):
- `CORE_MESSAGE_BREW`, `CORE_MESSAGE_RUST`, `CORE_MESSAGE_CARGO` — actively referenced
- `CLEAN_MESSAGE_NOT_IMPLEMENTED` — used by clean/pkg/linux.zsh
- `DEVOPS_KUBECTL_MESSAGE_GO_NOT_FOUND` — used by devops/internal/kubectl.zsh

## Capabilities

### New Capabilities

*(None — this is cleanup, no new capabilities)*

### Modified Capabilities

*(None — no spec-level behavior changes, just dead code removal)*

## Impact

- **zsh/core/config/env.zsh**: 4 lines removed
- **zsh/modules/devops/config/base.zsh**: 7 lines removed
- **zsh/modules/aliases/config/base.zsh**: 1 line removed
- **zsh/modules/fnm/config/base.zsh**: 2 lines removed
- **No runtime behavior change**: All active consumers already use the surviving variables directly
- **No downstream impact**: No code references the removed variables