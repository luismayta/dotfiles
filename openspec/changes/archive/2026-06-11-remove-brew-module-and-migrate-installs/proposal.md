## Why

El módulo `zsh/modules/brew/` es un vestigio de la arquitectura anterior donde cada módulo gestionaba su propia instalación con comandos `brew install` directos. Ahora `core::install` (definido en `zsh/core/pkg/base.zsh`) es el mecanismo estándar y centralizado para instalar cualquier paquete en cualquier plataforma. El módulo brew duplica lógica y contiene funciones obsoletas (`brew::install`, `brew::post_install`) que deberían ser eliminadas.

Además, 4 archivos en otros módulos aún usan `brew install` directamente en vez de `core::install`, lo que los hace no-portables a Linux.

## What Changes

- **Eliminar** `zsh/modules/brew/` completamente (10 archivos, ~100 líneas)
- **Migrar** 4 llamadas directas `brew install` a `core::install` en:
  - `zsh/modules/git/internal/base.zsh` — `brew install git`
  - `zsh/modules/ghq/internal/base.zsh` — `brew install "${GHQ_PACKAGE_NAME}"`
  - `zsh/modules/ghostty/internal/base.zsh` — `brew install --cask ghostty`
  - `zsh/modules/aliases/internal/eza.zsh` — `brew install eza`
- **Actualizar** `CORE_MESSAGE_BREW` en `zsh/core/config/env.zsh` para que no referencie `zsh/modules/brew`
- **Actualizar** spec `core-messages` que referencia `zsh/modules/brew`

## Capabilities

### New Capabilities

*(none — cleanup/migration, no new capabilities)*

### Modified Capabilities

- `core-messages`: El requirement `CORE_MESSAGE_BREW is defined` actualmente referencia `zsh/modules/brew` — debe actualizarse para reflejar que el mensaje ahora refiere a `core::install` tras la eliminación del módulo

## Impact

- **Eliminación**: `zsh/modules/brew/` (directorio completo)
- **Modificaciones** (5 archivos):
  - `zsh/modules/git/internal/base.zsh` (línea 11: `brew install git` → `core::install git`)
  - `zsh/modules/ghq/internal/base.zsh` (línea 7: `brew install` → `core::install`)
  - `zsh/modules/ghostty/internal/base.zsh` (línea 16: `brew install --cask ghostty` → `core::install ghostty`)
  - `zsh/modules/aliases/internal/eza.zsh` (línea 10: `brew install eza` → `core::install eza`)
  - `zsh/core/config/env.zsh` (línea 6: actualizar mensaje `CORE_MESSAGE_BREW`)
- **Spec afectado**: `openspec/specs/core-messages/spec.md` (actualizar escenario que refiere a `zsh/modules/brew`)
