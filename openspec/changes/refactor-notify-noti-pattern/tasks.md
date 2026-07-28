## 1. Config Layer Refactor

- [x] 1.1 Create `config/noti.zsh` with noti-specific variables (ZSH_NOTIFY_NOTI_*)
- [x] 1.2 Clean `config/base.zsh` — remove noti variables, source config/noti.zsh
- [x] 1.3 Update `config/linux.zsh` — remove noti paths (moved to config/noti.zsh)
- [x] 1.4 Update `config/osx.zsh` — remove noti paths (moved to config/noti.zsh)

## 2. Internal Layer Refactor

- [x] 2.1 Rewrite `internal/noti.zsh` with install function + guard pattern
- [x] 2.2 Keep send function with proper naming: `notify::noti::internal::send`
- [x] 2.3 Keep config function: `notify::noti::internal::config`
- [x] 2.4 Simplify `internal/linux.zsh` — clean popup function
- [x] 2.5 Simplify `internal/osx.zsh` — clean popup function

## 3. Pkg Layer Refactor

- [x] 3.1 Rewrite `pkg/noti.zsh` with thin wrappers: install, send, config
- [x] 3.2 Update `pkg/main.zsh` — ensure proper source order

## 4. Plugin Loader Update

- [x] 4.1 Update `plugin.zsh` — add auto-install guard for noti
- [x] 4.2 Ensure proper source order: config → internal → pkg → guards

## 5. Verification

- [x] 5.1 Verify naming convention: all functions follow `notify::noti::*` pattern
- [x] 5.2 Verify guard pattern: install function checks `core::exists noti`
- [x] 5.3 Verify config isolation: no noti variables in config/base.zsh
- [x] 5.4 Verify source order: all main.zsh files load correctly
