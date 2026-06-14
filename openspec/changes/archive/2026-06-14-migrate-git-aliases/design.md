## Context

Actualmente, `zsh/core/` contiene configuraciones, funciones internas y helpers que son específicos de git pero que están mezclados con la lógica genérica del core. El módulo `zsh/modules/git/` ya existe con su propia estructura (config/, internal/, pkg/, bin/) pero carece de estos elementos.

Los elementos a migrar son:
1. `zsh/core/config/git.zsh` — define `GIT_INTERNAL_GETTEXT_TEST_FALLBACKS`
2. `zsh/core/internal/git.zsh` — define `core::git::get_module_path()`
3. `zsh/core/pkg/helper/core.zsh` — contiene `fcs()` y `fgb()` (funciones git-fzf)

Estos son referenciados desde:
- `zsh/core/config/main.zsh` (source git.zsh)
- `zsh/core/internal/main.zsh` (source internal/git.zsh)
- `zsh/core/internal/backup.zsh` (usa `core::git::get_module_path`)
- `zsh/core/pkg/helper/main.zsh` (source core.zsh)

## Goals / Non-Goals

**Goals:**
- Migrar toda la lógica específica de git desde `zsh/core/` a `zsh/modules/git/`
- Mantener compatibilidad total con los consumers existentes (backup, core)
- Usar el namespace `git::` consistente con el resto del módulo git
- Preservar la funcionalidad exacta (sin cambios de comportamiento)

**Non-Goals:**
- No cambiar la lógica de negocio de las funciones migradas
- No refactorizar el módulo git existente más allá de añadir los nuevos archivos
- No modificar la interfaz pública de las funciones `fcs`/`fgb` (siguen siendo comandos de usuario)

## Decisions

### Decisión 1: Namespace naming para funciones migradas

**Opción elegida:** Usar `git::internal::get_module_path` para la función de git internal (consistente con `git::internal::git::branch::name`, etc. ya existentes en `zsh/modules/git/internal/base.zsh`).

**Alternativa considerada:** Mantener `core::git::get_module_path`. Se descarta porque rompe el principio de que el módulo git debe ser autónomo y no depender del namespace `core::`.

### Decisión 2: Archivo destino para `get_module_path`

**Opción elegida:** Crear `zsh/modules/git/internal/get-module-path.zsh` como archivo independiente (no mezclar con `base.zsh` que ya tiene 136 líneas).

**Alternativa considerada:** Añadirlo a `base.zsh`. Se descarta para mantener cohesión y evitar archivos monolíticos.

### Decisión 3: Archivo destino para `fcs()` y `fgb()`

**Opción elegida:** Crear `zsh/modules/git/pkg/fzf.zsh` como archivo dedicado para helpers de fzf+git.

**Alternativa considerada:** Añadirlas a `zsh/modules/git/pkg/alias.zsh`. Se descarta porque no son aliases sino funciones.

### Decisión 4: Mantener nombres de funciones públicas (`fcs`, `fgb`)

**Opción elegida:** Las funciones `fcs` y `fgb` mantienen su nombre actual (son comandos de usuario cortos, sin namespace). No se renombran a `git::fzf::commit` o similar.

**Razonamiento:** Son comandos interactivos invocados por el usuario, no funciones de API interna. El estándar en la dotfiles es usar nombres cortos para estos helpers (ver `fkill`, `fa`, `fo`, `fgr` en el mismo archivo).

### Decisión 5: Cómo manejar `core-backup` dependency

**Opción elegida:** Actualizar `zsh/core/internal/backup.zsh` para llamar a `git::internal::get_module_path` en lugar de `core::git::get_module_path`. Como el módulo git se carga antes que el backup (por orden de carga de módulos en zshrc), la función estará disponible.

**Razonamiento:** No duplicar la función. La función es puramente de git y debe vivir en el módulo git.

## Risks / Trade-offs

- **Riesgo: Orden de carga** → El módulo git debe cargarse antes que el core llame a backup. En la arquitectura actual los módulos se cargan después del core, pero backup es una función lazy (no se ejecuta al cargar el shell), así que no hay problema.
- **Riesgo: Breaking change si alguien importa `core::git::get_module_path`** → Mitigación: mantener un alias/wrapper temporal o documentar la migración.
- **Trade-off: `fcs`/`fgb` se separan de los otros fzf helpers** → Aceptable porque pertenecen conceptualmente a git, no al core.
