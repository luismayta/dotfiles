## Why

El módulo notify tiene el código de noti desordenado: config/base.zsh mezcla env vars con paths, internal/noti.zsh tiene config generation y send logic juntas, y el naming es inconsistente con el patrón establecido por el módulo AI. Se necesita refactorizar para seguir el patrón de tres capas (config → internal → pkg) con separación clara de responsabilidades.

## What Changes

- Se crea `config/noti.zsh` para variables del dominio noti
- Se refactoriza `internal/noti.zsh` con install function y guard pattern
- Se limpia `pkg/noti.zsh` con wrappers delgados
- Se actualiza `plugin.zsh` con auto-install guards
- Se elimina código duplicado y inconsistente de config/base.zsh

## Capabilities

### New Capabilities

- `notify-noti-pattern`: Refactorización del módulo notify para seguir el patrón three-layer del módulo AI, con separación clara de config/internal/pkg y naming consistente

### Modified Capabilities

<!-- None — this is a refactor, no requirement changes -->

## Impact

- **Archivos modificados:**
  - `zsh/modules/notify/config/base.zsh` — se limpian variables, se sourcea config/noti.zsh
  - `zsh/modules/notify/config/noti.zsh` — NEW: variables del dominio noti
  - `zsh/modules/notify/internal/noti.zsh` — refactorizado: install + send + config functions
  - `zsh/modules/notify/internal/linux.zsh` — se simplifica popup function
  - `zsh/modules/notify/internal/osx.zsh` — se simplifica popup function
  - `zsh/modules/notify/internal/main.zsh` — se actualiza source order
  - `zsh/modules/notify/pkg/noti.zsh` — wrappers delgados
  - `zsh/modules/notify/pkg/main.zsh` — se actualiza source order
  - `zsh/modules/notify/plugin.zsh` — auto-install guards
