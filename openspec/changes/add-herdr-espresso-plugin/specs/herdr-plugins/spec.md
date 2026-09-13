## Purpose

Define el registro declarativo de plugins del módulo herdr de dotfiles: qué plugins se instalan automáticamente al cargar el módulo y cómo se integran con la UI de herdr (keybindings y marcadores de barra lateral).

## ADDED Requirements

### Requirement: Registro declarativo de plugins herdr
El sistema SHALL registrar el plugin `Hanyang-Li/herdr-espresso` en el array `ZSH_HERDR_INSTALL_PLUGINS` de `zsh/modules/herdr/config/plugins.zsh`, de modo que el módulo lo instale automáticamente al cargar.

#### Scenario: Plugin registrado en el array de plugins
- **WHEN** el usuario inspecciona `zsh/modules/herdr/config/plugins.zsh`
- **THEN** el array `ZSH_HERDR_INSTALL_PLUGINS` incluye la entrada `Hanyang-Li/herdr-espresso`

#### Scenario: Plugin instalado automáticamente al cargar el módulo
- **WHEN** el módulo herdr se carga en una sesión zsh nueva
- **THEN** el sistema ejecuta la instalación del plugin (`herdr plugin install Hanyang-Li/herdr-espresso --yes`)
- **AND** `herdr plugin list` incluye `herdr-espresso` entre los plugins instalados

### Requirement: Keybinding para toggle del monitoreo espresso
El sistema SHALL configurar el keybinding `espresso.toggle` en `zsh/modules/herdr/data/config.toml` para activar o desactivar el monitoreo de suspensión en el panel de agente enfocado.

#### Scenario: Toggle del monitoreo en panel de agente
- **WHEN** el usuario presiona la tecla asignada a `espresso.toggle` con un panel de agente enfocado
- **THEN** el sistema activa o desactiva el monitoreo de suspensión para ese panel
- **AND** la Mac permanece despierta mientras el agente del panel está trabajando

#### Scenario: Rechazo en panel sin agente
- **WHEN** el usuario presiona la tecla asignada a `espresso.toggle` con un panel de shell plano enfocado
- **THEN** el sistema muestra una notificación de rechazo
- **AND** no se activa el monitoreo

### Requirement: Marcador de barra lateral para paneles monitoreados
El sistema SHALL configurar el marcador `$espresso` en la sección `[ui.sidebar.agents]` de `zsh/modules/herdr/data/config.toml` para visualizar qué paneles de agente están siendo monitoreados.

#### Scenario: Panel monitoreado muestra marcador espresso
- **WHEN** un panel de agente tiene el monitoreo espresso activo
- **THEN** la barra lateral muestra la etiqueta `espresso` junto a ese panel

### Requirement: Instalación automática del CLI espresso en macOS
El sistema SHALL instalar automáticamente el CLI `espresso` en macOS al cargar el módulo herdr si no está presente en `PATH`, usando el instalador oficial del proyecto espresso.

#### Scenario: CLI espresso ausente en macOS
- **WHEN** el módulo herdr se carga en macOS y el CLI `espresso` no está en `PATH`
- **THEN** el sistema ejecuta el instalador oficial de espresso
- **AND** el CLI `espresso` queda disponible en `PATH`

#### Scenario: CLI espresso ya instalado
- **WHEN** el módulo herdr se carga y el CLI `espresso` ya está en `PATH`
- **THEN** el sistema omite la instalación

#### Scenario: Plataforma no macOS
- **WHEN** el módulo herdr se carga en un sistema que no es macOS
- **THEN** el sistema omite la instalación del CLI espresso (el plugin es macOS-only)

### Requirement: Instalación opcional del daemon espresso
El sistema SHALL proveer una función para instalar el daemon de espresso (`espresso daemon install`) que mantiene la Mac despierta con la tapa cerrada.

#### Scenario: Instalación del daemon
- **WHEN** el usuario invoca la función de instalación del daemon espresso
- **THEN** el sistema ejecuta `espresso daemon install` (requiere sudo)
- **AND** la Mac permanece despierta con la tapa cerrada mientras el agente trabaja