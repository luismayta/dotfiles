## 1. Core env config

- [x] 1.1 Add `export FUNCNEST=5000` to `zsh/core/config/env.zsh`

## 2. Revert scmbreeze module config

- [x] 2.1 Remove `export FUNCNEST=5000` from `zsh/modules/scmbreeze/config/base.zsh`

## 3. Verification

- [x] 3.1 Verify `FUNCNEST=5000` is set after sourcing `zsh/core/config/env.zsh`
- [x] 3.2 Confirm scmbreeze module still loads without errors