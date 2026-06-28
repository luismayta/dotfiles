## Context

The tmux module bundles tmuxinator project templates under `zsh/modules/tmux/data/sync/tmuxinator/templates/` (default.yml, android.yml, go.yml, etc.). These templates should be usable via `tx::project` → `tmuxinator start <template> <project>`.

Currently:

1. **Templates en subdirectorio incorrecto**: `data/sync/tmuxinator/templates/*.yml` se sincroniza a `~/.config/tmuxinator/templates/*.yml`, pero `tmuxinator start <template>` busca en `~/.config/tmuxinator/<template>.yml` — un nivel arriba.
2. **Sync solo corre en install**: `tmux::sync` se llama desde `tmux::post_install`, que solo corre durante `tmux::internal::tmux::install`. El inicio normal de shell NO ejecuta sync.
3. **Sin convergencia**: Si se editan las templates en el repo, no hay propagación automática a disco.

## Goals / Non-Goals

**Goals:**
- `tmuxinator start <template> <project>` resuelve el archivo de template correctamente (en `~/.config/tmuxinator/`)
- `tmux::sync` copia las templates al lugar correcto
- Backward compatible — templates existentes en `~/.config/tmuxinator/` no se sobrescriben si no han cambiado

**Non-Goals:**
- Sync bidireccional (solo dotfiles → home)
- Gestión de proyectos tmuxinator (solo templates)
- Cambios al flujo de `tx::project` o UI de fzf

## Decisions

| # | Decision | Rationale | Alternatives Considered |
|---|---|---|---|
| 1 | **Mover YAMLs a `data/sync/tmuxinator/`** (sin subdirectorio `templates/`). | La rsync genérica de `data/sync/` → `~/.config/` ya existente pondrá los archivos directamente en `~/.config/tmuxinator/`. Cero cambios en `tmux::sync`. tmuxinator los encuentra sin config extra. | Agregar una rsync específica adicional sería mantener complejidad innecesaria. |
| 2 | **Actualizar `TMUXINATOR_TEMPLATE_PATH`** a `${HOME_CONFIG_PATH}/tmuxinator`. | `tx::internal::list_templates` usa esta variable para listar templates en fzf. Debe apuntar a la nueva ubicación. | Dejarlo como está rompería el listado de templates. |
| 3 | **`tmux::sync` resuelve.** La función ya existe y sincroniza `data/sync/` → `~/.config/`. Con la reestructuración, las templates caen directamente en `~/.config/tmuxinator/`. No se necesita lógica adicional en plugin.zsh. | La función ya existe, ya funciona, solo necesitaba que las templates estén en el path correcto. | Auto-sync en shell init era complejidad innecesaria. |
| 4 | **No se necesita `TMUXINATOR_CONFIG`.** | tmuxinator usa `~/.config/tmuxinator/` por defecto (XDG). No es necesario configurarlo explícitamente — las templates ya estarán ahí. | Setear `TMUXINATOR_CONFIG` es redundante con el default de XDG. |
| 5 | **plugin.zsh sin cambios.** | `tmux::sync` ya es la API pública para sincronizar. plugin.zsh no necesita lógica adicional. | Auto-sync en shell init era complejidad innecesaria para algo que cambia solo en pull/edit del repo. |

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|---|
| **Renombrar `templates/` existente en disco** si el usuario ya tiene `~/.config/tmuxinator/templates/` del sync anterior. | El `git mv` y posterior rsync dejarán el dir `templates/` sin source correspondiente. Si `~/.config/tmuxinator/templates/` persiste en disco, no interfiere. Una limpieza manual única `rm -rf ~/.config/tmuxinator/templates` resuelve. |
| **Costo en startup de shell** por rsync en cada init. | rsync de 9 archivos < 1 KB cada uno es ~5-10ms. Imperceptible. Sin stamp, sin md5sum, sin complejidad. |
