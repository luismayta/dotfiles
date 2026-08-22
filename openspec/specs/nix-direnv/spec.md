# nix-direnv Specification

## Purpose

Define el ciclo de vida del plugin `nix-direnv` (direnv para Nix) garantizando instalación idempotente: sin reinstalaciones por shell, sin duplicar lo que nix-darwin/home-manager ya gestiona, y preservando el comportamiento en Linux.

## Requirements

### Requirement: Instalación idempotente de nix-direnv
El sistema SHALL instalar el plugin `nix-direnv` solo cuando no esté disponible, y SHALL NOT reintentar la instalación en cada carga de shell cuando el plugin ya está presente o es gestionado externamente (nix-darwin/home-manager).

#### Scenario: Plugin ya instalado en Linux
- **WHEN** el módulo se carga y `nix-direnv` ya está en el profile activo del usuario
- **THEN** el sistema SHALL NOT ejecutar `nix profile install` ni `nix profile add` para `nix-direnv`

#### Scenario: Plugin ya gestionado por nix-darwin en macOS
- **WHEN** el módulo se carga en macOS y `nix-direnv` está gestionado por nix-darwin/home-manager (profile del sistema, no el profile del usuario)
- **THEN** el sistema SHALL NOT instalar `nix-direnv` en el profile del usuario

#### Scenario: Plugin ausente
- **WHEN** el módulo se carga y `nix-direnv` no está disponible ni gestionado externamente
- **THEN** el sistema SHALL instalar `nix-direnv` vía `nix profile` una única vez

### Requirement: Sin auto-instalación desde el módulo nix
El módulo nix (`zsh/system/nix`) SHALL NOT instalar `nix-direnv` automáticamente durante la carga del módulo. La instalación del plugin es responsabilidad del módulo devops.

#### Scenario: Carga del módulo nix
- **WHEN** el módulo `nix` se carga
- **THEN** el sistema SHALL NOT ejecutar la instalación de `nix-direnv` como parte de la carga

### Requirement: Detección correcta del plugin
El guard de instalación SHALL verificar la disponibilidad del plugin `nix-direnv` (p. ej. presencia del paquete en el profile o del direnvrc que lo referencia), y SHALL NOT usar la presencia del binario `direnv` como único criterio, porque el paquete `nix-direnv` no provee ese binario.

#### Scenario: direnv ausente pero plugin presente
- **WHEN** el binario `direnv` no está en PATH pero el plugin `nix-direnv` está instalado
- **THEN** el sistema SHALL NOT re-instalar el plugin

#### Scenario: direnv y plugin ausentes
- **WHEN** ni el binario `direnv` ni el plugin `nix-direnv` están disponibles
- **THEN** el sistema SHALL instalar el binario `direnv` y el plugin `nix-direnv` según el mecanismo de la plataforma

### Requirement: Detección de Nix en perfiles del sistema
El sistema SHALL detectar la instalación de Nix no solo en PATH sino también en los perfiles canónicos de nix-darwin/home-manager, para no reinstalar Nix cuando ya está gestionado externamente.

#### Scenario: Nix gestionado por nix-darwin
- **WHEN** `command -v nix` falla pero existe un binario `nix` en `/run/current-system/sw/bin/nix` o `/etc/profiles/per-user/${USER}/bin/nix`
- **THEN** el sistema SHALL considerar Nix instalado y SHALL NOT lanzar el instalador

#### Scenario: Nix en perfil de usuario
- **WHEN** `command -v nix` falla pero existe `${HOME}/.nix-profile/bin/nix`
- **THEN** el sistema SHALL considerar Nix instalado

### Requirement: Sin auto-instalación de Nix al cargar la shell
El sistema SHALL NOT ejecutar el instalador oficial de Nix de forma automática e interactiva durante la carga de la shell. Si Nix no está instalado, el sistema SHALL advertir con el comando de instalación sugerido y continuar sin bloquear.

#### Scenario: Nix ausente al cargar la shell
- **WHEN** la shell se carga y Nix no está instalado en ningún perfil detectado
- **THEN** el sistema SHALL mostrar una advertencia con la instrucción de instalación y SHALL NOT ejecutar el instalador

#### Scenario: Instalación explícita
- **WHEN** el usuario invoca explícitamente la instalación de Nix (`nix::install` o equivalente)
- **THEN** el sistema SHALL ejecutar el instalador oficial
