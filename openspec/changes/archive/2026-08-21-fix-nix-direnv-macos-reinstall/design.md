## Context

Ver `proposal.md` — Why. Estado actual que condiciona el diseño:

- El módulo nix (`zsh/system/nix/`) ejecuta `nix::direnv::internal::main::factory` incondicionalmente al cargar (`internal/direnv.zsh:20`), y su guard (`internal/osx.zsh:6` / `internal/linux.zsh:7`) revisa solo `nix profile list` — el profile del usuario. En macOS con nix-darwin, home-manager instala `nix-direnv` en el profile del sistema (`nix/darwin/home.nix:28-31`), así que el guard nunca matchea → reinstalación en cada shell.
- El módulo devops (`zsh/modules/devops/internal/direnv.zsh:11-12`) guarda con `core::exists direnv` (binario) pero instala `nixpkgs#nix-direnv` (plugin, sin binario) → guard nunca se satisface → reintento por shell.
- `zsh/system/nix/pkg/direnv.zsh:8` llama `nix::direnv::internal::enable`, que no existe en ningún archivo.
- Existe un precedente de arquitectura: el change archivado `2026-07-29-extract-tools-from-nix` ya definió que direnv/nix-direnv pertenece al módulo devops, no a nix. Este fix completa esa migración.

## Goals / Non-Goals

**Goals:**
- Detener la reinstalación de `nix-direnv` en cada carga de shell en macOS.
- Hacer que la detección del plugin sea correcta (plugin ≠ binario).
- Mantener la instalación única en Linux tal como funciona hoy.
- Completar la propiedad de direnv en devops (decisión ya tomada en el change archivado).

**Non-Goals:**
- No cambiar el mecanismo de instalación (sigue siendo `nix profile`).
- No refactorizar el resto de la arquitectura de módulos.
- No tocar `nix/darwin/home.nix` (la gestión por home-manager es correcta y se respeta).
- No implementar instalación vía homebrew.

## Decisions

### D1: El módulo nix deja de auto-instalar nix-direnv
`zsh/system/nix/internal/direnv.zsh` conserva `sync` (copia del direnvrc) pero elimina la ejecución de `main::factory` al cargar. La función `main::factory` se elimina o se deja sin invocar; `pkg/direnv.zsh` de nix delega la instalación en `devops::direnv::install` y elimina la llamada a `enable` inexistente.
- **Por qué**: la propiedad de direnv ya fue asignada a devops (change archivado `extract-tools-from-nix`); nix solo debe ofrecer helpers de Nix, no instalar herramientas de direnv.
- **Alternativa considerada**: arreglar solo el guard de macOS (chequear perfiles del sistema). Descartada: deja dos fuentes de verdad y el bug del guard de devops persiste.

### D2: Guard de devops basado en disponibilidad del plugin, no del binario
`devops::direnv::internal::main::factory` debe verificar la presencia efectiva de `nix-direnv` (p. ej. `nix profile list | grep nix-direnv`, o presencia del direnvrc que lo referencia en `~/.config/direnv/direnvrc`), y en macOS además detectar gestión externa vía nix-darwin (presencia de `darwin-rebuild` + perfil del sistema, o `nix-env -q` en perfiles del sistema).
- **Por qué**: `core::exists direnv` es un criterio inválido porque el paquete instalado (`nix-direnv`) no provee el binario.
- **Alternativa considerada**: instalar solo el plugin y asumir el binario por homebrew/nix-darwin. Descartada por decisión del usuario (Luchex): se prefiere una herramienta funcional end-to-end sin dependencia externa. **Decisión adoptada**: cuando el binario `direnv` falta, `install` instala también `nixpkgs#direnv` junto al plugin.

### D3: Detección de gestión externa solo en macOS
La comprobación de nix-darwin/home-manager (perfiles del sistema) se limita a `darwin*`. En Linux el guard actual (`nix profile list | grep nix-direnv`) es suficiente y no debe cambiar de comportamiento.

### D4: Función compartida de detección
Se añade un helper interno (p. ej. `devops::direnv::internal::is_managed` o inline en cada plataforma) que centraliza: (a) plugin en profile del usuario, (b) gestión externa en macOS. Usado tanto por `main::factory` como por `install` explícito.

## Risks / Trade-offs

- [En macOS sin nix-darwin y sin el plugin, la instalación automática ya no ocurrirá si el binario `direnv` existe pero el plugin no] → El guard de devops instala el plugin cuando falta y no hay gestión externa; el usuario puede invocar `devops::direnv::install` explícitamente.
- [Eliminar la auto-instalación del módulo nix cambia el comportamiento para quien dependa de ella en Linux] → En Linux el guard ya impedía reinstalar; el comportamiento efectivo (instalar una vez) se preserva vía devops.
- [La API `nix::direnv::install` cambia de implementación] → Se mantiene la firma y se delega en devops; cualquier llamada existente sigue funcionando.
- [Detección de gestión externa puede fallar si nix-darwin usa rutas no estándar] → Se usan los puntos de detección ya presentes en el repo (`darwin-rebuild` en `zsh/system/nix-darwin/config/osx.zsh:8`).

## Migration Plan

1. Implementar D1 (módulo nix deja de auto-instalar; `pkg/direnv.zsh` delega).
2. Implementar D2/D3/D4 (guard de devops con detección de plugin y gestión externa).
3. Verificación manual en macOS: cargar shell, confirmar que NO aparece "Installing nix-direnv"; `nix profile list` sin cambios no deseados.
4. Verificación manual en Linux: comportamiento actual preservado (sin reinstalación).

Rollback: revertir los commits del change; los archivos son autocontenidos por módulo.

## Open Questions

Ninguna.
