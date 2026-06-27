## Context

Cada módulo bajo `zsh/modules/<name>/` tiene una estructura consistente:

```
plugin.zsh
├── config/
│   ├── main.zsh    → sourcea base.zsh + dispatch por OSTYPE a osx.zsh/linux.zsh
│   ├── base.zsh    → variables base del módulo
│   ├── osx.zsh     → config específica macOS
│   └── linux.zsh   → config específica Linux
├── internal/
│   └── main.zsh
└── pkg/
    └── main.zsh
```

El `plugin.zsh` es el punto de entrada: sourcea `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`.

Actualmente, el dispatch por plataforma solo existe *dentro* de cada subcapa (vía `case "${OSTYPE}"`), pero el módulo siempre se carga completo — aunque todo lo que haga en macOS sean no-ops.

## Goals / Non-Goals

**Goals:**
- Cada módulo puede declarar si está habilitado para la plataforma actual
- El mecanismo usa la arquitectura existente (cascade base.zsh → osx.zsh/linux.zsh)
- Zero cambios al loader en `zsh/zshrc`
- Override por usuario desde `~/.customrc` sin tocar el repo
- Patrón uniforme para los 30 módulos

**Non-Goals:**
- Modificar el loader o el loop de módulos
- Añadir dependencias externas
- Cambiar el dispatch interno de cada módulo (el `case $OSTYPE` sigue igual)

## Decisions

### Decision 1: Variable en config, no header ni archivo separado

**Chosen:** `ZSH_<MODULE>_ENABLED` seteada en `config/base.zsh` con override en `config/osx.zsh` o `config/linux.zsh`.

```
base.zsh   →  ZSH_<MODULE>_ENABLED=true        (default)
osx.zsh    →  ZSH_<MODULE>_ENABLED=false       (override si no aplica en macOS)
linux.zsh  →  ZSH_<MODULE>_ENABLED=false       (override si no aplica en Linux)
plugin.zsh →  $ZSH_<MODULE>_ENABLED || return  (guard después de source config)
```

Alternativas descartadas:
- **Header `# Platform:`**: Requiere leer el archivo sin sourcearlo + modificar loader
- **Archivo `.platforms` centralizado**: Un archivo más que mantener, separado de la lógica
- **Modificar loader**: Más complejo, toca el core, riesgo de regresión

### Decision 2: Guard en plugin.zsh, no en config

El guard va en `plugin.zsh` *después* de sourcear `config/main.zsh`, no dentro del config. Razón: si el return estuviera dentro de `config/main.zsh`, el source en `plugin.zsh` capturaría el return code pero las líneas siguientes (message_info, otros sources) igual se ejecutarían. Al ponerlo en `plugin.zsh`, el return corta todo el módulo de una.

### Decision 3: El override de usuario es directo

El usuario puede pre-setear `ZSH_<MODULE>_ENABLED` en `~/.customrc` y el config respeta ese valor si ya existe:

```zsh
# ~/.customrc
export ZSH_HYPRLAND_ENABLED=true   # forzar hyprland en macOS
```

El config base usa `${ZSH_HYPRLAND_ENABLED:-true}` para no pisar el override.

## Cascade pattern

```
~/.customrc                          (opcional: override de usuario)
    ↓
config/base.zsh                      ZSH_<MODULE>_ENABLED=true  (si no existe)
    ↓
config/main.zsh → dispatch OSTYPE
    ├── osx.zsh                      ZSH_<MODULE>_ENABLED=false (override si no aplica)
    └── linux.zsh                    (no toca, hereda de base)
    ↓
plugin.zsh                           $ZSH_<MODULE>_ENABLED || return
```

## Before / After

### hyprland (Linux-only)

**Before:**
```zsh
# config/base.zsh
export HYPRLAND_PACKAGE_NAME=hyprland

# config/osx.zsh
# (no-op vacío)

# plugin.zsh
source "${HYPRLAND_PATH}/config/main.zsh"   # → sourcea osx.zsh que no hace nada
source "${HYPRLAND_PATH}/internal/main.zsh"  # → todo no-op
source "${HYPRLAND_PATH}/pkg/main.zsh"      # → todo no-op
message_info "Loading module: hyprland"      # → miente
```

**After:**
```zsh
# config/base.zsh
ZSH_HYPRLAND_ENABLED=true
export HYPRLAND_PACKAGE_NAME=hyprland

# config/osx.zsh
ZSH_HYPRLAND_ENABLED=false

# plugin.zsh
source "${HYPRLAND_PATH}/config/main.zsh"
$ZSH_HYPRLAND_ENABLED || return               # ← sale acá en macOS
source "${HYPRLAND_PATH}/internal/main.zsh"
source "${HYPRLAND_PATH}/pkg/main.zsh"
```

### git (cross-platform — no changes needed beyond convention)

```zsh
# config/base.zsh (solo añadir la línea)
ZSH_GIT_ENABLED=true
# ... resto igual

# plugin.zsh (solo añadir el guard)
source "${ZSH_GIT_PATH}/config/main.zsh"
$ZSH_GIT_ENABLED || return
# ... resto igual
```

## Risks / Trade-offs

- **[Consistency]** 30 módulos, 30 variables distintas. Riesgo bajo — el naming sigue el patrón `ZSH_<MODULE>_ENABLED` donde `<MODULE>` es el nombre del módulo en MAYÚSCULAS.
- **[Override]** Si el usuario define la variable después de cargar los módulos, no tendrá efecto. Se documenta que debe ir en `~/.customrc` (que se sourcea antes que los módulos).
- **[Ruido]** El guard es boilerplate. Beneficio: es explícito, legible, y el override granular es trivial.
