---
# Design — Migrate Antidote to zsh/system
---

## Context

Antidote (plugin manager de zsh) se instala hoy en el bootstrap de provision: `tools/antidote/install.sh` clona `https://github.com/mattmc3/antidote.git` (depth 1) a `${ZDOTDIR:-$HOME}/.antidote`, con hardening (`set -euo pipefail`, trap ERR) e idempotencia (guard `[[ -d ${ANTIDOTE_PATH} ]]`). Lo invoca el bucle `dotfiles_install_apps` (provision/script/functions.sh) con `APPS=("antidote")` (config/base.sh) y `TOOLS_PATH="${PATH_REPO}/tools"` (bootstrap.sh). Es el único app restante en `tools/`.

Como plugin manager, `zsh/zshrc` L73-80 sourcea `${HOME}/.antidote/antidote.zsh`, genera `~/.zsh_plugins.txt` concatenando `zsh/zsh_plugins.txt` (6 bundles) + `~/.custom_zsh_plugins.txt`, y ejecuta `antidote load ~/.zsh_plugins.txt`.

El repo consolida los módulos de sistema en `zsh/system/` (`core/` cargado explícito desde zshrc; `nix/` y `nix-darwin/` con `plugin.zsh` auto-cargados por el loader de zshrc L25-41), con capas `config/` (env), `internal/` (install privado con guard + `message_info`), `pkg/` (API pública) y `data/`. La guía `docs/guides/create-module.md` es la fuente de verdad del patrón. Las variables de ruta siguen el sufijo `_PATH` (change `rename-dir-vars-to-path`).

## Goals / Non-Goals

**Goals:**

- Antidote como módulo autocontenido de `zsh/system/` (`plugin.zsh` + `config/` + `internal/` + `pkg/`) siguiendo el patrón `nix`.
- Install idempotente (git clone) en `internal/` con guard y mensajería de core.
- Init cohesionado en el módulo (`antidote::init`) preservando el orden de carga actual.
- Eliminar `tools/`, `APPS`, `TOOLS_PATH` y `dotfiles_install_apps` (mecanismo muerto).

**Non-Goals:**

- Migrar los 6 bundles de `zsh_plugins.txt` a módulos propios (changes separados `migrate-zsh-*`).
- Renombrar `ANTIDOTE_PATH`.
- Cambiar el loader de zshrc ni el orden de carga de módulos.
- Modificar otros instaladores de provision (no quedan apps).

## Decisions

1. **Módulo completo con `plugin.zsh` (patrón nix), no relocación física de `install.sh`.**
   Se crea `zsh/system/antidote/` con `plugin.zsh` (guard `__ZSH_ANTIDOTE_LOADED`, `ZSH_ANTIDOTE_PATH="${0:A:h}"`, `message_info "Loading module: antidote"`, source de config/internal/pkg).
   *Alternativa rechazada*: mover `tools/antidote/install.sh` → `zsh/system/antidote/install.sh` y seguir invocándolo desde provision. Rompe el patrón (ningún módulo system tiene install.sh), el loader solo sourcea `plugin.zsh`, y deja el framework `tools/` vivo solo para un archivo.

2. **Install por git clone en `internal/`, no `core::ensure`.**
   `core::ensure` despacha a `core::install` por plataforma (paru/brew); antidote no es paquete estándar en apt ni brew y el instalador vigente clona el repo. Se mantiene el clone con guard `[[ -f ${ANTIDOTE_PATH}/antidote.zsh ]]` + `message_info`.
   *Alternativa rechazada*: `paru -S antidote` en Arch — inconsistente entre plataformas; el clone funciona igual en Linux/macOS.

3. **Init como función pública `antidote::init` invocada desde zshrc en la misma posición.**
   El bloque L73-80 se reemplaza por `antidote::init` (tras el loader de `zsh/modules`). El módulo define el init; zshrc solo lo invoca.
   *Alternativa rechazada*: ejecutar el `antidote load` dentro de `plugin.zsh` — cambiaría el orden (plugins de terceros antes que los módulos user), riesgo de romper completions/highlighting.

4. **Eliminar el mecanismo `tools/` completo.**
   Tras la migración `tools/` queda vacío: se eliminan `APPS=("antidote")` (base.sh), `dotfiles_install_apps` (functions.sh) y `TOOLS_PATH` (bootstrap.sh).
   *Alternativa rechazada*: conservar el framework para futuros tools — código muerto; `cleanup-dead-tools` (2026-06-10) ya consolidó esta dirección.

5. **Mantener `ANTIDOTE_PATH` (backcompat).**
   Declarada con default en `config/base.zsh`: `ANTIDOTE_PATH="${ANTIDOTE_PATH:-${ZDOTDIR:-${HOME}}/.antidote}"`. Ya establecida por `rename-dir-vars-to-path`; no se renombra ni se exporta en zshrc.

6. **No registrar `antidote::setup` en `DOTFILES_SETUP_MODULES`.**
   El init cubre la carga; `dotfiles::setup` no necesita un paso extra. Se puede añadir después si aparece un caso de uso.

## Risks / Trade-offs

- [Cambio de timing del install: bootstrap (provision) → auto-install al cargar el shell] → Mitigación: el módulo respeta `ZSH_DISABLED_MODULES`; primera carga puede tardar si falta el clone; idempotente en cargas siguientes.
- [`ZSH_DISABLED_MODULES=antidote` desactiva también el init] → Mitigación: comportamiento esperado del loader, visible en mensajes; los plugins de terceros no cargan (efecto documentado).
- [git clone en startup sin red] → Mitigación: solo ocurre si falta `ANTIDOTE_PATH` (primera vez); el fallo se propaga con mensaje claro (patrón `set -e`).
- [Regresión en el orden de carga de plugins] → Mitigación: `antidote::init` se invoca desde la misma posición en zshrc; verificación manual prompt/plugins antes-después.
- [Referencias históricas a `tools/antidote` (openspec archive, .codi/build)] → Mitigación: verificadas por grep: son archivos archivados, no código vivo.

## Migration Plan

1. Crear `zsh/system/antidote/` (`plugin.zsh`, `config/{base,main}.zsh`, `internal/{base,main}.zsh`, `pkg/{base,main}.zsh`).
2. Actualizar `zsh/zshrc`: bloque L73-80 → `antidote::init`.
3. Eliminar `tools/antidote/` y el directorio `tools/`.
4. Provision: quitar `APPS`, `dotfiles_install_apps`, `TOOLS_PATH`.
5. Verificar: `source zshrc` → módulo carga una vez y los plugins cargan; `bash -n` + shellcheck en scripts tocados; nueva shell con `ZSH_DISABLED_MODULES=antidote` → sin carga del módulo.

**Rollback:** revert de los commits; `tools/antidote/install.sh` es recuperable desde el historial de git.

## Open Questions

Ninguna — las decisiones de registro (`DOTFILES_SETUP_MODULES`) y naming se resolvieron en Decisions.
