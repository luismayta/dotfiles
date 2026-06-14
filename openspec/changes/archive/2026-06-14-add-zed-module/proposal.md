## Why

El módulo de Zed Editor actualmente reside como un proyecto standalone en `zsh-zed`, separado del ecosistema de dotfiles. Esto genera duplicación de configuraciones, mantenimiento disperso y una experiencia inconsistente con el resto de módulos (`goenv`, `pyenv`, `fnm`, etc.). Migrarlo a `zsh/modules/zed` unifica la configuración del editor bajo el mismo patrón de módulos, simplifica el mantenimiento y permite que los dotfiles sean autocontenidos.

## What Changes

- Migrar el entry point `zsh-zed.zsh` → `zsh/modules/zed/plugin.zsh` con guard idempotente (`__ZSH_ZED_LOADED`)
- Migrar `config/` → `zsh/modules/zed/config/` (variables de entorno, rutas, URLs de instalación)
- Fusionar `core/` e `internal/` en `zsh/modules/zed/internal/` (alineado al patrón `goenv`)
- Migrar `pkg/` → `zsh/modules/zed/pkg/` (API pública wrapper)
- Migrar `conf/` (settings.jsonc, keymap.jsonc) → `zsh/modules/zed/resources/`
- Eliminar el patrón factory (`zed::config::main::factory`) por sourcing directo (consistente con `goenv`)
- Actualizar cualquier referencia externa al módulo antiguo

## Capabilities

### New Capabilities
- `zed-install`: Instalación del editor Zed mediante script oficial
- `zed-config-sync`: Sincronización de configuración de Zed (symlink/copy/rsync de settings.jsonc y keymap.jsonc)
- `zed-setup`: Setup completo que integra install + config sync

### Modified Capabilities
- Ninguna — es un módulo nuevo que no modifica capacidades existentes

## Impact

- **Files**: Se crea el directorio `zsh/modules/zed/` completo (~16 archivos)
- **Dependencies**: Depende de `core::exists`, `core::ensure`, `message_info`, `message_success`, `message_error` (funciones base de dotfiles ya existentes)
- **Removal**: El proyecto standalone `zsh-zed` queda obsoleto para este propósito
- **No breaking**: No afecta módulos existentes ni cambia APIs públicas
