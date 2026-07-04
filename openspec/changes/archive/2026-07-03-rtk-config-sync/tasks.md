## 1. Config Variables

- [x] 1.1 Add `AI_RTK_CONFIG_PATH` and `AI_RTK_CONFIG_SOURCE_PATH` to `zsh/modules/ai/config/base.zsh`
- [x] 1.2 Verify variables are exported and resolve to correct paths

## 2. Default Config File

- [x] 2.1 Create `zsh/modules/ai/data/rtk/config.toml` with `[hooks] exclude_commands`, `[tracking]`, `[display]` sections
- [x] 2.2 Validate the TOML file parses correctly

## 3. Sync Function

- [x] 3.1 Add `ai::internal::rtk::config::sync` function to `zsh/modules/ai/internal/base.zsh`
- [x] 3.2 Include `mkdir -p` guard, `rsync -a` call, and success/error messaging
- [x] 3.3 Verify function is callable and syncs correctly
