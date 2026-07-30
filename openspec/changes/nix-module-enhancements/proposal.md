## Why

El módulo Nix (`zsh/modules/nix/`) no gestiona automáticamente la configuración del sistema (`nix.conf`), dejando que el usuario la copie manualmente. Esto causó que `nix develop` fallara hasta que se creó `~/.config/nix/nix.conf` a mano. Además, el módulo tiene código redundante, placeholders vacíos, y varias mejoras de calidad identificadas durante la revisión.

## What Changes

- **Sync automático de `nix.conf`**: Copiar `nix/nix.conf` a `~/.config/nix/nix.conf` desde el módulo, tanto en Linux como en macOS
- **Eliminar `--extra-experimental-features` inline** de `pkg/base.zsh` — ahora que `nix.conf` lo define, es redundante
- **Agregar validación de resultado** en `core::nix::ensure` — si la instalación falla, mostrar error y no continuar silenciosamente
- **`nix::gc()` con salvaguarda**: agregar confirmación antes de ejecutar `nix-collect-garbage -d`
- **`rsync --quiet`**: cambiar `--progress` por `--quiet` en `nix::internal::config::sync` para sync silencioso automático
- **Poblar template base `flake.nix`**: agregar un `devShells.default` mínimo para que `nix develop` funcione out-of-the-box
- **Limpiar o poblar placeholders vacíos**: 7 archivos solo con comentarios sin lógica real

## Capabilities

### New Capabilities
- `nix-conf-sync`: Sincronización automática de `nix/nix.conf` a `~/.config/nix/nix.conf` al cargar el módulo
- `nix-scaffold-base`: Template base funcional con `devShells.default` mínimo para `flake.nix` genérico

### Modified Capabilities
- `nix-core-api`: Mejoras en `core::nix::ensure` (validación de resultado), `nix::gc()` (confirmación)
- `nix-module-internal`: Sync interno con `--quiet`, limpieza de placeholders OS-específicos
- `nix-pkg-api`: Eliminar redundancia de `--extra-experimental-features` en `nix::build()` y `nix::develop()`

## Impact

- **Archivos afectados**:
  - `zsh/core/internal/nix.zsh` — validación post-instalación
  - `zsh/core/pkg/nix.zsh` — sin cambios (API pública se mantiene)
  - `zsh/modules/nix/config/linux.zsh` — lógica de sync de nix.conf para Linux
  - `zsh/modules/nix/config/base.zsh` — ruta de nix.conf
  - `zsh/modules/nix/internal/base.zsh` — `--progress` → `--quiet`
  - `zsh/modules/nix/pkg/base.zsh` — quitar `--extra-experimental-features`, agregar confirmación a gc
  - `zsh/modules/nix/data/templates/flake.nix` — agregar devShells.default
  - `zsh/modules/nix/config/osx.zsh`, `pkg/linux.zsh`, `pkg/osx.zsh`, `internal/linux.zsh`, `internal/osx.zsh`, `pkg/helper.zsh` — evaluar si eliminar o poblar
- **Sin breaking changes**: todas las APIs públicas se mantienen compatibles
