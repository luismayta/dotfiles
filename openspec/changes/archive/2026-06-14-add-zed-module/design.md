## Context

El módulo de Zed Editor actualmente existe como repositorio independiente `zsh-zed` con su propia estructura de archivos y patrón de diseño. Los dotfiles ya cuentan con un ecosistema de módulos estandarizados (`goenv`, `pyenv`, `fnm`, `docker`, etc.) que siguen una arquitectura consistente de 3 capas con dispatch por SO. Además, `zsh/core/` provee funciones compartidas que todos los módulos deben reutilizar.

El repositorio `zsh-zed` tiene 4 capas (`config/` → `core/` → `internal/` → `pkg/`) y usa un patrón factory auto-invocado. El target (`goenv`) usa 3 capas (`config/` → `internal/` → `pkg/`) con sourcing directo.

## Core Reuse

El módulo `zsh/core/` ya provee todo el esqueleto que el módulo zed necesita — no reinventamos nada:

| Función de core | Uso en el módulo zed |
|----------------|----------------------|
| `core::exists <bin>` | Verificar si `zed`, `curl`, `rsync` existen en PATH |
| `core::ensure <bin>` | Asegurar que `curl` esté instalado antes de install |
| `message_info / message_success / message_error / message_warning` | Todos los mensajes al usuario |
| `core::install <pkg>` | Instalar dependencias del sistema si faltan |

## Goals / Non-Goals

**Goals:**
- Migrar la funcionalidad del plugin Zed Editor a `zsh/modules/zed/`
- Alinear la arquitectura al patrón del módulo `goenv` (3 capas, sourcing directo, guard idempotente)
- Preservar: instalación, symlink de configuración, detección de existencia, setup completo
- Incluir los archivos de configuración del editor (`settings.jsonc`, `keymap.jsonc`) como recursos del módulo
- Reutilizar funciones de `zsh/core/` en lugar de duplicar lógica

**Non-Goals:**
- No modificar la funcionalidad existente del plugin
- No cambiar el formato o contenido de los archivos de configuración de Zed
- No migrar skills, configuraciones de OpenCode/Claude u otros archivos de desarrollo del repositorio `zsh-zed`
- No eliminar el repositorio `zsh-zed` original (eso se decide después)
- No agregar variables o funciones que no se usan (YAGNI)

## Decisions

| Decisión | Opción Elegida | Alternativa | Razón |
|----------|---------------|-------------|-------|
| Capas del módulo | `config/` → `internal/` → `pkg/` | Mantener `core/` separado | Consistencia con `goenv`; `core/` contenía dispatchers vacíos |
| Patrón de carga | Sourcing directo (como goenv) | Factory auto-invocado | Menos anidamiento, más legible, consistente |
| Guard idempotente | `__ZSH_ZED_LOADED` | Ninguno | Previene doble carga, estándar |
| Archivos de configuración | `resources/` dentro del módulo | `conf/` como en el original | Consistencia con otros módulos |
| OS dispatch | Case sobre `$OSTYPE` (darwin/linux) | Detección por archivo | Mismo patrón que goenv y resto de módulos |
| **Método de sync** | `rsync` vía `zed::sync` (como hyprland) | symlink / copy individual | KISS: un solo método, consistente con `hyprland::sync` |
| **Variables config** | Solo las usadas (`ZED_INSTALL_URL`, `ZED_CONFIG_PATH`, `ZED_SETTINGS_FILE`, `ZED_KEYMAP_FILE`) | Mantener `ZED_MESSAGE_BREW/PYENV/NOT_FOUND` | YAGNI: esas variables nunca se usan |
| **exists wrapper** | Inline `core::exists zed` en helper.zsh | Función separada `zed::internal::exists` | KISS: una línea no necesita wrapper interno |
| **core::ensure** | Para `curl` en internal/main.zsh | Cada función verifica por separado | KISS: un punto de guard |
| **post_install** | `zed::post_install` llama `zed::sync` (como hyprland) | Syncing manual | Consistente con patrón hyprland |

## Risks / Trade-offs

| Riesgo | Mitigación |
|--------|-----------|
| El path `ZSH_ZED_PATH` cambia al moverse a dotfiles | Usar `"$(dirname "${0}")"` que es relativo al archivo — funciona igual en cualquier ubicación |
| Posible conflicto si alguien carga ambos módulos (antiguo + nuevo) | El guard `__ZSH_ZED_LOADED` previene doble carga |
| Los archivos de configuración pueden quedar desactualizados | Migrar el contenido actual; actualizaciones futuras en `resources/` |
