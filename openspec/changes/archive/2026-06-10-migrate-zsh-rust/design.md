## Context

The `luismayta/zsh-rust` plugin is currently loaded via antidote from `zsh/zsh_plugins.txt`. It provides Rust toolchain management (rustup/cargo install, cargo package manager, delta git pager, zoxide init) and shell environment setup (PATH, cargo env). The source at `/Users/luchomayta/projects/src/github.com/luismayta/zsh-rust/` already follows a config/internal/pkg 3-layer architecture with factory-function sourcing, OS dispatch, and ~15 source files (plus docs, CI, etc. not needed in monorepo).

The monorepo convention (established by `zsh/modules/core/` and `zsh/modules/brew/`) uses:
- `plugin.zsh` with idempotency guard → chains config/main.zsh → internal/main.zsh → pkg/main.zsh
- Direct sourcing (no factory function wrappers)
- OS-specific files sourced via `case ${OSTYPE}` in main.zsh dispatchers
- All functions defined unconditionally (no conditional OS-only definitions)
- Auto-install side-effects in pkg/base.zsh

## Goals / Non-Goals

**Goals:**
- Port all `rust::*` functions into `zsh/modules/rust/` preserving public API
- Remove `luismayta/zsh-rust` antidote bundle
- Match the canonical module file layout (11-12 files)
- Ensure functions available on all platforms
- Pass `zsh -n` and `task validate`

**Non-Goals:**
- Rename functions or change public API
- Port docs, CI, or non-essential repo infrastructure
- Modify the external repo
- Merge the 4 internal files into fewer files

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Source chain pattern | Direct sourcing (brew pattern) | Original uses factory functions (`rust::config::main::factory`); monorepo convention removes wrapper layer for simplicity |
| `internal/packages.zsh` → `internal/packages.zsh` | Keep separate file | Contains `delta::load` and `zoxide::load` — logically distinct from base functions. Sourced after base, before OS files |
| `internal/helper.zsh` | Keep as empty placeholder | Sourced in original; keep for future use. Same pattern as core's empty OS files |
| `pkg/helper.zsh` | Keep as empty placeholder | Same reasoning — sourced in original, kept as placeholder |
| `pkg/alias.zsh` | Keep as empty placeholder | Originally empty; kept for future cargo command aliases |
| `pkg/osx.zsh` / `pkg/linux.zsh` | Keep as empty placeholders | Original had empty OS-specific pkg files; preserved for future platform additions |
| `rust::internal::*` functions | Move from internal/main.zsh calls to pkg/base.zsh auto-invoke | Matches brew pattern where auto-install/load side-effects live in pkg/base.zsh, not internal/main.zsh |
| `RUST_CARGO_BIN` export | Keep in config/base.zsh | Part of public config contract |
| `RUST_CARGO_PACKAGES` array | Keep in config/base.zsh | User-configurable list visible in config layer |

## Risks / Trade-offs

- [Low] `rust::internal::delta::load` and `rust::internal::zoxide::load` are called from `internal/main.zsh` only if `core::exists delta` / `core::exists zoxide` — these guards are preserved exactly
- [Low] The original sources `RUST_CARGO_ENV` file in `rust::internal::rust::load` (a generated file from rustup) — this is preserved in pkg layer
- [Low] cargo package install loop with 20+ packages may be slow on first load — unchanged from original behavior
