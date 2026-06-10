## 1. Centralize messages in core config

- [x] 1.1 Update `zsh/core/config/env.zsh` — revise existing `CORE_MESSAGE_*` values to reference internal module paths instead of external antibody bundles
- [x] 1.2 Add `CORE_MESSAGE_CARGO` — new variable with instruction referencing internal rust module
- [x] 1.3 Add `CORE_MESSAGE_PYENV` — new variable with instruction referencing internal pyenv module

## 2. Remove duplicate message vars from module configs

- [x] 2.1 Edit `zsh/modules/aliases/config/base.zsh` — remove `ZSH_ALIASES_MESSAGE_BREW` and `ZSH_ALIASES_MESSAGE_PYENV` (keep `ZSH_ALIASES_MESSAGE_NOT_FOUND`)
- [x] 2.2 Edit `zsh/modules/clean/config/base.zsh` — remove `CLEAN_MESSAGE_BREW` and `CLEAN_MESSAGE_RVM` (keep `CLEAN_MESSAGE_NOT_IMPLEMENTED`)
- [x] 2.3 Edit `zsh/modules/devops/config/base.zsh` — remove `DEVOPS_MESSAGE_BREW`
- [x] 2.4 Edit `zsh/modules/git/config/base.zsh` — remove `GIT_MESSAGE_BREW` and `GIT_MESSAGE_RVM`
- [x] 2.5 Edit `zsh/modules/goenv/config/base.zsh` — remove `GOENV_MESSAGE_BREW`
- [x] 2.6 Edit `zsh/modules/notify/config/base.zsh` — remove `NOTIFY_MESSAGE_BREW` and `NOTIFY_MESSAGE_RVM`
- [x] 2.7 Edit `zsh/modules/pazi/config/base.zsh` — remove `PAZI_MESSAGE_BREW`, `PAZI_MESSAGE_RVM`, and `PAZI_MESSAGE_CARGO`
- [x] 2.8 Edit `zsh/modules/scmbreeze/config/base.zsh` — remove `SCMBREEZE_MESSAGE_BREW`
- [x] 2.9 Edit `zsh/modules/starship/config/base.zsh` — remove `STARSHIP_MESSAGE_BREW`

## 3. Update module code to use centralized messages

- [x] 3.2 Update `zsh/modules/git/internal/base.zsh` — replace `${GIT_MESSAGE_BREW}` with `$CORE_MESSAGE_BREW`
- [x] 3.3 Update `zsh/modules/aliases/internal/eza.zsh` — inline brew message should reference core message
- [x] 3.4 Update `zsh/modules/pazi/internal/base.zsh` — replace `${PAZI_MESSAGE_CARGO}` with `$CORE_MESSAGE_CARGO`

## 4. Verify

- [x] 4.1 Run `grep -r "MESSAGE_BREW\|MESSAGE_RVM\|MESSAGE_CARGO\|MESSAGE_PYENV\|MESSAGE_YAY" zsh/modules/` — confirm no remaining local definitions in module configs (only references to `CORE_MESSAGE_*` should remain)
- [x] 4.2 Source test the updated config files to ensure no undefined variable errors
- [x] 4.3 Verify `zsh/core/` loads correctly with updated `CORE_MESSAGE_*` values