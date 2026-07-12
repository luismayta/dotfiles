## 1. Module Directory Rename

- [x] 1.1 `git mv zsh/modules/fnm zsh/modules/nodejs` to preserve history
- [x] 1.2 Rename `openspec/specs/fnm-module` to `openspec/specs/nodejs-module`

## 2. plugin.zsh — Module Entry Point

- [x] 2.1 Update header comment: `fnm ZSH module` → `Node.js ZSH module`
- [x] 2.2 Rename idempotency guard: `__ZSH_FNM_LOADED` → `__ZSH_NODEJS_LOADED`
- [x] 2.3 Rename path variable: `ZSH_FNM_PATH` → `ZSH_NODEJS_PATH`
- [x] 2.4 Update `message_info "Loading module: fnm"` → `message_info "Loading module: nodejs"`

## 3. config/base.zsh — Configuration Variables

- [x] 3.1 Update module root comment: `# Module root path (set by plugin.zsh as ZSH_FNM_PATH)` → `ZSH_NODEJS_PATH`
- [x] 3.2 Rename: `ZSH_FNM_ENABLED` → `ZSH_NODEJS_ENABLED`
- [x] 3.3 Rename: `FNM_PACKAGE_NAME` → `NODEJS_TOOL_NAME`
- [x] 3.4 Rename: `FNM_VERSION_GLOBAL` → `NODEJS_VERSION_GLOBAL`
- [x] 3.5 Rename: `FNM_PACKAGES` → `NODEJS_PACKAGES`
- [x] 3.6 Keep external references: `FNM_PATH`, `FNM_VERSION`, `FNM_INSTALL_URL` unchanged

## 4. config/main.zsh — Config Orchestration

- [x] 4.1 Update `ZSH_FNM_PATH` references → `ZSH_NODEJS_PATH`

## 5. config/linux.zsh — Linux Config (empty shell)

- [x] 5.1 Update header comment: `# Linux overrides for ZSH_FNM_ENABLED` → `ZSH_NODEJS_ENABLED`

## 6. config/osx.zsh — macOS Config (empty shell)

- [x] 6.1 Update header comment: `# macOS overrides for ZSH_FNM_ENABLED` → `ZSH_NODEJS_ENABLED`

## 7. internal/base.zsh — Internal Core Functions

- [x] 7.1 Rename all `fnm::internal::*` functions to `nodejs::internal::*`
- [x] 7.2 Rename all `ZSH_FNM_*` variable references to `ZSH_NODEJS_*`
- [x] 7.3 Rename all `FNM_*` config var references to `NODEJS_*` (where applicable)
- [x] 7.4 Keep external tool commands unchanged: `fnm install`, `fnm env`, `fnm use`, `fnm alias`

## 8. internal/main.zsh — Internal Orchestration

- [x] 8.1 Update `ZSH_FNM_PATH` references → `ZSH_NODEJS_PATH`

## 9. internal/helper.zsh — Internal Helper (empty shell)

- [x] 9.1 Update function names if any exist (likely no content changes needed)

## 10. internal/linux.zsh — Linux Internals (empty shell)

- [x] 10.1 Update function names if any exist

## 11. internal/osx.zsh — macOS Internals (empty shell)

- [x] 11.1 Update function names if any exist

## 12. pkg/base.zsh — Public API Functions

- [x] 12.1 Rename all `fnm::*` public functions to `nodejs::*`
- [x] 12.2 Rename all `ZSH_FNM_*` variable references to `ZSH_NODEJS_*`
- [x] 12.3 Rename all `FNM_*` config var references to `NODEJS_*` (where applicable)
- [x] 12.4 Keep external tool commands unchanged: `fnm install`, `fnm env`, `fnm use`, `fnm alias`

## 13. pkg/main.zsh — Public API Orchestration

- [x] 13.1 Update `ZSH_FNM_PATH` references → `ZSH_NODEJS_PATH`

## 14. pkg/alias.zsh — Public Aliases (empty shell)

- [x] 14.1 Update function names if any exist

## 15. pkg/helper.zsh — Public Helpers (empty shell)

- [x] 15.1 Update function names if any exist

## 16. pkg/linux.zsh — Linux Public API (empty shell)

- [x] 16.1 Update function names if any exist

## 17. pkg/osx.zsh — macOS Public API (empty shell)

- [x] 17.1 Update function names if any exist

## 18. External References

- [x] 18.1 Update `.goji.json`: change `"fnm"` scope to `"nodejs"`
- [x] 18.2 Add `nodejs` to `DOTFILES_SETUP_MODULES` in `zsh/core/pkg/setup.zsh`

## 19. Verification

- [x] 19.1 Run syntax check on all modified zsh files: `zsh -n zsh/modules/nodejs/**/*.zsh`
- [x] 19.2 Verify no remaining `ZSH_FNM_*` or `fnm::*` references in the renamed module
- [x] 19.3 Verify external tool references (`fnm install`, `fnm env`, etc.) are preserved
- [x] 19.4 Run `openspec status --change rename-fnm-to-nodejs --json` to confirm change is complete
