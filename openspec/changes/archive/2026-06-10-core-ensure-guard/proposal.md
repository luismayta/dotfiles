## Why

The `if ! core::exists <tool>; then core::install <tool>; fi` pattern appears in 10+ modules across the dotfiles codebase — every single module that manages a CLI tool. This creates unnecessary duplication: the same 3-line guard is copy-pasted with only the tool name changing. Adding a single `core::ensure <tool>` function eliminates this repetition, making modules simpler and the core library the single source of truth for this pattern.

## What Changes

- **ADD** `core::ensure <tool>` to `zsh/core/pkg/base.zsh` — a single function wrapping the exists/install guard
- **UPDATE** all modules that inline this guard to call `core::ensure <tool>` instead
- Covered tools: brew packages (k9s, kubectl, helm, fzf, bat, ripgrep, etc.), version managers (fnm, goenv, pyenv, rust), and utilities (ghq, git, starship, scmbreeze, notify, pazi)
- No breaking changes — `core::ensure` is additive, old patterns still work

## Capabilities

### New Capabilities
- `ensure`: Provides `core::ensure <tool>` as the canonical way to conditionally install a tool if not present

### Modified Capabilities
<!-- No existing specs are changing — this is a new capability addition to core -->

## Impact

- `zsh/core/pkg/base.zsh` — 1 new function (+5 lines)
- 10+ module files across `zsh/modules/` — change inline exists/install guards to `core::ensure <tool>`
- Zero behavioral change — `core::ensure` delegates to the same `core::exists` + `core::install`
- All existing `core::exists` / `core::install` calls remain valid