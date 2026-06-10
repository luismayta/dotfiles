## Context

The monorepo at `zsh/` is organized as `zsh/core/` (shared infrastructure: env vars, messaging functions, package install helpers) and `zsh/modules/` (feature modules: brew, git, goenv, pyenv, etc.). Each module independently defines `*_MESSAGE_*` variables for common tool installation instructions (brew, rvm, rust, etc.), leading to 10+ duplicate definitions with slightly varying text and stale external references.

Core already defines `CORE_MESSAGE_*` variables in `zsh/core/config/env.zsh` and provides `message_*` helper functions in `zsh/core/pkg/base.zsh` that all modules consume. The gap is that modules don't use these centralized messages — they define and reference their own.

## Goals / Non-Goals

**Goals:**
- Centralize all common tool installation messages into `zsh/core/config/env.zsh` as `CORE_MESSAGE_*` variables
- Update all module code to reference `$CORE_MESSAGE_*` instead of local `$MODULE_MESSAGE_*` 
- Remove redundant `*_MESSAGE_BREW`, `*_MESSAGE_RVM`, etc. from each module's `config/base.zsh`
- Update message text to reference internal monorepo module paths (e.g., `"zsh/modules/brew"`) instead of external antibody bundles (`hadenlabs/zsh-brew`)
- Preserve module-specific messages (e.g., `NOT_IMPLEMENTED`, `NOT_FOUND`) that have no shared equivalent

**Non-Goals:**
- Changing the `message_*` helper functions themselves (they work fine)
- Renaming existing module config variables unrelated to messages (e.g., `*_PACKAGE_NAME`, `*_ROOT`, `*_PATH`)
- Refactoring how modules load or source configs
- Creating new messaging infrastructure or formats

## Decisions

### Decision 1: Centralize in core config, not a separate file

**Choice**: Add new shared message variables to `zsh/core/config/env.zsh` rather than creating a new `zsh/core/config/messages.zsh`.

**Rationale**: The file already contains `CORE_MESSAGE_*` variables. Adding more keeps them co-located with the other env vars modules depend on. A separate file adds unnecessary sourcing overhead for no clear benefit.

### Decision 2: Extend existing `CORE_MESSAGE_*` naming convention

**Choice**: Continue the `CORE_MESSAGE_<TOOL>` pattern for new centralized vars (e.g., `CORE_MESSAGE_CARGO`, `CORE_MESSAGE_PYENV`).

**Rationale**: Consistent prefix indicates these come from core and are available to all modules. Modules already use `CORE_PROJECTS_BACKUP_PATH` from the same file, so the pattern is established.

### Decision 3: Module-specific messages stay in modules

**Choice**: Keep truly unique messages (e.g., `CLEAN_MESSAGE_NOT_IMPLEMENTED`, `FNM_MESSAGE_NOT_FOUND`) in their respective module configs.

**Rationale**: These are not shared patterns — they're specific to a single module's behavior. Centralizing them would add noise to core without benefit.

### Decision 4: Update message text to reference internal monorepo paths

**Choice**: Replace `"use antibody bundle hadenlabs/zsh-brew"` with `"use zsh/modules/brew"` or similar descriptive internal references.

**Rationale**: External antibody bundles no longer exist. The monorepo is self-contained. Users should be directed to enable the appropriate `zsh/modules/<name>` module rather than install an external plugin.

## Risks / Trade-offs

- **[Risk] Breaking change if modules aren't updated atomically** → Mitigation: Implement in a single pass — update core config AND all module references together. Do not deploy partially.
- **[Risk] Missed reference to a local `*_MESSAGE_*` var** → Mitigation: After implementation, grep for `MESSAGE_BREW`, `MESSAGE_RVM`, `MESSAGE_CARGO`, `MESSAGE_PYENV`, `MESSAGE_YAY` across modules to confirm zero remaining local definitions.
- **[Risk] Module-specific message accidentally removed** → Mitigation: Audited all `*_MESSAGE_*` variables in inventory. Only `NOT_IMPLEMENTED`, `NOT_FOUND`, `MESSAGE_CORE` are truly module-specific — these are preserved.
## Migration Plan

Not applicable — this is a single-repo, single-branch-change operation. All edits happen in one commit.

## Open Questions

- Should `CORE_MESSAGE_YAY` be kept? Yay (AUR helper) is Arch Linux-specific. Since we're standardizing, leaving it in core is fine — it's a shared tool message.
- `CORE_MESSAGE_NVM` — NVM is used by fnm module. Should fnm reference `CORE_MESSAGE_NVM` or have its own? Decision: fnm replaces nvm, so fnm keeps its own `FNM_MESSAGE_*` for nvm-related messaging.