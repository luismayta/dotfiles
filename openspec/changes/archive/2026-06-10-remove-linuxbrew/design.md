## Context

El módulo `zsh/modules/brew/` fue migrado desde `luismayta/zsh-brew` y soporta Homebrew en macOS y Linuxbrew en Linux. El usuario ya no usa Linuxbrew, por lo que todo el código de Linuxbrew es dead code.

Archivos afectados:
- `pkg/base.zsh` (56 líneas) — `brew::load` entero es solo Linuxbrew paths
- `internal/base.zsh` (64 líneas) — `brew::install::linux`, ramas `linux*` en `brew::install` y `brew::post_install`
- `internal/main.zsh` (14 líneas) — dispatch `linux*` a `linux.zsh`
- `internal/linux.zsh` (2 líneas) — stub vacío "currently unused"

El flujo actual en `pkg/base.zsh`: `brew::load` se invoca automáticamente al sourcear el módulo. Si brew no está en PATH, ejecuta `brew::install` + `brew::post_install`. Tras la limpieza, `brew::load` desaparece y el auto-install solo aplica a macOS.

## Goals / Non-Goals

**Goals:**
- Remover todo rastro de Linuxbrew del módulo `brew`
- Mantener funcionalidad macOS intacta
- Simplificar el dispatch OS a solo `darwin*`

**Non-Goals:**
- Refactor o reestructuración del módulo brew
- Cambiar el mecanismo de auto-install en macOS
- Tocar otros módulos o el core system

## Decisions

### D1: Eliminar brew::load completo vs mantener stub
- **Opción A** (elegida): Eliminar `brew::load` por completo — solo cargaba paths de Linuxbrew.
- **Opción B**: Mantener stub vacío por backward compat. Innecesario — nadie llama `brew::load` externamente.
- **Razón**: La función solo existe para exportar variables de Linuxbrew. Sin Linuxbrew, la función no tiene propósito.

### D2: Eliminar linux.zsh y dispatch en internal/main.zsh
- **Decisión**: Eliminar archivo `internal/linux.zsh` y el case `linux*)` en `internal/main.zsh`.
- `internal/osx.zsh` se sigue sourceando en macOS.
- `internal/base.zsh` se sourcea siempre (contiene funciones genéricas y macOS).

## Risks / Trade-offs

- **[Bajo]**: Si alguien más usara Linuxbrew en este dotfiles, se rompería. **Mitigación**: El dueño del repo confirmó que no usa Linuxbrew. Es dead code seguro.
- **[Ninguno]**: macOS Homebrew no se ve afectado — `brew::install::osx`, `brew::post_install` macOS, y el guard de auto-install se mantienen intactos.