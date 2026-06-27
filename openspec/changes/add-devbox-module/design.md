## Context

El repositorio de dotfiles utiliza un sistema de módulos Zsh con arquitectura tri-capa (`config/` → `internal/` → `pkg/`) para gestionar herramientas de desarrollo. Actualmente existen 28 módulos (git, tmux, docker, nvim, starship, ghostty, etc.) y no hay soporte para **Nix** ni para **Devbox** (CLI de entornos aislados basado en Nix).

**Nix** es un gestor de paquetes puro-funcional que permite entornos reproducibles. Devbox lo usa como motor, pero Nix también tiene valor independiente (paquetes, flakes, gestión de canales).

Se implementarán **dos módulos**:
1. `nix/` — instalación y gestión básica de Nix (single-user, canales, GC)
2. `devbox/` — instalación y comandos de Devbox (depende de Nix)

La relación entre módulos es: `devbox` verifica que Nix esté presente (`core::ensure nix`) antes de instalar Devbox, pero **no depende del módulo nix** — solo de que el binario `nix` esté disponible.

## Goals / Non-Goals

**Goals:**

### Módulo Nix
- Delegación de instalación al core (`core::nix::ensure`)
- Detección de SO: macOS (script oficial con `--no-daemon`), Linux (script oficial)
- Gestión de canales: `nix-channel --add` para `nixpkgs-stable` y `nixpkgs-unstable`
- Garbage collector: trigger manual con `nix-collect-garbage -d`
- API pública: `nix::install`, `nix::channel::set`, `nix::channel::list`, `nix::gc`

### Módulo Devbox
- Instalación automática y multiplataforma (Homebrew macOS, paru Arch Linux)
- Dependencia de Nix: verifica que `nix` exista antes de instalar Devbox
- Sincronización de configuración global de Devbox
- API pública: `devbox::install`, `devbox::sync`, `devbox::shell`, `devbox::init`
- Aliases de shell y keybinding ZLE opcional

**Non-Goals:**
- No reemplazar ni modificar módulos existentes
- No implementar flakes ni configuraciones avanzadas de Nix
- No gestionar perfiles Nix ni `nix-env`
- No modificar el cargador de módulos de `zsh/zshrc`

## Decisions

1. **Dos módulos separados**: Nix y Devbox son módulos independientes. Devbox *consume* Nix pero no depende del módulo Zsh — solo del binario. Esto permite deshabilitar el módulo devbox sin perder Nix.

2. **Instalación de Nix single-user**: Se usa el script oficial con flag `--no-daemon`. No requiere sudo, lo que es más simple para dotfiles y evita problemas de permisos al hacer bootstrap.

3. **Instalación de Devbox via gestor de paquetes**: Homebrew en macOS, paru en Arch Linux. Sin script curl, manteniendo consistencia con `core/internal/osx.zsh` y `core/internal/linux.zsh`.

4. **Estructura tri-capa estándar para ambos**: `config/` → `internal/` → `pkg/` como todos los módulos existentes.

5. **Canales Nix**: Se usa `nix-channel` nativo para switchear entre `nixpkgs-stable` y `nixpkgs-unstable`, sin abstracciones adicionales.

6. **Config global Devbox**: Se usa el CLI `devbox global` para gestionar paquetes globales, no se manipulan archivos directamente.

7. **Sin keybinding por defecto**: Se incluye `keybindings.zsh` en el módulo devbox con `^Xd`, comentado por defecto.

8. **Instalación de Nix en el core**: Nix es una herramienta global (como brew/paru), por lo que su instalación reside en `core/internal/nix.zsh` y se expone via `core::nix::ensure`. El módulo `nix` mantiene su estructura tri-capa pero su `internal/base.zsh` delega en core en lugar de ejecutar el installer directamente.

## Architecture: Flujo de carga

```
zshrc
 └─ core/main.zsh
      ├─ config/paths.zsh          (Nix paths in PATH)
      ├─ config/env.zsh            (CORE_MESSAGE_NIX, NIX_CONF_DIR)
      ├─ internal/nix.zsh          (core::internal::nix::install via official script)
      └─ pkg/nix.zsh               (core::nix::install, core::nix::exists, core::nix::ensure)

 └─ modules/nix/plugin.zsh
      ├─ config/base.zsh           (NIX_CONF_DIR, channel config)
      ├─ internal/base.zsh         (nix::internal::nix::install → core::nix::ensure)
      └─ pkg/base.zsh              (nix::channel::*, nix::gc)

 └─ modules/devbox/plugin.zsh
      ├─ config/base.zsh           (DEVBOX_PACKAGE_NAME, DEVBOX_DATA_PATH)
      ├─ internal/base.zsh         (devbox::internal::devbox::install)
      │   ├─ core::nix::ensure     ← verifica Nix via core
      │   └─ core::ensure devbox   → installa si no existe
      └─ pkg/base.zsh              (devbox::install, devbox::sync, devbox::shell, devbox::init)
```

### Note sobre el core
El core (`zsh/core/`) contiene las funciones de instalación de Nix porque es una herramienta global que debe estar disponible para cualquier módulo (como lo están brew y paru). La instalación se realiza mediante el script oficial de Nix con flag `--no-daemon`.

## Risks / Trade-offs

- **Tamaño de Nix**: La instalación de Nix descarga ~300MB. La primera ejecución es lenta. → Mitigación: `message_info` advierte antes de instalar.
- **Dependencia de canal**: Si el canal `nixpkgs-unstable` está roto, puede afectar paquetes. → Mitigación: `nix::channel::set` permite volver a stable fácilmente.
- **Multi-plataforma**: Nix tiene soporte oficial en macOS y Linux. Windows vía WSL2. → Mitigación: el script oficial de Nix maneja la detección de SO.
- **Versiones de Devbox**: CLI cambia rápido. → Mitigación: funciones simples que delegan al CLI real.
- **Colisión con Nix existente**: Si el usuario ya tiene Nix instalado, `core::ensure` lo detecta y no hace nada.
