## Context

El módulo herdr de dotfiles gestiona plugins de forma declarativa: `config/base.zsh` declara el array global `ZSH_HERDR_INSTALL_PLUGINS`, `config/plugins.zsh` lo puebla con entradas `owner/repo` (~17 plugins en 5 categorías), y `internal/install.zsh` (`herdr::internal::plugin::install::all`) itera el array ejecutando `herdr plugin install <owner/repo> --yes` al cargar `plugin.zsh`. Los keybindings de plugins se configuran en `data/config.toml` bajo `[[keys.command]]` con `type = "plugin_action"`. Ver proposal.md — Why para la motivación.

## Goals / Non-Goals

**Goals:**
- Registrar `Hanyang-Li/herdr-espresso` siguiendo el patrón declarativo existente (una línea en `config/plugins.zsh`)
- Integrar el plugin con la UI de herdr: keybinding `espresso.toggle` y marcador `$espresso` en la barra lateral
- Documentar el requisito del CLI `espresso` como dependencia del entorno (macOS)

**Non-Goals:**
- No modificar el mecanismo de auto-instalación (`internal/install.zsh`) — funciona como está
- No versionar el binario del CLI espresso en dotfiles — es dependencia del entorno, no del repo
- No implementar funcionalidad del plugin (es código externo de Hanyang-Li)

## Decisions

**D1: Registro declarativo en `config/plugins.zsh` (no instalación manual)**
Agregar `Hanyang-Li/herdr-espresso` al array `ZSH_HERDR_INSTALL_PLUGINS` en la categoría correspondiente.
- *Rationale*: el módulo ya auto-instala plugins del array al cargar; es reproducible, versionable en git y consistente con los ~17 plugins existentes.
- *Alternativa considerada*: `herdr plugin install` manual — rechazada por no ser reproducible ni versionable.

**D2: Keybinding `espresso.toggle` en `data/config.toml`**
Agregar un bloque `[[keys.command]]` con `type = "plugin_action"` y `command = "espresso.toggle"`, siguiendo el patrón existente (ej. `cloudmanic.herdr-plus.quick-actions`).
- *Rationale*: patrón ya establecido en el archivo; el plugin expone la acción `espresso.toggle` para el toggle por panel.
- *Alternativa considerada*: sin keybinding (solo instalación) — rechazada porque el spec requiere el toggle accesible por teclado.

**D3: Marcador `$espresso` en `[ui.sidebar.agents]`**
Configurar `rows` para incluir el token `$espresso` junto a los paneles de agente.
- *Rationale*: visibilidad de qué paneles están monitoreados; el plugin documenta el token como mecanismo oficial.
- *Alternativa considerada*: omitir el marcador — rechazada porque el spec lo requiere para visualizar paneles monitoreados.

**D4: Auto-instalación del CLI espresso con strategy por OS**
Implementar el patrón strategy del codebase (base → OS dispatch → tool files): array declarativo `ZSH_HERDR_CUSTOM_DEPS` en `config/base.zsh`, función genérica `herdr::internal::deps::ensure` en `internal/install.zsh` que itera el array y despacha a `herdr::internal::deps::install::<binary>` (dynamic dispatch con guard `$+functions`), con implementaciones por OS en `internal/osx.zsh` (espresso vía instalador oficial `curl | sh`) e `internal/linux.zsh` (no-op, espresso es macOS-only). El daemon (`espresso daemon install`, requiere sudo) vive en `internal/osx.zsh` como función manual `herdr::internal::espresso::daemon::install` — no automática.
- *Rationale*: consistente con el patrón canónico del codebase (devops/docker: mismo nombre de función, implementación por OS cargada vía `case "${OSTYPE}"` en `internal/main.zsh`); escalable — agregar una dependencia custom = una línea en el array + una función por OS, sin tocar `plugin.zsh`.
- *Alternativa considerada*: guard hardcodeado en `plugin.zsh` — rechazada (no escalable, feedback de review). `core::install espresso` — rechazada (espresso no está en brew/paru/apt).

## Risks / Trade-offs

- [Plugin solo funciona en macOS] → El registro en el array es inerte en otros OS; herdr maneja la instalación por plataforma. Documentar el requisito en el spec.
- [`espresso daemon install` requiere sudo] → Documentar como paso manual opcional; sin él el plugin funciona para suspensión por inactividad (no tapa cerrada).
- [Colisión de keybinding con tecla existente] → Verificar `data/config.toml` antes de asignar la tecla; elegir una no usada.
- [Auto-instalación en cada login] → El mecanismo existente verifica `herdr plugin list` antes de instalar (idempotente); sin impacto adicional.

## Migration Plan

**Deploy:**
1. Agregar `Hanyang-Li/herdr-espresso` al array en `config/plugins.zsh`
2. Agregar keybinding y marcador en `data/config.toml`
3. Recargar zsh (o nueva sesión) → el módulo instala el plugin automáticamente
4. Verificar: `herdr plugin list` incluye `herdr-espresso`; presionar la tecla del toggle en un panel de agente

**Rollback:**
1. Remover la entrada del array en `config/plugins.zsh`
2. Remover keybinding y marcador de `data/config.toml`
3. `herdr plugin uninstall Hanyang-Li/herdr-espresso` (opcional, si se quiere desinstalar)

## Open Questions

Ninguna — las decisiones de tecla exacta del keybinding y categoría del array son detalles de implementación que no cambian specs ni tasks.