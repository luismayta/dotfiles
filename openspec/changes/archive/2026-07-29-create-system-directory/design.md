## Context

Actualmente la carga en `zshrc` ocurre así:

1. `detect/terminal.zsh`
2. **`core/main.zsh`** (desde `zsh/core/`)
3. `.customrc`
4. **Loop de módulos** `zsh/modules/*/plugin.zsh` (40 módulos, incluyendo nix y nix-darwin)
5. antidote, setopt, compinit

El problema: `nix` y `nix-darwin` son módulos de sistema fundamentales (gestor de paquetes, integración macOS) pero se cargan en el mismo loop genérico que módulos de aplicación como `starship`, `tmux` o `ai`. No hay una fase intermedia para módulos de sistema antes de los módulos regulares.

## Goals / Non-Goals

**Goals:**
- Crear `zsh/system/` como contenedor para módulos de sistema de carga prioritaria
- Mover `zsh/core/` → `zsh/system/core/`
- Mover `zsh/modules/nix/` → `zsh/system/nix/`
- Mover `zsh/modules/nix-darwin/` → `zsh/system/nix-darwin/`
- Actualizar `zshrc` para cargar `zsh/system/` entre detect y modules
- Actualizar `DOTFILES_CORE_PATH` y referencias cruzadas
- Mantener compatibilidad total hacia atrás en APIs públicas

**Non-Goals:**
- No se modifica la estructura interna de los módulos (sus archivos config/internal/pkg quedan igual)
- No se modifica el comportamiento de las funciones públicas
- No se mueven otros módulos a system/ (solo core, nix, nix-darwin)
- No se cambia el mecanismo de feature flags (`ZSH_*_ENABLED`)

## Decisions

### Decisión 1: `zsh/system/` como directorio plano (no anidado)
- Los módulos van directamente en `zsh/system/` → `system/core/`, `system/nix/`, `system/nix-darwin/`
- Alternativa descartada: `zsh/system/modules/` con subdirectorios — añade nesting innecesario
- Razón: `zsh/modules/` ya existe para módulos regulares; `zsh/system/` es el paralelo simple para módulos de sistema

### Decisión 2: Carga de system previa a modules en zshrc
- Nuevo orden en `zshrc`:
  1. `detect/terminal.zsh`
  2. **`system/core/main.zsh`** (antes `core/main.zsh`)
  3. **`system/*/plugin.zsh`** (nix, nix-darwin — nuevo paso)
  4. `.customrc`
  5. `modules/*/plugin.zsh`
  6. antidote, setopt, compinit
- `core/` se carga primero (como ahora), luego los demás módulos system en orden alfabético

### Decisión 3: `DOTFILES_CORE_PATH` apunta a `zsh/system/core/`
- La variable `DOTFILES_CORE_PATH` cambia de `${DOTFILES_ZSH_DIR}/core` a `${DOTFILES_ZSH_DIR}/system/core`
- Se exporta `DOTFILES_SYSTEM_PATH="${DOTFILES_ZSH_DIR}/system"` para que otros módulos system puedan auto-referenciarse

### Decisión 4: Mover archivos con git mv (historial preservado)
- Usar `git mv` para cada directorio para mantener el historial de commits
- `zsh/modules/nix/` → `zsh/system/nix/`
- `zsh/modules/nix-darwin/` → `zsh/system/nix-darwin/`
- `zsh/core/` → `zsh/system/core/`

## Referencias descubiertas vía grep

### Rutas fijas que requieren actualización

| Archivo | Línea | Referencia actual |
|---------|-------|-------------------|
| `zsh/zshrc` | 14 | `DOTFILES_CORE_PATH="${DOTFILES_ZSH_DIR}/core"` |
| `zsh/core/config/paths.zsh` | 9 | `DOTFILES_CORE_PATH="${DOTFILES_ZSH_DIR}/core"` |
| `zsh/core/config/env.zsh` | 11 | `CORE_MESSAGE_NIX` menciona `zsh/modules/nix` |
| `Taskfile.yml` | 101, 103 | Includes `./zsh/modules/nix/Taskfile.yml` y `nix-darwin` |
| `docs/guides/implement-tool-in-module.md` | múltiples | Referencias a `zsh/core/` |
| `docs/guides/create-module.md` | múltiples | Referencias a `zsh/core/` |
| `openspec/specs/shared-paths/spec.md` | 24-25 | `DOTFILES_CORE_DIR` apunta a `core/` |
| `openspec/specs/zshrc-load/spec.md` | 8-9 | `DOTFILES_CORE_DIR="${DOTFILES_ZSH_DIR}/core"` |

### Auto-resueltas (no requieren cambio)

Todas las referencias dentro de `zsh/core/` que usan `"${DOTFILES_CORE_PATH}"` resuelven automáticamente al actualizar la variable en `paths.zsh`. Igual `CORE_PATH="$(dirname "${0}")"` en `main.zsh` — auto-resuelve tras `git mv`.

### Excluidas (históricas/archivo — no se modifican)

- `.codi/build/*.json` — planes de commit históricos
- `graphify-out/` — se regenera con `graphify update .`
- `openspec/changes/archive/` — propuestas archivadas, quedan como referencia
- `openspec/changes/create-system-directory/` — la propuesta actual, ya actualizada

## Risks / Trade-offs

- **[Riesgo] Referencias hardcodeadas a `zsh/core/`**: Mapeadas y catalogadas en la tabla de arriba. Mitigación: actualizar solo archivos activos, ignorar históricos.
- **[Riesgo] `DOTFILES_CORE_PATH` usada en otros archivos**: La variable se actualiza en `paths.zsh`; todos los que la referencian resuelven automáticamente.
- **[Trade-off] Mayor profundidad de directorio**: `zsh/system/core/` es más anidado que `zsh/core/`, pero la claridad semántica lo justifica.
- **[Riesgo] Módulos nix referencian `zsh/modules/nix/` internamente**: `ZSH_NIX_PATH="$(dirname "${0}")"` es relativo, se auto-resuelve. No debería romper.
- **[No-riesgo] Archivos históricos**: `.codi/build/`, `graphify-out/`, `openspec/changes/archive/` — no se modifican.

## Migration Plan

1. `git mv zsh/core/ zsh/system/core/`
2. `git mv zsh/modules/nix/ zsh/system/nix/`
3. `git mv zsh/modules/nix-darwin/ zsh/system/nix-darwin/`
4. Actualizar `DOTFILES_CORE_PATH` en `zsh/zshrc` y `zsh/system/core/config/paths.zsh`
5. Agregar `DOTFILES_SYSTEM_DIR="${DOTFILES_ZSH_DIR}/system"` en `zshrc`
6. Agregar loop de carga de `$DOTFILES_SYSTEM_DIR/*/plugin.zsh` en `zshrc` (excluyendo core)
7. Actualizar `zsh/core/config/env.zsh` — cambiar `CORE_MESSAGE_NIX` a nueva ruta
8. Actualizar `Taskfile.yml` — cambiar includes a `zsh/system/nix/` y `zsh/system/nix-darwin/`
9. Actualizar `docs/guides/*.md` — referencias a `zsh/core/`
10. Actualizar `openspec/specs/*/spec.md` activos (shared-paths, zshrc-load)
11. Validar con `task validate` y shellcheck
12. `graphify update .` para refrescar el grafo de conocimiento
13. Rollback: `git mv` inverso + revertir cambios en archivos
