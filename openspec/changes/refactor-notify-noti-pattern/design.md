## Context

El módulo `zsh/modules/notify/` fue implementado rápidamente para integrar noti, pero el código quedó desordenado:

**Estado actual (desordenado):**
- `config/base.zsh` — mezcla env vars, paths, y package name
- `internal/noti.zsh` — tiene config generation + send logic
- `config/linux.zsh` / `config/osx.zsh` — solo definen paths
- Naming inconsistente: `notify::noti::internal::send` vs `notify::noti::config`

**Patrón de referencia (módulo AI):**
- `config/base.zsh` — dispatcher limpio, sources domain files
- `config/<tool>.zsh` — variables del dominio
- `internal/<tool>.zsh` — install + logic functions
- `pkg/<tool>.zsh` — thin wrappers
- Naming: `ai::<tool>::internal::<verb>` → `ai::<tool>::<verb>`

## Goals / Non-Goals

**Goals:**
- Seguir el patrón three-layer del módulo AI
- Separación clara: config (variables) → internal (logic) → pkg (API)
- Naming consistente: `notify::noti::<verb>`
- Install function con guard pattern
- Config sync para noti.yaml

**Non-Goals:**
- Cambiar la funcionalidad existente
- Modificar otros módulos
- Agregar nuevas features

## Decisions

### Decision 1: Seguir patrón AI como referencia

**Razón:** El módulo AI ya está establecido y probado. Seguir su patrón garantiza consistencia en todo el dotfile.

### Decision 2: Config sync via rsync (como AI)

**Razón:** El módulo AI usa `rsync -a` para sincronizar configs. noti debe usar el mismo patrón para `data/noti/noti.yaml`.

### Decision 3: Install function con guard pattern

**Razón:** Todas las funciones install en AI empiezan con `if core::exists X; then return 0; fi`. noti debe seguir el mismo patrón.

## Risks / Trade-offs

- **[Risk]** Breaking change para usuarios existentes → **Mitigation:** Mantener la misma funcionalidad, solo reorganizar código
- **[Trade-off]** Más archivos → **Mitigation:** Mejor separación de responsabilidades

## Migration Plan

1. Crear nuevos archivos (config/noti.zsh, refactorizar internal/noti.zsh)
2. Actualizar main.zsh files para sourcear nuevos archivos
3. Limpiar config/base.zsh
4. Verificar que la funcionalidad no cambia

**Rollback:** Git revert del change.
