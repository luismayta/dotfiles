## 1. Core — Validación de instalación ✅

- [x] 1.1 Modificar `zsh/core/internal/nix.zsh` para que `core::internal::nix::install` retorne 1 si la instalación falla
- [x] 1.2 Agregar verificación post-instalación — después del script oficial, validar con `core::internal::nix::exists`
- [x] 1.3 Modificar `core::nix::ensure` en `zsh/core/pkg/nix.zsh` para mostrar `message_error` si `install` falla y retornar 1

## 2. Sync automático de nix.conf ✅

- [x] 2.1 Variables `NIX_CONF_SOURCE`, `NIX_CONF_DIR`, `NIX_CONF_TARGET` en `config/linux.zsh` usando `${DOTFILES}`
- [x] 2.2 Función `nix::internal::sync::nix_conf` en `internal/linux.zsh` con `rsync -avzh --quiet`
- [x] 2.3 Auto-ejecución al cargar el módulo (llamada al final de `internal/linux.zsh`)
- [x] 2.4 Skip automático en macOS (no se toca, `internal/main.zsh` solo sourcea `internal/linux.zsh` en Linux)

## 3. Sync de direnvrc — rsync silencioso ✅

- [x] 3.1 Cambiar `rsync -avzh --progress` por `rsync -avzh --quiet` en `nix::internal::config::sync`

## 4. Eliminar redundancia de `--extra-experimental-features` ✅

- [x] 4.1 Quitar flag inline de `nix::build()`
- [x] 4.2 Quitar flag inline de `nix::develop()`
- [x] 4.3 Quitar flag inline de `nix::internal::direnv::setup()`

## 5. Seguridad en nix::gc ✅

- [x] 5.1 Agregar confirmación interactiva con `message_info`/`message_warning`/`read` + validación

## 6. Template base funcional ✅

- [x] 6.1 `flake.nix` genérico con `devShells.default` usando `pkgs.mkShell { packages = []; }`

## 7. Verificación final ✅

- [x] 7.1 `task validate` — 24 checks passed
- [x] 7.2 `nix develop` — exit 0 sin errors
- [x] 7.3 `~/.config/nix/nix.conf` sincronizado correctamente
- [x] 7.4 `data/sync/` rsync funcionando con `--quiet`
