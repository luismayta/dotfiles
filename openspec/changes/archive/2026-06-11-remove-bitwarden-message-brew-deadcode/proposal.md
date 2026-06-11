## Why

Cuatro variables `*_MESSAGE_BREW` están definidas y exportadas en módulos de `zsh/modules/` pero nunca referenciadas en ningún internal ni en el resto del codebase. Son dead code que quedó del cambio anterior de estandarización (`standardize-message-vars`), que ya centralizó estas variables en `CORE_MESSAGE_BREW` en `zsh/core/config/env.zsh`.

## What Changes

- Eliminar `export BITWARDEN_MESSAGE_BREW` de `zsh/modules/bitwarden/config/base.zsh`
- Eliminar `export SSH_MESSAGE_BREW` de `zsh/modules/ssh/config/base.zsh`
- Eliminar `export TMUX_MESSAGE_BREW` de `zsh/modules/tmux/config/base.zsh`
- Eliminar `export DOCKER_MESSAGE_BREW` de `zsh/modules/docker/config/base.zsh`
- Sin impacto funcional — los 4 consumidores activos ya usan `$CORE_MESSAGE_BREW`

## Capabilities

### New Capabilities

*(none — cleanup, no new capabilities)*

### Modified Capabilities

*(none — no spec-level behavior changes)*

## Impact

- **Archivos modificados** (4):
  - `zsh/modules/bitwarden/config/base.zsh`
  - `zsh/modules/ssh/config/base.zsh`
  - `zsh/modules/tmux/config/base.zsh`
  - `zsh/modules/docker/config/base.zsh`
- **Scope**: Solo interno del repo; `CORE_MESSAGE_BREW` en `zsh/core/config/env.zsh` permanece intacto y cubre todos los casos de uso.
