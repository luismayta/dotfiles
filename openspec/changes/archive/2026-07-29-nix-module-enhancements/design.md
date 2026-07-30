## Context

El módulo Nix (`zsh/modules/nix/`) tiene una arquitectura bien estructurada con separación OS-aware, feature flag y scaffolding, pero carece de:

1. **Sync automático de `nix.conf`** — actualmente es manual, documentado solo como comentario en `nix/nix.conf`
2. **Código redundante** — `pkg/base.zsh` pasa `--extra-experimental-features "nix-command flakes"` inline, innecesario desde que existe `nix.conf`
3. **Validación insuficiente** — `core::nix::ensure` no verifica si la instalación fracasó
4. **Placeholders vacíos** — 7 archivos solo con comentarios sin lógica real
5. **Template base no funcional** — `flake.nix` genérico tiene `outputs` vacío

La cadena de llamadas es: `plugin.zsh → config/ → internal/ → pkg/`, con el core API en `zsh/core/pkg/nix.zsh` y `zsh/core/internal/nix.zsh`.

## Goals / Non-Goals

**Goals:**
- Sincronizar `nix/nix.conf` a `~/.config/nix/nix.conf` automáticamente al cargar el módulo en Linux
- Eliminar `--extra-experimental-features` inline de las funciones públicas
- Agregar validación de resultado en `core::nix::ensure` con mensaje de error
- Agregar confirmación interactiva en `nix::gc()` antes de ejecutar `nix-collect-garbage -d`
- Cambiar `rsync --progress` por `rsync --quiet` en sync automático
- Poblar template `flake.nix` genérico con `devShells.default` mínimo funcional
- Evaluar placeholders vacíos: eliminar o poblar según corresponda

**Non-Goals:**
- No se modifica la API pública del módulo (retrocompatible total)
- No se agregan nuevos comandos o alias
- No se modifica la integración con nix-darwin (macOS tiene su propio mecanismo)
- No se implementa UI/UX — son cambios de backend/infra

## Decisions

### Decisión 1: Mantener `data/sync/` con rsync
- **rsync** es el mecanismo establecido en el ecosistema de dotfiles (git, tmux usan `data/sync/` con rsync). Se mantiene.
- **direnvrc**: Se mantiene en `data/sync/.config/direnv/direnvrc`, su rsync actual funciona correctamente.

### Decisión 2: Sync de nix.conf — separación config/internal
- **config/linux.zsh**: Solo variables export (`NIX_CONF_SOURCE`, `NIX_CONF_DIR`, `NIX_CONF_TARGET`).
- **internal/linux.zsh**: Función `nix::internal::sync::nix_conf` con rsync.
- Usa `${DOTFILES}` (variable global de `zsh/zshrc`) en vez de `${HOME}/.dotfiles`.
- Auto-ejecuta al cargar el módulo en Linux.

### Decisión 3: Placeholders se mantienen
- Todos los placeholders se conservan: `config/linux.zsh`, `config/osx.zsh`, `internal/linux.zsh`, `internal/osx.zsh`, `pkg/linux.zsh`, `pkg/osx.zsh`, `pkg/helper.zsh`.
- Son puntos de extensión intencionales para lógica OS-específica futura.

### Decisión 4: Template base `flake.nix`
- Agregar `devShells.default` mínimo con `pkgs.mkShell { packages = []; }`. Suficiente para que `nix develop` no falle.

### Decisión 5: Validación en `core::nix::ensure`
- Modificar `zsh/core/internal/nix.zsh` para que `core::internal::nix::install` retorne 1 si falla, y que `ensure` muestre `message_error` si no se pudo instalar.

## Risks / Trade-offs

- **Sync de nix.conf con rsync**: `rsync -a` preserva permisos y sobrescribe si el source es más nuevo. No hay confirmación previa. Mitigación: el archivo es de configuración local, rsync es el mecanismo estándar del ecosistema.
- **`nix::gc()` con confirmación**: Agrega fricción en scripts automatizados. Mitigación: el flag `-d` ya es destructivo; la confirmación es deseable por seguridad. Para no-interactivo, usar `nix-collect-garbage -d` directamente.
- **Placeholders se mantienen**: No hay riesgo de referencias rotas; todos son puntos de extensión intencionales.
