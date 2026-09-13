## Why

El módulo herdr de dotfiles gestiona plugins de forma declarativa a través del array `ZSH_HERDR_INSTALL_PLUGINS`, instalándolos automáticamente al cargar el módulo. Sin embargo, no incluye `herdr-espresso`, un plugin que mantiene la Mac despierta mientras el agente de codificación de un panel está trabajando activamente — sin él, la Mac puede entrar en suspensión a mitad de una tarea de IA de larga duración, interrumpiendo el trabajo del agente.

## What Changes

- Registrar `Hanyang-Li/herdr-espresso` en el array `ZSH_HERDR_INSTALL_PLUGINS` de `zsh/modules/herdr/config/plugins.zsh`
- El módulo herdr instalará automáticamente el plugin al cargar (`herdr plugin install Hanyang-Li/herdr-espresso --yes`)
- Configurar keybinding `espresso.toggle` en `zsh/modules/herdr/data/config.toml` para activar/desactivar el monitoreo por panel
- Configurar el marcador `$espresso` en la barra lateral de agentes para visualizar paneles monitoreados

## Capabilities

### New Capabilities
- `herdr-plugins`: Registro declarativo de plugins del módulo herdr — el sistema SHALL registrar plugins en el array `ZSH_HERDR_INSTALL_PLUGINS` y SHALL instalarlos automáticamente al cargar el módulo, incluyendo `herdr-espresso` con su keybinding y marcador de barra lateral.

### Modified Capabilities
<!-- Ninguna — herdr-cli cubre solo los comandos standalone de worktrees (hrdw-*), no el registro de plugins. -->

## Impact

- `zsh/modules/herdr/config/plugins.zsh` — registro del plugin `Hanyang-Li/herdr-espresso`
- `zsh/modules/herdr/data/config.toml` — keybinding `espresso.toggle` y marcador `$espresso` en `[ui.sidebar.agents]`
- `zsh/modules/herdr/internal/install.zsh` — sin cambios (mecanismo de auto-instalación existente)
- Dependencia externa: CLI `espresso` en PATH (requisito del plugin, macOS)
- Requisitos del plugin: macOS, herdr 0.7.0+