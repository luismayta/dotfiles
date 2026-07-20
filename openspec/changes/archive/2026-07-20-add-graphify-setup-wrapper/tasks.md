## 1. Internal Implementation

- [x] 1.1 Add `ai::internal::graphify::setup` function in `zsh/modules/ai/internal/base.zsh` after `register_skill` (line 354)
- [x] 1.2 Function checks `core::exists graphify` before executing
- [x] 1.3 Function runs `graphify install --platform opencode --project` with success/error reporting

## 2. Public Wrapper

- [x] 2.1 Add `ai::graphify::setup` function in `zsh/modules/ai/pkg/helper.zsh` after `ai::graphify::upgrade` (line 115)
- [x] 2.2 Wrapper delegates to `ai::internal::graphify::setup`

## 3. Verification

- [x] 3.1 Verify functions are available after sourcing the AI module
- [x] 3.2 Test `ai::graphify::setup` executes correctly
