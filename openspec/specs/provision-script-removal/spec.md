# provision-script-removal

## Purpose

Eliminar el directorio `provision/script/` del repositorio y migrar sus responsabilidades a `install.sh`: eliminar el directorio y sus archivos sin dejar rastros, remover referencias a `provision/script/` en `install.sh`, conservar la copia fresh de `zsh/zshrc` y `zsh/zshenv` a `$HOME`, eliminar referencias vivas a sus símbolos, y actualizar el comentario de `config/packages.sh`.

## Requirements

### Requirement: provision/script/ eliminado del repositorio
El directorio `provision/script/` SHALL quedar completamente eliminado del repositorio, incluyendo todos sus archivos (`bootstrap.sh`, `run.sh`, `test.sh`, `config/`, `functions.sh`).

#### Scenario: Los archivos no existen
- **WHEN** se inspecciona el árbol del repositorio tras aplicar el cambio
- **THEN** ninguno de los 6 archivos de `provision/script/` existe en el working tree

#### Scenario: Sin rastros en git status
- **WHEN** se ejecuta `git status` tras el commit del cambio
- **THEN** no aparece ninguna entrada referida a `provision/script/`

### Requirement: install.sh sin referencias a provision/script
`install.sh` SHALL dejar de referenciar el directorio `provision/script/` en su contenido.

#### Scenario: Grep sin resultados en install.sh
- **WHEN** se ejecuta `grep "provision/script" install.sh`
- **THEN** el resultado es vacío (0 coincidencias)

#### Scenario: El flujo clone_repo finaliza sin ejecutar run.sh
- **WHEN** `install.sh` ejecuta el flujo de instalación hasta el final del bloque que hoy invoca run.sh
- **THEN** no se ejecuta `provision/script/run.sh` en ningún punto

### Requirement: La instalación fresh conserva la copia de zsh/zshrc y zsh/zshenv a $HOME
`install.sh` SHALL copiar `zsh/zshrc` y `zsh/zshenv` a `$HOME` durante la instalación, preservando el comportamiento fresh actual.

#### Scenario: Ambos archivos se copian a $HOME
- **WHEN** se inspecciona `install.sh` tras el cambio
- **THEN** contiene un `cp` de `zsh/zshrc` a `$HOME` y un `cp` de `zsh/zshenv` a `$HOME`

#### Scenario: Instalación fresh con zshrc ausente produce ~/.zshrc
- **WHEN** se instala en una máquina donde `~/.zshrc` no existe (flujo fresh via curl|bash)
- **THEN** tras la instalación existe `~/.zshrc` con el contenido de `zsh/zshrc`

### Requirement: Sin referencias vivas a símbolos de provision/script
Ningún código vivo fuera del directorio SHALL referenciar los símbolos de `provision/script/` (`bootstrap.sh`, `functions.sh`, `run.sh`, `test.sh`).

#### Scenario: grep de bootstrap.sh acotado a docs
- **WHEN** se ejecuta `grep "bootstrap.sh"` sobre el código vivo (excluyendo `.git`, `openspec`, `graphify-out`, `.codi`)
- **THEN** las únicas coincidencias son documentación de `docs/` o artefactos de `openspec/`

#### Scenario: grep de functions.sh acotado a docs
- **WHEN** se ejecuta `grep "functions.sh"` sobre el código vivo (excluyendo `.git`, `openspec`, `graphify-out`, `.codi`)
- **THEN** las únicas coincidencias son documentación de `docs/` o artefactos de `openspec/`

### Requirement: Comentario de config/packages.sh actualizado
La línea 4 de `config/packages.sh` SHALL dejar de mencionar "provision scripts" y reflejar únicamente su nuevo origen de sourcing.

#### Scenario: La línea 4 no menciona provision scripts
- **WHEN** se lee la línea 4 de `config/packages.sh`
- **THEN** el texto no contiene la cadena "provision scripts"

#### Scenario: La línea 4 menciona solo install.sh
- **WHEN** se lee la línea 4 de `config/packages.sh`
- **THEN** el texto indica que el archivo es sourced únicamente por `install.sh`
