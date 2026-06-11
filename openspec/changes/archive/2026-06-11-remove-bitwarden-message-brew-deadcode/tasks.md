## 1. Remove Dead Variables from Module Configs

- [x] 1.1 Delete `export BITWARDEN_MESSAGE_BREW=...` line from `zsh/modules/bitwarden/config/base.zsh`
- [x] 1.2 Delete `export SSH_MESSAGE_BREW=...` line from `zsh/modules/ssh/config/base.zsh`
- [x] 1.3 Delete `export TMUX_MESSAGE_BREW=...` line from `zsh/modules/tmux/config/base.zsh`
- [x] 1.4 Delete `export DOCKER_MESSAGE_BREW=...` line from `zsh/modules/docker/config/base.zsh`

## 2. Verification

- [x] 2.1 Confirm no remaining `*_MESSAGE_BREW` definitions exist in `zsh/modules/*/config/` (only `CORE_MESSAGE_BREW` in `zsh/core/config/env.zsh` should remain)
- [x] 2.2 Confirm `CORE_MESSAGE_BREW` is still active and used by existing consumers (`api.zsh`, `osx.zsh`, `eza.zsh`, `git/base.zsh`)