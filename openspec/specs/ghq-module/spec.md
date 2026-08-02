# ghq-module Specification

## Purpose
TBD - created by archiving change refactor-ghq-module. Update Purpose after archive.
## Requirements
### Requirement: Variables de entorno con prefijo ZSH_GHQ_
El módulo SHALL exponer sus variables de entorno con el prefijo `ZSH_GHQ_` (`ZSH_GHQ_ENABLED`, `ZSH_GHQ_PACKAGE_NAME`, `ZSH_GHQ_PATH`, `ZSH_GHQ_DATA_PATH`, `ZSH_GHQ_ROOT`, `ZSH_GHQ_CACHE_PATH`, `ZSH_GHQ_CACHE_NAME`, `ZSH_GHQ_CACHE_PROJECT`, `ZSH_GHQ_FILE_COOKIECUTTER`, `ZSH_GHQ_REGEX_IS_REPOSITORY`, `ZSH_GHQ_GITHUB_USER`), con aliases backward-compat `GHQ_*` y `GITHUB_USER` apuntando a los canónicos.

#### Scenario: Variables canónicas exportadas
- **WHEN** se carga `config/base.zsh` del módulo ghq
- **THEN** todas las variables de configuración existen con prefijo `ZSH_GHQ_` y están exportadas

#### Scenario: Aliases backward-compat presentes
- **WHEN** una shell existente referencia `GHQ_ROOT` o `GITHUB_USER`
- **THEN** el alias resuelve al valor del canónico `ZSH_GHQ_*` correspondiente

### Requirement: Instalación delegada al core
El módulo SHALL instalar `ghq` a través de `core::install` / `core::ensure`, sin reimplementar dispatch por plataforma (brew/paru) en `internal/`.

#### Scenario: ghq ausente dispara core::ensure
- **WHEN** `ghq` no está en `$PATH` y se carga el módulo
- **THEN** `internal/main.zsh` invoca `core::ensure "${ZSH_GHQ_PACKAGE_NAME}"` y el core resuelve el instalador por plataforma

#### Scenario: Sin dispatch manual en internal/base.zsh
- **WHEN** se inspecciona `internal/base.zsh`
- **THEN** no contiene `case`/condicionales `brew`/`paru` para instalar ghq

### Requirement: Templates en data/
El módulo SHALL almacenar sus templates cookiecutter en `data/` (`ZSH_GHQ_DATA_PATH`), habiendo movido `resources/data.json` y eliminado `resources/`.

#### Scenario: data.json en data/
- **WHEN** se inspecciona el árbol del módulo
- **THEN** existe `data/data.json` y `resources/` ya no existe

#### Scenario: Ruta de templates configurable
- **WHEN** se consulta `ZSH_GHQ_DATA_PATH`
- **THEN** apunta a `${ZSH_GHQ_PATH}/data` y `ZSH_GHQ_FILE_COOKIECUTTER` referencia el archivo dentro de esa ruta

### Requirement: Contrato público completo
El módulo SHALL exponer `ghq::install`, `ghq::sync` y `ghq::setup` como funciones públicas en `pkg/`, con `ghq::setup` como orchestrator en `pkg/helper.zsh`.

#### Scenario: API pública disponible
- **WHEN** se carga el módulo y se consulta `type ghq::install`, `type ghq::sync`, `type ghq::setup`
- **THEN** las tres responden `function`

#### Scenario: setup orquesta install
- **WHEN** se ejecuta `ghq::setup` con ghq ausente
- **THEN** instala ghq y reporta éxito con `message_*`

### Requirement: Naming interno sin redundancia
El módulo SHALL nombrar sus funciones internas con el patrón `<name>::internal::<verb>`; `ghq::internal::ghq::install` SHALL ser renombrada a `ghq::internal::install`.

#### Scenario: Sin función con doble ghq
- **WHEN** se enumeran las funciones internas del módulo
- **THEN** ninguna se llama `ghq::internal::ghq::*`

#### Scenario: Interpolación en mensaje de carga
- **WHEN** se carga el módulo
- **THEN** el mensaje "Loading module" usa `${ZSH_GHQ_PACKAGE_NAME}` y no el literal "ghq"

