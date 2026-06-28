## 1. Reestructurar data — Mover templates al directorio raíz de tmuxinator

- [x] 1.1 Mover archivos `*.yml` de `data/sync/tmuxinator/templates/` a `data/sync/tmuxinator/`: `git mv data/sync/tmuxinator/templates/*.yml data/sync/tmuxinator/`
- [x] 1.2 Eliminar el directorio `templates/` vacío: `rmdir data/sync/tmuxinator/templates/`

## 2. Config — Actualizar TMUXINATOR_TEMPLATE_PATH

- [x] 2.1 En `zsh/modules/tmux/config/base.zsh`, cambiar `export TMUXINATOR_TEMPLATE_PATH="${HOME_CONFIG_PATH}/tmuxinator/templates"` a `export TMUXINATOR_TEMPLATE_PATH="${HOME_CONFIG_PATH}/tmuxinator"`

## 3. Verify (sin cambios en plugin.zsh — `tmux::sync` ya es la API)

- [x] 3.1 `TMUXINATOR_TEMPLATE_PATH` apunta a `~/.config/tmuxinator` ✓
- [x] 3.2 Los YAMLs están en `~/.config/tmuxinator/` sin subdirectorio `templates/` ✓
- [x] 3.3 `tmux::sync` propaga templates al path correcto ✓
- [x] 3.4 `tx::internal::list_templates` lista desde la nueva ubicación ✓
