## Context

El módulo `zsh/modules/brew/` fue portado de `hadenlabs/zsh-brew` a la estructura monorepo, pero desde entonces la plataforma de instalación ha evolucionado:

1. **`core::install`** (en `zsh/core/pkg/base.zsh`) es el mecanismo estándar — delega en `core::internal::core::install` que en macOS ejecuta `brew install` y en Linux usa `apt`/`pacman`. Esto unifica instalación multiplataforma.

2. **Los módulos ya usan `core::install` extensivamente** (~36 llamadas en 23 archivos). El módulo brew quedó como un outlier que implementa su propio flujo de instalación y post-instalación.

3. **4 módulos aún usan `brew install` directo** en vez de `core::install`, haciéndolos no-portables.

## Goals / Non-Goals

**Goals:**
- Eliminar `zsh/modules/brew/` completamente
- Migrar los 4 `brew install` directos a `core::install`
- Actualizar `CORE_MESSAGE_BREW` para que no referencie un módulo eliminado

**Non-Goals:**
- No cambiar la funcionalidad de `core::install` ni su implementación
- No modificar módulos que ya usan `core::install` correctamente
- No eliminar `CORE_MESSAGE_BREW` — sigue siendo útil como mensaje cuando brew no está instalado

## Decisions

| Decisión | Racional |
|---|---|
| `brew install` → `core::install` directo | `core::install` ya maneja el check de existencia de brew internamente y funciona en cualquier plataforma. No necesita wrapper adicional. |
| Eliminar brew module sin deprecación | Solo `CORE_MESSAGE_BREW` lo referenciaba externamente (en un string literal, no como dependencia funcional). Ningún módulo hace `source` del brew module. |
| `brew install --cask ghostty` → `core::install ghostty` | `core::install` pasa los argumentos directamente a `brew install`. `--cask` ya no es necesario en Homebrew moderno (los casks se instalan directamente con `brew install`). |
| `ghq` case: eliminar `if core::exists brew` | `core::install` ya tiene ese guard interno. El bloque `elif paru` se preserva como fallback para Linux. |

## Risks / Trade-offs

- **[Bajo] Función `brew::post_install` desaparece** — instalaba `gcc`, `jq`, `the_silver_searcher`, `tree`. `core::install`/`core::ensure` ya cubre estos paquetes cuando son necesarios (ej: `core/pkg/helper/core.zsh` ya instala `the_silver_searcher`). Los paquetes no referenciados se pierden — pero son dead code (nadie requiere `gcc` o `tree` explícitamente).

- **[Muy bajo] Mensaje `CORE_MESSAGE_BREW` actualizado** — Cambia de "use the brew module at zsh/modules/brew" a "use core::install". 4 consumidores usan esta variable, solo se actualiza el texto.

- **[Ninguno] Eliminación del módulo brew** — Ningún otro módulo importa `brew::*` funciones. Es completamente independiente.