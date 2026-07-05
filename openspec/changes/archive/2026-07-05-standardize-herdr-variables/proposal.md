## Why

Las variables de entorno del módulo herdr tienen un prefijo inconsistente: algunas usan `HERDR_*` (sin namespace), otras `ZSH_HRD_*` (abreviación incorrecta), y otras `ZSH_HERDR_*` (formato correcto). Esto genera confusión, dificulta el mantenimiento, y rompe la convención de naming establecida en el resto de módulos de dotfiles (`ZSH_<MODULE>_*`).

## What Changes

- Renombrar `HERDR_PACKAGE_NAME` → `ZSH_HERDR_PACKAGE_NAME`
- Renombrar `HERDR_INSTALL_URL` → `ZSH_HERDR_INSTALL_URL`
- Renombrar `HERDR_WORKSPACE_PREFIX` → `ZSH_HERDR_WORKSPACE_PREFIX`
- Renombrar `ZSH_HRD_PROJECT_TEMPLATE_PATH` → `ZSH_HERDR_PROJECT_TEMPLATE_PATH`
- Renombrar `HERDR_CLIPBOARD_COPY_CMD` → `ZSH_HERDR_CLIPBOARD_COPY_CMD`
- Renombrar `HERDR_CLIPBOARD_PASTE_CMD` → `ZSH_HERDR_CLIPBOARD_PASTE_CMD`
- Actualizar todas las referencias internas en `config/`, `internal/`, `pkg/`, y `plugin.zsh`

## Capabilities

### New Capabilities
- `variable-rename`: rename plan and migration of all HERDR_* / ZSH_HRD_* variables to ZSH_HERDR_*

### Modified Capabilities
- (ninguna — es rename interno, no hay cambio en requirements de specs existentes)

## Impact

- **8 archivos** del módulo herdr: `config/base.zsh`, `config/linux.zsh`, `config/osx.zsh`, `internal/base.zsh`, `pkg/base.zsh`, `pkg/helper.zsh`, `plugin.zsh`
- **0 archivos externos** al módulo (las variables no se referencian fuera de `zsh/modules/herdr/`)
- **Sin breaking changes** para el usuario: son variables internas del módulo, no expuestas al usuario final
