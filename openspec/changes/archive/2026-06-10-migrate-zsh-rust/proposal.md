## Why

The external `luismayta/zsh-rust` plugin (antidote bundle) manages Rust toolchain installation, cargo package management, and shell environment setup. Migrating it into `zsh/modules/rust` eliminates an external dependency, enables tighter integration with the monorepo's module loader, and aligns with the ongoing effort to consolidate all zsh plugins into the monorepo.

## What Changes

- Create `zsh/modules/rust/` directory with the canonical module structure (plugin.zsh, config/, internal/, pkg/)
- Remove `luismayta/zsh-rust` from `zsh/zsh_plugins.txt`
- Port all `rust::*` functions preserving original namespaces exactly
- Adapt source chain from factory-function pattern to direct chained sourcing (matching core/brew convention)
- Replace external `ZSH_RUST_PATH` variable with local `RUST_PATH`

**No breaking changes.** All public function names remain identical.

## Capabilities

### New Capabilities
- `rust-module`: Rust toolchain initialization, automatic rustup/cargo installation, cargo package management (`RUST_CARGO_PACKAGES`), delta git config, zoxide init, and PATH/env setup for `${HOME}/.cargo`

### Modified Capabilities

None.

## Impact

- `zsh/modules/rust/` — new directory (~12 files)
- `zsh/zsh_plugins.txt` — remove line 1 (`luismayta/zsh-rust`)
- `zsh/zshrc` — no change needed (auto-loaded via module glob loop)
- External repo `/Users/luchomayta/projects/src/github.com/luismayta/zsh-rust` — unaffected