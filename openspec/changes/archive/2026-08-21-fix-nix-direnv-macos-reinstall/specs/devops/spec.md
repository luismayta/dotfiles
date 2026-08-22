## ADDED Requirements

### Requirement: Gestión de direnv y nix-direnv en devops
El módulo devops SHALL ser el único responsable de instalar `direnv` y el plugin `nix-direnv`, con instalación idempotente y sin duplicar gestión externa (nix-darwin/home-manager en macOS).

#### Scenario: Plugin gestionado por nix-darwin en macOS
- **WHEN** el módulo devops se carga en macOS y `nix-direnv` está gestionado por nix-darwin/home-manager
- **THEN** el sistema SHALL NOT instalar el plugin en el profile del usuario

#### Scenario: Instalación manual explícita
- **WHEN** el usuario invoca `devops::direnv::install` explícitamente
- **THEN** el sistema SHALL instalar `direnv` y/o el plugin `nix-direnv` solo si faltan, y SHALL reportar el resultado sin error cuando ya están presentes
