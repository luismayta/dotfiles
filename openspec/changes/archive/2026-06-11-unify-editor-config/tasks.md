## 1. Add EDITOR fallback to core

- [x] 1.1 Add `: "${EDITOR:=nvim}"` to `zsh/core/config/env.zsh`

## 2. Remove duplicate EDITOR fallbacks from modules

- [x] 2.1 Remove `[ -z "${EDITOR}" ] && export EDITOR="vim"` from `zsh/modules/tmux/config/base.zsh`
- [x] 2.2 Remove `[ -z "${EDITOR:-}" ] && export EDITOR="vim"` from `zsh/modules/ghq/config/base.zsh`
- [x] 2.3 Remove `: "${EDITOR:=${NVIM_PACKAGE_NAME}}"` from `zsh/modules/nvim/config/base.zsh`
- [x] 2.4 Remove conflicting `function vim` from `zsh/modules/aliases/internal/editor.zsh` (redundant with nvim module, has recursion bug)

## 3. Verify

- [x] 3.1 Run `source zsh/core/config/env.zsh` and confirm `echo $EDITOR` returns `nvim` (when unset)
- [x] 3.2 Confirm no other files set `EDITOR` as fallback: `grep -r "EDITOR.*=" zsh/modules/ --include="*.zsh"`
- [x] 3.3 Confirm only one `function vim` definition exists: `grep -r "function vim" zsh/modules/ --include="*.zsh"` should only match nvim module
