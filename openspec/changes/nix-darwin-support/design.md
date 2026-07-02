## Context

El proyecto tiene una flake de Nix funcional en Linux con un devShell portable vía `flake-utils` + `eachDefaultSystem`. El módulo zsh `zsh/modules/nix/` tiene helpers para gestionar Nix en Linux, pero los placeholders para macOS (`config/osx.zsh`, `pkg/osx.zsh`, `internal/osx.zsh`) están vacíos.

Para tener soporte macOS necesitamos nix-darwin + home-manager. El repo de omerxx/dotfiles tiene esto implementado y podemos adoptar su arquitectura: inputs con `follows` para unificar nixpkgs, outputs `darwinConfigurations` + `darwinPackages`, y configuración del sistema macOS (nix-daemon, defaults, Homebrew, Touch ID).

La flake actual ya soporta `aarch64-darwin` via `eachDefaultSystem` — esto significa que `nix develop` ya funciona en Mac. Lo que falta es la configuración del **sistema** (no del entorno de desarrollo).

## Goals / Non-Goals

**Goals:**
- Agregar nix-darwin + home-manager como inputs al flake existente
- Crear output `darwinConfigurations."Lucho-MacBook"` con configuración completa del sistema macOS
- Configurar: nix-daemon, flakes, build users, Touch ID sudo, macOS defaults (Dock, Finder, screenshots, login)
- Integrar Homebrew para apps GUI y CLI fuera de nixpkgs
- Crear helpers zsh para gestionar nix-darwin (rebuild, update, status, bootstrap)
- Mantener compatibilidad total con Linux — nada existente se modifica
- Versionar `nix/nix.conf`

**Non-Goals:**
- No reemplazar el módulo zsh existente — home-manager lo complementa, no lo sustituye
- No migrar la configuración Linux a nix-darwin (nix-darwin es macOS-only)
- No cambiar el devShell existente
- No agregar paquetes macOS específicos hasta tener la Mac para probar

## Decisions

### Decisión 1: Output adicional al flake existente vs flake separado
**Opción elegida: Output adicional**
- Un solo `flake.nix`, un solo `flake.lock`, un solo `nix develop`
- `darwinConfigurations` es un output ortogonal a `devShells` — coexisten sin interferir
- Usa `//` para mergear los attrsets de outputs
- **Alternativa rechazada**: Flake separado en `nix-darwin/` — duplica `nixpkgs` como input, dos `flake.lock` que divergen, dos `nix develop` que compiten

### Decisión 2: home-manager como complemento, no reemplazo del módulo zsh
**Opción elegida: home-manager maneja solo lo que el módulo zsh no toca**
- `programs.zsh.initExtra` solo para daemon sourcing de nix
- Session vars, direnv, paquetes de usuario que no necesitan configuración de sistema
- **Alternativa rechazada**: home-manager gestionando todo el zsh — conflicto con el módulo existente, dos fuentes de verdad

### Decisión 3: Módulos de nix-darwin en `nix/darwin/` vs en la raíz
**Opción elegida: `nix/darwin/`**
- Sigue la estructura existente: `nix/devShell.nix`, `nix/versions.nix`
- `nix/darwin/default.nix` como entry point
- `nix/darwin/home.nix` y `nix/darwin/brew.nix` como módulos separados
- **Alternativa rechazada**: `nix-darwin/` en raíz — rompe la convención existente de `nix/`

### Decisión 4: `nix/nix.conf` versionado
**Opción elegida: Archivo de documentación viviente**
- En nix-darwin, la configuración se aplica via `nix.settings` en `default.nix`
- `nix/nix.conf` sirve como referencia y para instalaciones manuales en Linux
- **Alternativa rechazada**: Solo inline en flake.nix — Linux no tiene acceso a esa configuración

### Decisión 5: Módulo zsh independiente para helpers nix-darwin
**Opción elegida: `zsh/modules/nix-darwin/` como módulo independiente**
- Sigue el patrón existente de módulos condicionales por OSTYPE (hammerspoon, hyprland)
- `config/linux.zsh` setea `ZSH_NIX_DARWIN_ENABLED=false` → auto-deshabilitado en Linux
- `config/osx.zsh` contiene las helpers (rebuild, update, status, bootstrap)
- `plugin.zsh` + `config/main.zsh` manejan el dispatch por plataforma
- El runner en `zsh/core/pkg/runner.zsh` ya respeta `ZSH_*_ENABLED` sin cambios
- **Alternativa rechazada**: Parchar `zsh/modules/nix/` — mezcla dominios Linux y macOS, viola separación de concerns
- **Alternativa rechazada**: Script suelto en `scripts/` — fuera de la arquitectura de módulos

## Risks / Trade-offs

| Riesgo | Severidad | Mitigación |
|--------|-----------|------------|
| `eachDefaultSystem` + outputs planos de darwin pueden generar attrset inválido | Baja | Testear con `nix flake show` en Linux antes de commit. El operador `//` es seguro con keys disjuntos. |
| Hostname de la Mac no coincide con el configurado | Media | Usar `scutil --get ComputerName` para obtener el nombre real. Configurable en `default.nix`. |
| home-manager conflictúa con módulo zsh existente | Media | home-manager solo gestiona `initExtra`. El módulo zsh sigue siendo la fuente de verdad. No usar `programs.zsh` para config que ya maneja el módulo. |
| `darwin-rebuild` requiere sudo | Baja | Documentado. El helper `nix::darwin::rebuild` ya incluye `sudo`. |
| Primer `nix flake lock` más lento (~30s) | Baja | Una sola vez. Se cachea. |
| `nix.configureBuildUsers = true` puede fallar sin admin | Alta | Verificar antes del primer rebuild: `dscl . -read /Groups/nixbld`. |
