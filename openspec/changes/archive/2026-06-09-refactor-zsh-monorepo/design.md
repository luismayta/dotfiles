## Context

Add a `modules/` monorepo to `zsh/` for housing ZSH extension modules. The existing `mod/` directory continues working exactly as-is — no restructuring, no migration.

```
zsh/
├── zshrc              # Updated: sources mod/main.zsh then modules/*/plugin.zsh
├── zshenv             # UNCHANGED
├── zsh_plugins.txt    # UNCHANGED
├── mod/               # UNCHANGED (config/ + internal/ - already works)
└── modules/           # NEW
    ├── zsh-brew/plugin.zsh
    └── ...
```

## Goals / Non-Goals

**Goals:**
- Add `modules/` directory under `zsh/`
- Update `zshrc` to source `modules/*/plugin.zsh` after `mod/main.zsh`
- Keep the change small, safe, and reversible

**Non-Goals:**
- No refactor of existing `mod/` structure
- No `pkg/` layer or factory pattern changes
- No migration of existing code
- No changes to `zshenv` or `zsh_plugins.txt`

## Decisions

1. **`modules/` directory pattern** — Each module lives in its own subdirectory with a `plugin.zsh` entry point. No registry file, no metadata. Sourcing is a simple glob loop in `zshrc`. This is the simplest extension mechanism that works.

2. **Load order: `mod/` then `modules/`** — `zshrc` sources `mod/main.zsh` first (existing behavior), then globs `modules/*/plugin.zsh` in sorted order. Deterministic, no surprises.

3. **`plugin.zsh` convention** — Antidote-compatible entry point. Modules authored here can be extracted to their own repo later and loaded via `zsh_plugins.txt` with zero changes.

## Risks / Trade-offs

- **[Low risk] `modules/` dir not present** — The glob handles this gracefully; if no files match, nothing happens.
- **[Low risk] Module conflicts** — Modules should not redefine functions from `mod/`. This is convention, not enforcement — same as any ZSH plugin ecosystem.
