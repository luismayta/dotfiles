## MODIFIED Requirements

### Requirement: Variables de entorno con prefijo ZSH_GHQ_
El módulo SHALL exponer sus variables de entorno con el prefijo `ZSH_GHQ_` (`ZSH_GHQ_ENABLED`, `ZSH_GHQ_PACKAGE_NAME`, `ZSH_GHQ_PATH`, `ZSH_GHQ_DATA_PATH`, `ZSH_GHQ_ROOT`, `ZSH_GHQ_CACHE_PATH`, `ZSH_GHQ_CACHE_NAME`, `ZSH_GHQ_CACHE_PROJECT`, `ZSH_GHQ_FILE_COOKIECUTTER`, `ZSH_GHQ_REGEX_IS_REPOSITORY`, `ZSH_GHQ_GITHUB_USER`), con aliases backward-compat `GHQ_*` y `GITHUB_USER` apuntando a los canónicos. El default de `ZSH_GHQ_ROOT` SHALL ser `${HOME}/Projects/src`, determinista e independiente de la instalación o estado de `ghq` al cargar el módulo, y SHALL respetar cualquier valor previamente definido por el usuario en `ZSH_GHQ_ROOT` o `GHQ_ROOT`.

#### Scenario: Variables canónicas exportadas
- **WHEN** se carga `config/base.zsh` del módulo ghq
- **THEN** todas las variables de configuración existen con prefijo `ZSH_GHQ_` y están exportadas

#### Scenario: Aliases backward-compat presentes
- **WHEN** una shell existente referencia `GHQ_ROOT` o `GITHUB_USER`
- **THEN** el alias resuelve al valor del canónico `ZSH_GHQ_*` correspondiente

#### Scenario: Default determinista de GHQ_ROOT
- **WHEN** se carga el módulo sin `ZSH_GHQ_ROOT` ni `GHQ_ROOT` definidos en el entorno y sin depender de `ghq` instalado
- **THEN** `ZSH_GHQ_ROOT` y `GHQ_ROOT` resuelven a `${HOME}/Projects/src`

#### Scenario: Override del usuario respetado
- **WHEN** el usuario define `GHQ_ROOT` (o `ZSH_GHQ_ROOT`) en el entorno antes de cargar el módulo
- **THEN** el módulo usa ese valor y no lo sobrescribe con el default
