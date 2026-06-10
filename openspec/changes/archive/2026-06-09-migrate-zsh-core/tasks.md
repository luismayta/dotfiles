## 1. Core Module

- [x] 1.1 Create `zsh/modules/core/` directory
- [x] 1.2 Create `zsh/modules/core/plugin.zsh` with all zsh-core functionality (env vars, install functions, messaging, fzf helpers, docker wrappers, eza aliases, Linux helpers, git utils, project backup)

## 2. Remove External Dependency

- [x] 2.1 Remove `hadenlabs/zsh-core` from `zsh_plugins.txt`

## 3. Verification

- [x] 3.1 Source zshrc in subshell and confirm no errors
- [x] 3.2 Verify migrated functions work (fzf helpers, docker wrappers, eza, backup, git utils)
- [x] 3.3 Run `task validate` to confirm pre-commit passes