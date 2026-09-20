## 1. Config Layer

- [x] 1.1 Create `zsh/modules/ai/config/omniroute.zsh` exporting `ZSH_AI_OMNIROUTE_PACKAGE_NAME=omniroute`, `ZSH_AI_OMNIROUTE_INSTALL_CMD="bun add -g"`, `ZSH_AI_OMNIROUTE_CONFIG_DIR="${HOME}/.omniroute"`, `ZSH_AI_OMNIROUTE_DATA_PATH="${ZSH_AI_PATH}/data/omniroute"` (shebang `#!/usr/bin/env ksh`)
- [x] 1.2 Register `omniroute` in the `ZSH_AI_TOOLS` array and source `config/omniroute.zsh` in `zsh/modules/ai/config/base.zsh`

## 2. Internal Layer

- [x] 2.1 Create `zsh/modules/ai/internal/omniroute.zsh` with `ai::internal::omniroute::load` guarded by `core::exists omniroute` (PATH-only, no-op when present)
- [x] 2.2 Add `ai::internal::omniroute::install` — returns 0 if `core::exists omniroute`, else runs `${ZSH_AI_OMNIROUTE_INSTALL_CMD} ${ZSH_AI_OMNIROUTE_PACKAGE_NAME}` with `message_info`/`message_success`/`message_error`
- [x] 2.3 Add `ai::internal::omniroute::upgrade` — installs if missing, else runs `bun add -g omniroute@latest --force` with success/error messages
- [x] 2.4 Add `ai::internal::omniroute::sync` — rsyncs `ZSH_AI_OMNIROUTE_DATA_PATH` → `ZSH_AI_OMNIROUTE_CONFIG_DIR` only when data dir exists (silent no-op otherwise)
- [x] 2.5 Source `internal/omniroute.zsh` and call `ai::internal::omniroute::load` in `zsh/modules/ai/internal/main.zsh`

## 3. Public Layer

- [x] 3.1 Create `zsh/modules/ai/pkg/omniroute.zsh` with thin wrappers `ai::omniroute::install`, `ai::omniroute::upgrade`, `ai::omniroute::sync` delegating to internal
- [x] 3.2 Source `pkg/omniroute.zsh` in `zsh/modules/ai/pkg/main.zsh`
- [x] 3.3 Add `ai::omniroute::sync` to the `ai::sync` aggregator in `zsh/modules/ai/pkg/base.zsh`

## 4. Verification

- [x] 4.1 Module loads without errors: `source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh`
- [x] 4.2 `type ai::omniroute::install`, `type ai::omniroute::upgrade`, `type ai::omniroute::sync` each return `function`
- [x] 4.3 `omniroute` is present in `ZSH_AI_TOOLS` after config layer loads
- [x] 4.4 `ai::sync` includes the OmniRoute sync step (no errors when `data/omniroute/` is absent)