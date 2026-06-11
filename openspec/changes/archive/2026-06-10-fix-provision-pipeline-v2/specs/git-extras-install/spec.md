## ADDED Requirements

### Requirement: git-extras install documentado
El sistema SHALL documentar la instalación manual de git-extras para usuarios que lo requieran. NO se instalará automáticamente durante el pipeline curl|bash.

#### Scenario: Usuario lee documentación post-instalación
- **WHEN** el usuario completa la instalación via curl|bash
- **THEN** el sistema informa que git-extras está disponible para instalación manual
- **AND** el sistema NO ejecuta ningún comando con sudo

#### Scenario: Instalación manual exitosa
- **WHEN** el usuario ejecuta el comando documentado para instalar git-extras
- **THEN** git-extras se instala sin necesidad de sudo
- **AND** el usuario puede usar comandos `git extras` inmediatamente

### Requirement: git-extras removido de APPS automáticas
El array `APPS` en `provision/script/config/base.sh` NO DEBE incluir `git-extras`. La instalación automática via pipeline está desactivada.

#### Scenario: Pipeline no instala git-extras
- **WHEN** `install.sh` ejecuta `dotfiles_install_apps()`
- **THEN** `git-extras` NO está en la lista de apps a instalar
- **AND** `tools/git-extras/install.sh` NO se ejecuta

### Requirement: tools/git-extras/install.sh preservado
El archivo `tools/git-extras/install.sh` DEBE conservarse como referencia para instalación manual. No se elimina.

#### Scenario: Script disponible para instalación manual
- **WHEN** el usuario navega a `tools/git-extras/install.sh`
- **THEN** el script contiene las instrucciones para instalar git-extras manualmente