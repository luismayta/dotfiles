## Why

Devbox (by Jetify) provides isolated, reproducible development environments without Docker overhead — declarando dependencias en un `devbox.json` y usando **Nix** como motor por debajo sin requerir conocimiento de Nix lang. El ecosistema de dotfiles tiene 28 módulos para herramientas del día a día (git, tmux, docker, nvim), pero no hay soporte para Devbox ni para Nix.

Se necesita **Nix como base** (Devbox lo consume, pero también sirve independientemente para otros fines como gestión de paquetes, entornos reproducibles, y desarrollo con flakes). Tener un módulo Nix separado permite reutilizarlo y que Devbox dependa de él.

## What Changes

### Módulo Nix (`zsh/modules/nix/`)
- Crear módulo Nix siguiendo el patrón tri-capa (config/internal/pkg)
- Instalación de Nix (single-user) con soporte macOS/Linux
- Gestión de canales: cambiar entre `nixpkgs-stable`, `nixpkgs-unstable`
- Garbage collector: trigger manual de `nix-collect-garbage`
- Función `nix::install`, `nix::channel::set`, `nix::gc`

### Módulo Devbox (`zsh/modules/devbox/`)
- Crear módulo Devbox dependiente de Nix (verifica `core::ensure nix` antes de instalar Devbox)
- Instalación multiplataforma: Homebrew en macOS, paru en Arch Linux
- Funciones `devbox::install`, `devbox::sync`, `devbox::shell`, `devbox::init`
- Aliases de shell y keybinding ZLE opcional
- Integración con `core::ensure` para auto-instalación al cargar el módulo

## Capabilities

### New Capabilities
- `nix-module`: Módulo Zsh para Nix — instalación single-user, gestión de canales (stable/unstable), y garbage collector
- `devbox-module`: Módulo Zsh completo para Devbox — instalación, configuración, shell integración y comandos de gestión de entornos (depende de Nix)

### Modified Capabilities

<!-- No existing capabilities are modified. This is a net-new module. -->

## Impact

- **Nuevos directorios**: `zsh/modules/nix/` y `zsh/modules/devbox/` con estructuras completas
- **Relación entre módulos**: Devbox requiere que Nix esté presente. El módulo devbox ejecuta `core::ensure nix` antes de `core::ensure devbox`.
- **Sin cambios a módulos existentes**: ambos módulos se auto-registran vía el cargador de módulos en `zsh/zshrc`
- **Configuración Nix**: archivos en `~/.config/nix/nix.conf` y canales
- **Configuración Devbox global**: archivo `~/.config/devbox/global/devbox.json`
