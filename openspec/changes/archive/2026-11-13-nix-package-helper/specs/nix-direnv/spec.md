# Spec Delta

## MODIFIED Requirements

### Requirement: Detección correcta del plugin

The guard of installation SHALL verify plugin availability through `core::nix::package::exists` (aliasing to binary presence), and SHALL NOT rely on the absence of the service script for the plugin's verification. Reference to `nix profile list` checks is moved to the helper.

#### Scenario: direnv ausente pero plugin presente

- **WHEN** the binario `direnv` no está en PATH pero el plugin `nix-direnv` está instalado
- **THEN** el sistema SHALL NOT re-instalar el plugin

#### Scenario: direnv y plugin ausentes

- **WHEN** ni el binario `direnv` ni el plugin `nix-direnv` están disponibles
- **THEN** el sistema SHALL instalar el binario `direnv` y el plugin `nix-direnv` según el mecanismo de la plataforma

#### Scenario: Plugin installed via helper

- **WHEN** the helper is invoked to install the plugin with reference `NIX_DIRENV_NIX_PACKAGE`
- **THEN** system SHALL use `core::nix::package::install` rather than inline `nix profile list` checks