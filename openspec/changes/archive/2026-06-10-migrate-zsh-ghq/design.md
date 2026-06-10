## Context

`hadenlabs/zsh-ghq` is an external zsh plugin providing ghq (repository management) integration with ~18 namespaced functions plus cookiecutter template configuration. Functions cover ghq path management, repository listing/getting, and project scaffolding via cookiecutter.

## Goals / Non-Goals

**Goals:**
- Port all `ghq::*` functions into `zsh/modules/ghq/`
- Preserve cookiecutter integration for project scaffolding
- Support darwin and linux OS dispatch
- Remove `hadenlabs/zsh-ghq` from `zsh/zsh_plugins.txt`
- Maintain exact function names and behavior

**Non-Goals:**
- No changes to ghq or cookiecutter behavior
- No changes to zshenv or zshrc loader

## Decisions

1. **Module root var**: `ZSH_GHQ_PATH` — follows the established pattern.
2. **Structure**: ~20 files. Cookiecutter templates stay as config files within the module.
3. **OS dispatch**: Minimal — ghq behavior is OS-agnostic, but cookiecutter path differs on darwin vs linux.

## Risks / Trade-offs

- Cookiecutter templates reference absolute paths — must use `ZSH_GHQ_PATH` for portability.
- ghq must be installed separately — module handles path integration only.