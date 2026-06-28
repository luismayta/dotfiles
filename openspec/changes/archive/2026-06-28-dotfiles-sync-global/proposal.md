## Why

Hoy no hay una forma unificada de sincronizar toda la configuración de los dotfiles. Cada módulo (`ghostty`, `nvim`, `git`, `ssh`, `tmux`, etc.) expone su propia función `::sync`, pero invocarlas requiere conocerlas individualmente y ejecutarlas una por una. Esto hace fácil olvidar sincronizar un módulo después de editar sus archivos `data/`, y no hay retroalimentación consolidada de qué se sincronizó, qué falló o qué cambió.

Una función global `dotfiles::sync` resuelve esto: un solo comando que ejecuta todos los syncs existentes, reporta resultados y da visibilidad del estado completo.

## What Changes

- Nueva función `dotfiles::sync` en `zsh/core/pkg/sync.zsh` que itera sobre todos los módulos que exponen `::sync` y los ejecuta en orden
- Cada módulo sync se ejecuta condicionalmente (solo si está habilitado vía `ZSH_<MODULE>_ENABLED`)
- Reporte consolidado al final: módulo por módulo, con estado (✓ éxito / ✗ error / - saltado)
- El orden de ejecución respeta dependencias implícitas (ej. git antes que ssh, terminales agrupados)
- No se modifican las funciones `::sync` existentes de cada módulo
- Se registran los módulos sync elegibles de forma declarativa (no autodetección)

## Capabilities

### New Capabilities
- `global-sync`: Orquestación unificada que ejecuta todas las funciones `::sync` de los módulos habilitados, con orden definido, ejecución condicional y reporte de resultados.

### Modified Capabilities

*(none — no existing specs change)*

## Impact

- Nuevo archivo `zsh/core/pkg/sync.zsh` con la función `dotfiles::sync` y el plan de sync
- Se añade `source "${DOTFILES_CORE_PATH}"/pkg/sync.zsh` a `zsh/core/pkg/main.zsh`
- No se crea un nuevo módulo — la orquestación vive en `zsh/core/`
- Cada módulo sync existente se invoca pero no se modifica
- Sin cambios en `data/`, configs, packages, o dependencias externas
