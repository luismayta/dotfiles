## Why

El módulo `brew` contiene código muerto para Linuxbrew (Homebrew en Linux) que ya no se utiliza. Linuxbrew paths (`/home/linuxbrew/.linuxbrew`), la función `brew::install::linux`, y el dispatch condicional para Linux son dead code que añade complejidad sin beneficio.

## What Changes

- Eliminar `brew::load` de `pkg/base.zsh` (solo cargaba paths de Linuxbrew)
- Eliminar `brew::install::linux` de `internal/base.zsh`
- Eliminar el dispatch `linux*)` de `brew::install` y `brew::post_install`
- Eliminar `internal/linux.zsh` y el dispatch `linux*)` de `internal/main.zsh`
- Quitar requisitos de Linuxbrew del spec `brew/spec.md`

## Capabilities

### New Capabilities
- *(ninguna)*

### Modified Capabilities
- `brew`: Eliminar toda funcionalidad de Linuxbrew, mantener solo macOS

## Impact

- `zsh/modules/brew/pkg/base.zsh`: eliminar `brew::load` (líneas 2-50), mantener auto-install guard
- `zsh/modules/brew/internal/base.zsh`: eliminar `brew::install::linux` y ramas `linux*` en `brew::install` y `brew::post_install`
- `zsh/modules/brew/internal/main.zsh`: eliminar `linux*)` case
- `zsh/modules/brew/internal/linux.zsh`: eliminar archivo
- `zsh/zshenv`: remover PATH de `~/.linuxbrew/bin`
- `openspec/specs/brew/spec.md`: remover requisitos de Linuxbrew y `brew::load`
