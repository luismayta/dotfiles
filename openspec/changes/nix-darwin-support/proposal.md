## Why

El proyecto tiene soporte Nix funcional en Linux (devShell portable vía `flake-utils`), pero no funciona en macOS. Los placeholders `zsh/modules/nix/config/osx.zsh` y `pkg/osx.zsh` están vacíos. Para tener una configuración reproducible en macOS necesitamos nix-darwin + home-manager, que permiten gestionar el sistema macOS como código: paquetes del sistema, defaults de macOS (Dock, Finder, screenshots), Homebrew, daemon de nix, Touch ID para sudo, y configuración de usuario. omerxx/dotfiles tiene esto implementado y podemos adoptar su patrón. La flake actual ya usa `eachDefaultSystem` que soporta `aarch64-darwin` — agregar nix-darwin como output adicional es natural y no rompe nada en Linux.

## What Changes

- **Agregar inputs `nix-darwin` y `home-manager`** al `flake.nix` existente (con `follows` para unificar nixpkgs)
- **Crear output `darwinConfigurations."Lucho-MacBook"`** con configuración completa del sistema macOS
- **Crear `nix/darwin/default.nix`**: Módulo principal con configuración del sistema (paquetes, nix-daemon, flakes, macOS defaults, Touch ID)
- **Crear `nix/darwin/home.nix`**: Home manager para usuario lucho (zsh initExtra, session vars, direnv, paquetes de usuario)
- **Crear `nix/darwin/brew.nix`**: Integración con Homebrew (casks para apps GUI, brews para CLI fuera de nixpkgs)
- **Crear `nix/nix.conf`**: Versionar configuración de Nix (experimental-features, build-users-group, max-jobs)
- **Llenar `zsh/modules/nix/config/osx.zsh`**: Helpers para detección de nix-darwin y paths de sistema macOS
- **Llenar `zsh/modules/nix/pkg/osx.zsh`**: Funciones `nix::darwin::rebuild`, `nix::darwin::update`, `nix::darwin::status`
- **Llenar `zsh/modules/nix/internal/osx.zsh`**: Detección de nix-darwin y hint de bootstrap
- **Agregar `bootstrap_hint`** en `internal/main.zsh` para guiar instalación en macOS

## Capabilities

### New Capabilities
- `darwin-system-config`: Configuración del sistema macOS vía nix-darwin (paquetes, daemon, flakes, macOS defaults, Touch ID, Homebrew)
- `darwin-home-manager`: Configuración de usuario vía home-manager (zsh, session vars, direnv, paquetes de usuario)
- `darwin-brew-integration`: Integración con Homebrew para apps GUI y CLI fuera de nixpkgs
- `darwin-zsh-helpers`: Funciones de shell para gestionar nix-darwin (rebuild, update, status, bootstrap)

### Modified Capabilities
- *(ninguna — el flake existente no se modifica, solo se extiende)*

## Impact

- **Linux: Sin impacto**. Los nuevos inputs y outputs solo se evalúan en contexto macOS. `nix develop` sigue igual.
- **BREAKING**: El `flake.nix` cambia su estructura de outputs — pero los outputs existentes (`devShells`) se mantienen idénticos.
- **macOS**: Primer `nix flake lock` será ~30s más lento (descarga nix-darwin + home-manager).
- **Dependencias nuevas**: `nix-darwin` (github:LnL7/nix-darwin), `home-manager` (github:nix-community/home-manager).
