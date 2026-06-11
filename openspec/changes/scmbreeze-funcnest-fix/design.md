## Context

SCM Breeze's `scmb_expand_args` function in `~/.scm_breeze/lib/git/status_shortcuts.sh` uses recursive calls to expand git status shortcut arguments (e.g., `1 3 6` → file indices). Zsh enforces `FUNCNEST` (default 700), which limits recursion depth. On repos with many modified files, the expansion easily exceeds this limit, producing:

```
scmb_expand_args:2: maximum nested function level reached; increase FUNCNEST?
```

The error freezes SCM Breeze shortcuts for the remainder of the shell session.

The module load order is:
1. `zsh/zshrc` → `zsh/core/main.zsh` → `zsh/core/config/env.zsh` (global env vars)
2. Later: `zsh/modules/scmbreeze/plugin.zsh` → `internal/main.zsh` → `scmbreeze::internal::load` sources `~/.scm_breeze/scm_breeze.sh`

Since `zsh/core/config/env.zsh` is sourced first (via `zsh/core/main.zsh` → `zsh/core/config/main.zsh`), `FUNCNEST` must be set there so it's in effect before any module loads.

## Goals / Non-Goals

**Goals:**
- Raise `FUNCNEST` to a value that accommodates `scmb_expand_args` recursion on any realistic repo.
- Set the value *before* SCM Breeze loads so the limit is effective.
- Set `FUNCNEST` globally in the core env layer so it's available before any module loads.

**Non-Goals:**
- Modifying SCM Breeze upstream code (the external project at `~/.scm_breeze/`).
- Tuning `FUNCNEST` to an exact minimum — a generous safe value is fine.

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| **Value** | `5000` | 7× the default (700). Handles deeply nested repos while being far below any risk of runaway recursion (which would OOM long before 5000 given stack limits). |
| **Location** | `zsh/core/config/env.zsh` | Canonical place for global environment variables. Sourced early in the bootstrap chain (`zshrc` → `core/main.zsh` → `config/main.zsh` → `config/env.zsh`), way before any module loads. |
| **Export vs local** | `export` | `FUNCNEST` must be visible to all sourced files. An unexported variable won't propagate through the `source` chain. |

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| Setting `FUNCNEST` too low for some edge case | 5000 is generous; the default of 700 was the problem. If issues recur, bump to 10000. |
| Masking runaway infinite recursion in other code | 5000 is still bounded. Infinite recursion would exhaust stack memory long before 5000 frames on any modern system. |
