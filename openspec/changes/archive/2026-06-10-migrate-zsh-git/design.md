## Context

`hadenlabs/zsh-git` is an external zsh plugin providing git alias shortcuts, helper functions, and git-flow CLI scripts. The source repo has a `bin/` directory with 25+ executable scripts and shell functions. Migrating it to `zsh/modules/git/` requires both the library functions and the CLI scripts.

## Goals / Non-Goals

**Goals:**
- Port all `git::*` functions and CLI scripts into `zsh/modules/git/`
- Support darwin and linux OS dispatch where needed
- Remove `hadenlabs/zsh-git` from `zsh/zsh_plugins.txt`
- Maintain exact function names and CLI behavior

**Non-Goals:**
- No changes to git aliases or behavior
- No changes to zshenv or zshrc loader

## Decisions

1. **Module root var**: `ZSH_GIT_PATH` — consistent with `ZSH_FNM_PATH`, `ZSH_PYENV_PATH` pattern.
2. **Structure**: ~25 files. CLI scripts from `bin/` go into `pkg/` as sourced functions rather than separate executables (monorepo convention).
3. **Git-flow helpers**: Ported into `pkg/base.zsh` with OS dispatch for flow configuration.
4. **Aliases**: Defined in `config/base.zsh` using `alias git-xxx='git xxx'` pattern.

## Risks / Trade-offs

- Large number of CLI scripts (25+) — careful mapping needed to avoid missing functions.
- Some scripts may have external dependencies (git, git-flow) — must verify at module load time.
