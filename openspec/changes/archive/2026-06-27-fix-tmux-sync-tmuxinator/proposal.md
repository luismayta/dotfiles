## Why

`tmux::sync` copia las templates de `data/sync/tmuxinator/templates/` a `~/.config/tmuxinator/templates/`, pero `tmuxinator start <template>` busca las templates directamente en `~/.config/tmuxinator/`. Las templates quedan en un subdirectorio (`templates/`) que tmuxinator nunca lee, por lo que los cambios nunca toman efecto. Además, `tmux::sync` solo corre durante la instalación inicial de tmux (`tmux::post_install`), haciendo imposible propagar cambios a las templates sin conocer el comando interno.

## What Changes

- **Reestructurar `data/sync/tmuxinator/`**: Mover los archivos `*.yml` de `data/sync/tmuxinator/templates/` a `data/sync/tmuxinator/` directamente, y eliminar el subdirectorio `templates/` vacío.
- **Actualizar `TMUXINATOR_TEMPLATE_PATH`**: Cambiar de `~/.config/tmuxinator/templates` a `~/.config/tmuxinator/` para que coincida con la nueva ubicación.
- **`tmux::sync`**: La rsync existente de `data/sync/` → `~/.config/` ya pondrá las templates en `~/.config/tmuxinator/*.yml` automáticamente, donde tmuxinator las encuentra. No se necesitan rsyncs adicionales.
- **`tmux::sync` se encarga**: La función ya existe y sincroniza `data/sync/` completo. Con la reestructuración, las templates caen en el lugar correcto. El usuario corre `tmux::sync` cuando necesite propagar cambios.

## Capabilities

### New Capabilities
- `tmuxinator-template-sync`: Ensure tmuxinator templates bundled in the dotfiles repo are reliably synced to the correct tmuxinator config directory, both on install and on shell init when templates change.

### Modified Capabilities
*(None — implementation fix within the tmux module.)*

## Impact

- **Files affected:**
  - `zsh/modules/tmux/data/sync/tmuxinator/templates/*.yml` → moved up to `zsh/modules/tmux/data/sync/tmuxinator/*.yml`
  - `zsh/modules/tmux/config/base.zsh` — update `TMUXINATOR_TEMPLATE_PATH`
  - `zsh/modules/tmux/pkg/base.zsh` — `tmux::sync` unchanged (rsync rutea existente cubre el nuevo path)
- **Runtime**: Sin cambio en startup de shell. `tmux::sync` solo corre cuando el usuario lo invoca.
- **Backward compatibility**: `TMUXINATOR_TEMPLATE_PATH` cambia, pero solo lo usa `tx::internal::list_templates` que se actualizará en este mismo cambio.
