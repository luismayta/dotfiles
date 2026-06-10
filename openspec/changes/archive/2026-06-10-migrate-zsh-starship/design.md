## Context

`hadenlabs/zsh-starship` is an external zsh plugin providing starship prompt initialization and starship.toml configuration management. Functions are under the `starship::` namespace. It is the smallest of the 6 modules — mainly prompt setup and config file management.

## Goals / Non-Goals

**Goals:**
- Port all `starship::*` functions into `zsh/modules/starship/`
- Copy `starship.toml` configuration
- Support darwin and linux OS dispatch
- Remove `hadenlabs/zsh-starship` from `zsh/zsh_plugins.txt`
- Maintain exact function names and behavior

**Non-Goals:**
- No changes to starship prompt behavior or config
- No changes to zshenv or zshrc loader

## Decisions

1. **Module root var**: `ZSH_STARSHIP_PATH` — follows the established pattern.
2. **Structure**: ~12 files. Starship config is copied as `config/starship.toml` and linked/symlinked at init.
3. **OS dispatch**: Minimal — starship init is the same across OS, but config path may differ.

## Risks / Trade-offs

- Starship must be installed separately — module only handles integration and config.
- Existing `~/.config/starship.toml` must not be overwritten without user consent.
