## Why

En macOS, cada carga de shell reinstala el plugin `nix-direnv` (mensaje "Installing nix-direnv"), mientras que en Linux la instalación es idempotente. La causa: dos módulos instalan nix-direnv con guards que fallan en macOS — el módulo `nix` revisa solo el profile del usuario (`nix profile list`) cuando nix-darwin/home-manager instala el plugin en el profile del sistema, y el módulo `devops` verifica el binario `direnv` pero instala el plugin `nix-direnv`, que no provee ese binario, provocando reintentos infinitos.

## What Changes

- **`zsh/system/nix/internal/direnv.zsh`**: eliminar la auto-ejecución de `nix::direnv::internal::main::factory` al cargar el módulo. El módulo nix deja de instalar nix-direnv automáticamente; conserva `sync` (config direnvrc).
- **`zsh/system/nix/pkg/direnv.zsh`**: arreglar la API pública `nix::direnv::install` — elimina la llamada a `nix::direnv::internal::enable` (función inexistente) y delega la instalación en `devops::direnv::install`.
- **`zsh/modules/devops/internal/direnv.zsh`**: corregir el guard de `main::factory` — verificar que el plugin `nix-direnv` esté disponible (y no el binario `direnv`), y en macOS no instalar si nix-darwin/home-manager ya lo gestiona.
- **`zsh/modules/devops/internal/osx.zsh` / `linux.zsh`**: hacer el guard de `devops::direnv::internal::install` robusto según plataforma (perfil de usuario vs. perfiles de nix-darwin/home-manager).

## Capabilities

### New Capabilities
- `nix-direnv`: gestión idempotente del plugin `nix-direnv` — instalación solo cuando falta realmente, sin duplicar lo que nix-darwin/home-manager ya gestiona, y sin reintentos en cada carga de shell.

### Modified Capabilities
- `devops`: el guard de instalación de direnv/nix-direnv cambia de verificar el binario `direnv` a verificar la disponibilidad del plugin `nix-direnv`, con detección de gestión externa (nix-darwin/home-manager) en macOS.

## Impact

- **Código afectado**: `zsh/system/nix/internal/direnv.zsh`, `zsh/system/nix/pkg/direnv.zsh`, `zsh/modules/devops/internal/direnv.zsh`, `zsh/modules/devops/internal/osx.zsh`, `zsh/modules/devops/internal/linux.zsh`.
- **APIs**: `nix::direnv::install` (corregida, delega en devops); `nix::direnv::internal::install` deja de ejecutarse automáticamente; `devops::direnv::install` mantiene firma.
- **Dependencias**: ninguna nueva; `nix profile` sigue siendo el mecanismo de instalación en Linux, respetando perfiles de nix-darwin en macOS.
- **Sistemas**: macOS (comportamiento corregido: sin reinstalación por shell) y Linux (comportamiento actual preservado).
