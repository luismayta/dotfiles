## 1. Config Layer

- [x] 1.1 Create `zsh/modules/ai/config/jcode.zsh` with environment variables: ZSH_AI_JCODE_ROOT_PATH, ZSH_AI_JCODE_BIN_PATH, ZSH_AI_JCODE_CONFIG_PATH, ZSH_AI_JCODE_CONFIG_SOURCE_PATH, ZSH_AI_JCODE_INSTALL_URL

## 2. Internal Layer

- [x] 2.1 Create `zsh/modules/ai/internal/jcode.zsh` with `ai::internal::jcode::load` function (PATH loading)
- [x] 2.2 Add `ai::internal::jcode::install` function (curl installer with core::exists guard)
- [x] 2.3 Add `ai::internal::jcode::sync` function (rsync with rsync check)

## 3. Public Layer

- [x] 3.1 Create `zsh/modules/ai/pkg/jcode.zsh` with `editjcode` function (EDITOR check)
- [x] 3.2 Add `ai::jcode::install` function (delegate to internal)
- [x] 3.3 Add `ai::jcode::sync` function (delegate to internal)

## 4. Registration

- [x] 4.1 Add `source "${ZSH_AI_PATH}/config/jcode.zsh"` to `config/base.zsh`
- [x] 4.2 Add `jcode` to `ZSH_AI_TOOLS` array in `config/base.zsh`
- [x] 4.3 Add `source "${ZSH_AI_PATH}/internal/jcode.zsh"` to `internal/main.zsh`
- [x] 4.4 Add `ai::internal::jcode::load` call to `internal/main.zsh`
- [x] 4.5 Add `source "${ZSH_AI_PATH}/pkg/jcode.zsh"` to `pkg/main.zsh`

## 5. Verification

- [x] 5.1 Source the module and verify no errors: `source zsh/modules/ai/plugin.zsh`
- [x] 5.2 Verify functions exist: `type ai::jcode::install`, `type ai::jcode::sync`, `type editjcode`
- [x] 5.3 Verify `jcode` is in `ZSH_AI_TOOLS` array
