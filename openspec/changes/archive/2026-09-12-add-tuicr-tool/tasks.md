## 1. Data Layer

- [x] 1.1 Create `zsh/modules/ai/data/tuicr/` directory
- [x] 1.2 Create `zsh/modules/ai/data/tuicr/config.toml` with `theme = "catppuccin-mocha"` and vim-style keybindings (valid TOML per tuicr CONFIG.md schema)

## 2. Config Layer

- [x] 2.1 Create `zsh/modules/ai/config/tuicr.zsh` with shebang `#!/usr/bin/env ksh`
- [x] 2.2 Export `ZSH_AI_TUICR_BIN_PATH="${HOME}/.local/bin"` and `ZSH_AI_TUICR_CONFIG_PATH="${HOME}/.config/tuicr"` (all variables prefixed `ZSH_AI_TUICR_`)

## 3. Internal Layer

- [x] 3.1 Create `zsh/modules/ai/internal/tuicr.zsh` with shebang `#!/usr/bin/env ksh` and namespace `ai::internal::tuicr::`
- [x] 3.2 Implement `ai::internal::tuicr::load` — guard on `core::exists tuicr` before prepending `ZSH_AI_TUICR_BIN_PATH` to PATH
- [x] 3.3 Implement `ai::internal::tuicr::install` — return 0 if tuicr exists; verify `core::exists cargo` (error + return 1 if missing); run `cargo install --root "${HOME}/.local" tuicr` with `message_info` progress and `message_success`/`message_error` outcome
- [x] 3.4 Invoke `ai::internal::tuicr::load` at the end of the file

## 4. Public Layer

- [x] 4.1 Create `zsh/modules/ai/pkg/tuicr.zsh` with shebang `#!/usr/bin/env ksh` and namespace `ai::tuicr::`
- [x] 4.2 Implement `ai::tuicr::install` delegating to `ai::internal::tuicr::install`
- [x] 4.3 Implement `ai::tuicr::review` executing `tuicr "${@}"`
- [x] 4.4 Implement `ai::tuicr::pr` executing `tuicr pr "${@}"`
- [x] 4.5 Implement `ai::tuicr::config::sync` — `mkdir -p` target dir and copy `data/tuicr/config.toml` to `~/.config/tuicr/` (warning if template missing)
- [x] 4.6 Implement `ai::tuicr::post_install` displaying post-installation guidance

## 5. Module Registration

- [x] 5.1 In `zsh/modules/ai/config/base.zsh`: source `config/tuicr.zsh` and add `tuicr` to the `ZSH_AI_TOOLS` array
- [x] 5.2 In `zsh/modules/ai/internal/main.zsh`: source `internal/tuicr.zsh` and call `ai::internal::tuicr::load`
- [x] 5.3 In `zsh/modules/ai/pkg/main.zsh`: source `pkg/tuicr.zsh`

## 6. Verification

- [x] 6.1 Source the AI module and confirm it loads without errors
- [x] 6.2 Verify `tuicr` is present in `ZSH_AI_TOOLS` and `ai::tuicr::*` / `ai::internal::tuicr::*` functions are defined
- [x] 6.3 Smoke-test `ai::tuicr::config::sync` and confirm `~/.config/tuicr/config.toml` is created
- [x] 6.4 Run `openspec validate --change add-tuicr-tool` and confirm the change is valid