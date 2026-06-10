## Why

After migrating zsh modules into a monorepo structure, message variables (`*_MESSAGE_*`) remain duplicated across every module with their own definitions of `*_MESSAGE_BREW`, `*_MESSAGE_RVM`, etc. These messages also reference external antibody bundles (`hadenlabs/zsh-*`, `luismayta/zsh-*`) that no longer exist as external dependencies — they are now internal modules in `zsh/modules/`. This duplication creates maintenance burden and confuses developers with stale references.

## What Changes

- **Centralize common `*_MESSAGE_*` variables** — Move all shared tool installation messages (brew, rvm, rust, nvm, cargo, yay, pyenv) into `zsh/core/config/env.zsh` as `CORE_MESSAGE_*` variables, eliminating per-module duplication.
- **Update message text to reference internal modules** — Replace `"use antibody bundle hadenlabs/zsh-brew"` with internal module paths like `"use zsh/modules/brew"` or similar monorepo-appropriate references.
- **Remove per-module `*_MESSAGE_*` duplicates** — Delete `*_MESSAGE_BREW`, `*_MESSAGE_RVM`, etc. from each module's `config/base.zsh` where they duplicate core's centralized messages.
- **Update module code to consume `CORE_MESSAGE_*`** — Change module internal/pkg files to reference `$CORE_MESSAGE_*` instead of their local `$MODULE_MESSAGE_*`.
- **Preserve module-specific messages** — Keep messages unique to a module (like `NOT_IMPLEMENTED`, `NOT_FOUND`, `PACKAGE_NAME`) in their respective configs.

## Capabilities

### New Capabilities
- `core-messages`: Centralized message variable definitions in `zsh/core/config/env.zsh` covering all common tool installation instructions (brew, rvm, rust, nvm, cargo, yay, pyenv). Messages reference internal monorepo module paths instead of external antibody bundles.

### Modified Capabilities
- *(No existing spec-level capabilities are changing — this is a consolidation and cleanup, not a new behavioral contract.)*

## Impact

- **`zsh/core/config/env.zsh`**: Will gain new `CORE_MESSAGE_*` variables (currently only has BREW, YAY, RVM, RUST, NVM) to cover all common tools referenced by modules (cargo, pyenv).
- **`zsh/modules/*/config/base.zsh`**: Each of the 10+ modules that define redundant `*_MESSAGE_*` variables will have those removed. Affected modules: aliases, clean, devops, fnm, git, goenv, notify, pazi, scmbreeze, starship.
- **`zsh/modules/*/internal/*.zsh` and `zsh/modules/*/pkg/*.zsh`**: Files that reference local `*_MESSAGE_*` variables will be updated to use `$CORE_MESSAGE_*`.
- **`zsh/core/pkg/base.zsh`**: Already provides `message_*` helper functions used by all modules — no changes needed to the helper functions themselves.
- **External references**: Eliminates all references to `hadenlabs/zsh-*` and `luismayta/zsh-*` antibody bundles in message strings across the entire monorepo.

## Modules affected (inventory)

| Module | Current `*_MESSAGE_*` vars | Action |
|--------|---------------------------|--------|
| core | CORE_MESSAGE_BREW, YAY, RVM, RUST, NVM | Expand coverage, update text |
| aliases | ZSH_ALIASES_MESSAGE_BREW, PYENV, NOT_FOUND | Remove BREW, PYENV (use core); keep NOT_FOUND |
| clean | CLEAN_MESSAGE_BREW, RVM, NOT_IMPLEMENTED | Remove BREW, RVM (use core); keep NOT_IMPLEMENTED |
| devops | DEVOPS_MESSAGE_BREW | Remove (use core) |
| fnm | FNM_MESSAGE_NOT_FOUND, FNM_MESSAGE_CORE | Keep both (module-specific) |
| git | GIT_MESSAGE_BREW, RVM | Remove (use core) |
| goenv | GOENV_MESSAGE_BREW | Remove (use core) |
| notify | NOTIFY_MESSAGE_BREW, RVM | Remove (use core) |
| pazi | PAZI_MESSAGE_BREW, RVM, CARGO | Remove (use core) |
| scmbreeze | SCMBREEZE_MESSAGE_BREW | Remove (use core) |
| starship | STARSHIP_MESSAGE_BREW | Remove (use core) |