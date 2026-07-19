## 1. Core Implementation

- [x] 1.1 Rewrite `bitwarden::internal::load::env` function in `zsh/modules/bitwarden/internal/base.zsh`
- [x] 1.2 Add `env-secrets` availability check at function start
- [x] 1.3 Remove `.bw_env` file check and sourcing logic
- [x] 1.4 Remove manual `bw get item` and `jq` extraction code
- [x] 1.5 Implement fzf selection from `BITWARDEN_VARS_LIST`
- [x] 1.6 Implement `eval "$(env-secrets bw ${selected})"` delegation
- [x] 1.7 Handle empty selection case (return silently)

## 2. Testing & Verification

- [ ] 2.1 Verify function works with multiple vaults in `BITWARDEN_VARS_LIST`
- [ ] 2.2 Verify function works with single vault (auto-select)
- [ ] 2.3 Verify function works with empty vault list (return silently)
- [ ] 2.4 Verify fzf cancellation returns silently without modifying environment
- [ ] 2.5 Verify `bw::load::env` wrapper still functions correctly
- [ ] 2.6 Verify `bw::search::*` functions still work via wrapper

## 3. Cleanup

- [x] 3.1 Remove any dead code related to `.bw_env` handling
- [x] 3.2 Update any comments referencing removed functionality
