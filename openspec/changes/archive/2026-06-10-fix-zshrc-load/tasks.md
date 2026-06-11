## 1. Environment Variables in paths.zsh

- [ ] 1.1 Add `DOTFILES_CORE_DIR="${DOTFILES_ZSH_DIR}/core"` to `zsh/core/config/paths.zsh`
- [ ] 1.2 Add backward-compat alias `DOTFILES_MOD_DIR="${DOTFILES_CORE_DIR}` in the same file

## 2. Core Bug Fixes in zshrc

- [ ] 2.1 Fix shebang: `#!/usr/bin/env ksh` → `#!/usr/bin/env zsh` (line 1)
- [ ] 2.2 Fix core dir ref: rename `DOTFILES_MOD_DIR` to `DOTFILES_CORE_DIR` (lines 11, 13)
- [ ] 2.3 Add CUSTOMRC fallback: change `source "${CUSTOMRC}"` to `source "${CUSTOMRC:-${HOME}/.customrc}"` (line ~16)
- [ ] 2.4 Fix path::clean detection: `type -p path::clean &>/dev/null` → `(( $+functions[path::clean] ))` (line ~43)
- [ ] 2.5 Fix FPATH assignment: `path::clean "${PATH}"` → `path::clean "${FPATH}"` (line ~57)
- [ ] 2.6 Add Linux completions block: `autoload -Uz compinit && compinit` for non-macOS (after macOS block, line ~71)

## 3. Verification

- [ ] 3.1 Run `lsp_diagnostics` on `zsh/zshrc` to confirm no syntax errors
- [ ] 3.2 Source `zsh/zshrc` with `set -u` to confirm no unbound variable errors
- [ ] 3.3 Confirm `core::install`, `path::clean`, `CUSTOMRC` available after load