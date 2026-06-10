## Context

Migrate `luismayta/zsh-brew` (standalone repo, 129-line `zsh-brew.zsh` with brew install/load/post-install) into the dotfiles monorepo at `zsh/modules/brew/`, following the identical multi-file architecture established by `zsh/modules/core/`.

Current state:
- `luismayta/zsh-brew` is loaded via antidote in `zsh/zsh_plugins.txt`
- Single-file plugin: `zsh-brew.zsh` with all functions
- Functions: `brew::install`, `brew::install::osx`, `brew::install::linux`, `brew::dependences::checked`, `brew::dependences::install`, `brew::post_install`, `brew::load`
- `brew::load` is auto-invoked at the bottom of the file; auto-install runs if brew not found

Target state:
- `zsh/modules/brew/plugin.zsh` sourced by the module loader in `zshrc`
- Three-layer structure (config/ → internal/ → pkg/) with OS dispatch
- `luismayta/zsh-brew` removed from `zsh/zsh_plugins.txt`

## Goals / Non-Goals

**Goals:**
- Port all `brew::*` functions preserving namespaces exactly
- Replicate the core module's multi-file pattern (config/, internal/, pkg/)
- Remove external antidote dependency
- Preserve auto-invocation of `brew::load` and auto-install side-effect

**Non-Goals:**
- Refactor function logic or improve brew installation flow
- Change brew package names or versions
- Add new brew-related features

## Decisions

**Decision 1: Mirror core module file structure**

Core has: `plugin.zsh` → `config/{main,base,osx,linux}.zsh` → `internal/{main,base,osx,linux}.zsh` → `pkg/{main,base,...}.zsh`

Brew follows the same pattern:
```
zsh/modules/brew/
├── plugin.zsh              ← Entry point (idempotency guard + chain sources)
├── config/
│   ├── main.zsh            ← OS dispatch → base.zsh
│   ├── base.zsh            ← brew_package_name
│   ├── osx.zsh             ← Placeholder
│   └── linux.zsh           ← Placeholder
├── internal/
│   ├── main.zsh            ← Sources all internal
│   ├── base.zsh            ← brew::dependences::checked, ::install, ::dependences::install, ::post_install
│   ├── osx.zsh             ← brew::install::osx
│   └── linux.zsh           ← brew::install::linux
└── pkg/
    ├── main.zsh            ← Sources all packages
    └── base.zsh            ← brew::load + auto-invoke + auto-install side-effect
```

Rationale: Consistency with the modules convention makes maintenance predictable. The `brew` module has a simpler surface than `core` — no fzf helpers, no docker wrappers, no git utils — so most sub-files are thin wrappers.

**Decision 2: brew_package_name stays in config, not hardcoded**

The variable `brew_package_name=brew` lives in `config/base.zsh` for consistency. Though it's always "brew", keeping it configurable aligns with the original design.

**Decision 3: Auto-invoke in pkg/main.zsh, not plugin.zsh**

`brew::load` and the auto-install guard `if ! type -p brew > /dev/null; then brew::install; brew::post_install; fi` live in `pkg/base.zsh` (sourced last), not `plugin.zsh`. This keeps `plugin.zsh` as a thin chain loader identical to core's.

## Risks / Trade-offs

- **[Low] Auto-install runs only if brew not found** — Same behavior as original. No regression risk.
- **[None] No breaking changes** — All function names preserved, module loaded in same order via the existing module loader loop.