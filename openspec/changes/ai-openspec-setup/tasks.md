## 1. Configuration Layer

- [ ] 1.1 Add `AI_OPENSPEC_BIN_PATH` environment variable to `zsh/modules/ai/config/base.zsh`
- [ ] 1.2 Set default value to `$(npm root -g)/../bin` (npm global bin directory)

## 2. Internal Implementation

- [ ] 2.1 Add `ai::internal::openspec::load` function to `zsh/modules/ai/internal/base.zsh`
  - Check if OpenSpec binary exists at `AI_OPENSPEC_BIN_PATH/openspec`
  - Add to PATH if found, no error if missing
- [ ] 2.2 Add `ai::internal::openspec::install` function
  - Execute `npm install -g @fission-ai/openspec@latest`
  - Call `ai::internal::openspec::register_skill` on success
  - Display error and return non-zero on failure
- [ ] 2.3 Add `ai::internal::openspec::upgrade` function
  - Execute `npm install -g @fission-ai/openspec@latest --force`
  - Call `ai::internal::openspec::register_skill` on success
- [ ] 2.4 Add `ai::internal::openspec::setup` function
  - Check if OpenSpec is installed (use `core::exists openspec` or check binary)
  - Display error "openspec is not installed. Run ai::openspec::install first." if missing
  - Execute `openspec install --platform opencode --project`
  - Display success/error message
- [ ] 2.5 Add `ai::internal::openspec::register_skill` function
  - Execute `openspec install --platform opencode`
  - This registers OpenSpec globally with OpenCode

## 3. Public API Layer

- [ ] 3.1 Add `ai::openspec::install` wrapper function to `zsh/modules/ai/pkg/helper.zsh`
  - Delegate to `ai::internal::openspec::install`
- [ ] 3.2 Add `ai::openspec::upgrade` wrapper function
  - Delegate to `ai::internal::openspec::upgrade`
- [ ] 3.3 Add `ai::openspec::setup` wrapper function
  - Delegate to `ai::internal::openspec::setup`

## 4. Bootstrap Integration

- [ ] 4.1 Add `ai::internal::openspec::load` call to `zsh/modules/ai/internal/main.zsh`
  - Add after existing `ai::internal::graphify::load` call (line 25)
- [ ] 4.2 Verify module loads without errors by sourcing plugin.zsh

## 5. Verification

- [ ] 5.1 Test `ai::openspec::install` installs OpenSpec successfully
- [ ] 5.2 Test `ai::openspec::upgrade` upgrades OpenSpec
- [ ] 5.3 Test `ai::openspec::setup` sets up OpenSpec for current project
- [ ] 5.4 Test error handling when OpenSpec is not installed
- [ ] 5.5 Verify OpenSpec binary is in PATH after shell startup
