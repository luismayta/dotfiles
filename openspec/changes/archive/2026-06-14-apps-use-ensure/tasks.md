## 1. Core change

- [x] 1.1 Replace `core::install` with `core::ensure` in `apps::internal::packages::install()` within `zsh/modules/apps/internal/base.zsh`

## 2. Verification

- [x] 2.1 Source the module and verify `apps::internal::packages::install` runs without errors
- [x] 2.2 Confirm already-installed packages are skipped (no re-install attempt)
- [x] 2.3 Confirm missing packages are still installed
