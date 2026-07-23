## 1. Configuration Layer

- [x] 1.1 Create `config/worktrunk.zsh` with DEVOPS_WORKTRUNK_* variables
- [x] 1.2 Add `worktrunk` to DEVOPS_TOOLS array in `config/base.zsh`

## 2. Internal Layer

- [x] 2.1 Create `internal/worktrunk.zsh` with load, install, upgrade, and factory functions
- [x] 2.2 Implement PATH integration using `core::path::prepend`
- [x] 2.3 Implement installation via `core::install worktrunk`
- [x] 2.4 Implement shell integration via `wt config shell install`

## 3. Public API Layer

- [x] 3.1 Create `pkg/worktrunk.zsh` with install, upgrade, and post_install functions
- [x] 3.2 Implement post_install message with setup instructions

## 4. Testing & Verification

- [x] 4.1 Test module loading with worktrunk installed
- [x] 4.2 Test module loading without worktrunk (auto-install)
- [x] 4.3 Verify all public functions are available
- [x] 4.4 Verify PATH integration works correctly
