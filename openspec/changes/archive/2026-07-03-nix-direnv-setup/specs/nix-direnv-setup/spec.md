## ADDED Requirements

### Requirement: Crear direnvrc en data/sync
El sistema SHALL tener un archivo `direnvrc` en `zsh/modules/nix/data/sync/.config/direnv/direnvrc` con el contenido:
```
source $HOME/.nix-profile/share/nix-direnv/direnvrc
```

#### Scenario: Archivo creado
- **WHEN** se inspecciona `zsh/modules/nix/data/sync/.config/direnv/direnvrc`
- **THEN** el archivo SHALL existir con la línea `source $HOME/.nix-profile/share/nix-direnv/direnvrc`

### Requirement: Instalar paquete nix-direnv
El sistema SHALL instalar `nix-direnv` via `nix profile install nixpkgs#nix-direnv` durante el bootstrap del módulo.
La instalación SHALL ejecutarse solo si `nix-direnv` no está ya presente en el perfil activo.

#### Scenario: Fresh install
- **WHEN** el módulo carga y `nix-direnv` no está en el perfil activo
- **THEN** el sistema SHALL ejecutar `nix profile install nixpkgs#nix-direnv`

#### Scenario: Already installed
- **WHEN** el módulo carga y `nix-direnv` ya está en el perfil activo
- **THEN** el sistema SHALL saltar la instalación

### Requirement: Función nix::sync
El sistema SHALL proveer una función `nix::sync` que rsynce `data/sync/` a `$HOME/`.
La función SHALL ser idempotente.

#### Scenario: Ejecutar sync
- **WHEN** se ejecuta `nix::sync`
- **THEN** SHALL correr `rsync -avzh --progress "${NIX_DATA_PATH}/sync/" "${HOME}/"`

#### Scenario: Idempotente
- **WHEN** se ejecuta `nix::sync` múltiples veces
- **THEN** el resultado SHALL ser el mismo que la primera ejecución

### Requirement: Registrar nix en DOTFILES_SYNC_MODULES
El sistema SHALL incluir `nix` en el array `DOTFILES_SYNC_MODULES` en `zsh/core/pkg/sync.zsh`
para que `dotfiles::sync` ejecute `nix::sync` automáticamente.

#### Scenario: Sync orquestado
- **WHEN** se ejecuta `dotfiles::sync`
- **THEN** SHALL invocar `nix::sync` como parte del pipeline

### Requirement: Transparente a proyectos
El sistema SHALL NO requerir cambios en ningún `.envrc`. Los proyectos que usan `use flake`
SHALL automáticamente beneficiarse de la evaluación cacheada de nix-direnv.

#### Scenario: Proyecto flake existente
- **WHEN** un proyecto tiene `.envrc` con `use flake`
- **THEN** direnv SHALL usar la implementación cacheada de nix-direnv sin modificar `.envrc`

#### Scenario: Nuevo proyecto flake
- **WHEN** un nuevo proyecto crea `.envrc` con `use flake`
- **THEN** direnv SHALL usar la implementación cacheada de nix-direnv automáticamente
