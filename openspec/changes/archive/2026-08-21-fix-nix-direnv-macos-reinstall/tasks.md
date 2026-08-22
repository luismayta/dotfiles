## 1. Módulo nix — dejar de auto-instalar nix-direnv

- [x] 1.1 `zsh/system/nix/internal/direnv.zsh`: eliminar la invocación de `nix::direnv::internal::main::factory` al cargar (y la definición de la factory si queda sin uso); conservar `sync`.
- [x] 1.2 `zsh/system/nix/pkg/direnv.zsh`: corregir `nix::direnv::install` — eliminar la llamada a `nix::direnv::internal::enable` (inexistente) y delegar la instalación en `devops::direnv::install`.

## 2. Módulo devops — guard correcto y detección de gestión externa

- [x] 2.1 `zsh/modules/devops/internal/direnv.zsh`: cambiar el guard de `main::factory` — verificar disponibilidad del plugin `nix-direnv` (y binario `direnv`) en lugar de solo `core::exists direnv`.
- [x] 2.2 Añadir helper de detección (p. ej. `devops::direnv::internal::is_managed` o inline por plataforma): plugin en profile del usuario + gestión externa vía nix-darwin en macOS (`darwin-rebuild` presente).
- [x] 2.3 `zsh/modules/devops/internal/osx.zsh`: `devops::direnv::internal::install` — no instalar si nix-darwin/home-manager ya gestiona el plugin; si falta el binario `direnv`, instalar también `nixpkgs#direnv`; instalar el plugin solo si falta.
- [x] 2.4 `zsh/modules/devops/internal/linux.zsh`: `devops::direnv::internal::install` — preservar comportamiento actual (guard con `nix profile list`); instalar binario `direnv` + plugin si faltan.

## 3. Verificación

- [ ] 3.1 En macOS: cargar shell y confirmar que NO aparece "Installing nix-direnv" en cargas sucesivas; `nix profile list` sin cambios no deseados.
- [ ] 3.2 En Linux: comportamiento actual preservado (sin reinstalación por shell).
- [x] 3.3 `zsh -n` (syntax check) sobre los archivos modificados y `lsp_diagnostics` sin errores nuevos.

## 4. Detección robusta de Nix y no auto-instalación

- [x] 4.1 `zsh/system/core/internal/nix.zsh`: ampliar `core::internal::nix::exists` — además de `command -v nix`, detectar `/run/current-system/sw/bin/nix` (nix-darwin), `/etc/profiles/per-user/${USER}/bin/nix` (home-manager) y `${HOME}/.nix-profile/bin/nix`.
- [x] 4.2 `zsh/system/nix/internal/base.zsh`: cambiar `nix::internal::nix::install` para que NO lance el instalador automáticamente; debe advertir con el comando de instalación y retornar sin bloquear. Mantener la instalación explícita disponible vía `nix::install` (pkg/base.zsh).
- [x] 4.3 `zsh/modules/devbox/internal/main.zsh`: reemplazar `core::nix::ensure` (auto-instala) por la verificación/advertencia no bloqueante, consistente con la decisión de no auto-instalar Nix al cargar la shell.
- [x] 4.4 Verificar que la carga de shell en macOS sin Nix muestra la advertencia y NO ejecuta el instalador interactivo.
