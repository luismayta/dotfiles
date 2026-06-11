## 1. Linux config override

- [x] 1.1 Add `export GIT_FLOW_PACKAGE_NAME=gitflow-avh` to `zsh/modules/git/config/linux.zsh`

## 2. Update ensure call

- [x] 2.1 Change `core::ensure git-flow` to `core::ensure "${GIT_FLOW_PACKAGE_NAME:-git-flow}"` in `zsh/modules/git/internal/main.zsh`

## 3. Verification

- [x] 3.1 Confirm syntax of both modified files with `bash -n`
- [x] 3.2 Verify the fallback: when `GIT_FLOW_PACKAGE_NAME` is unset, `core::ensure` uses `git-flow`