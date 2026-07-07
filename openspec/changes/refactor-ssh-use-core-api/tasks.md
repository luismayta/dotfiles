## 1. Replace clipboard dispatch with `pbcopy` from core

- [x] 1.1 In `zsh/modules/ssh/internal/base.zsh`, replace the `ssh::connect` clipboard `case OSTYPE` block (lines ~28–46) with `print -n "ssh ${buffer}" | pbcopy`

## 2. Replace manual dependency guards with `core::ensure`

- [x] 2.1 In `zsh/modules/ssh/internal/main.zsh`, replace `if ! core::exists curl; then core::install curl; fi` with `core::ensure curl`
- [x] 2.2 Replace `if ! core::exists fzf; then core::install fzf; fi` with `core::ensure fzf` in the same file
- [x] 2.3 Replace `if ! core::exists jq; then core::install jq; fi` with `core::ensure jq` in the same file
- [x] 2.4 Replace `if ! core::exists assh; then core::install assh; fi` with `core::ensure assh` in the same file
- [x] 2.5 Remove the `core::ensure less` line (dead code — no SSH function uses `less`)

## 3. Use `backup` from core in `ssh::build`

- [x] 3.1 In `zsh/modules/ssh/internal/base.zsh`, replace the manual `cp` timestamped backup in `ssh::build` with `backup "${SSH_CONFIG_FILE}"`

## 4. Commit and finalize

- [x] 4.1 Run `source zshrc` and verify each SSH function works (`ssh::list`, `ssh::build`, `ssh::connect`)
- [x] 4.2 Commit all changes with message: `refactor 🏗️ (ssh): HAD-61 Use core API functions (pbcopy, core::ensure, backup)`
