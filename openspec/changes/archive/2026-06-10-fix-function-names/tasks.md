## 1. Fix starship function call (extra namespace segment)

- [x] 1.1 In `zsh/modules/starship/pkg/base.zsh:16`, change `starship::internal::starship::install` → `starship::internal::install`

## 2. Fix kubectl function call (capital G typo)

- [x] 2.1 In `zsh/modules/devops/pkg/kubectl.zsh:26`, change `Goenv::internal::package::install` → `goenv::internal::package::install`

## 3. Fix kubectl internal function call (non-existent function name)

- [x] 3.1 In `zsh/modules/devops/internal/kubectl.zsh:78`, change `goenv::internal::package::get` → `goenv::internal::package::install`

## 4. Verify fixes

- [x] 4.1 Run `lsp_diagnostics` on all 3 modified files (no LSP for .zsh — verified via grep)
- [x] 4.2 Confirm no "command not found" errors on affected module loads
