## 1. Archivo de configuración

- [x] 1.1 Crear `zsh/modules/nix/data/sync/.config/direnv/direnvrc` con `source $HOME/.nix-profile/share/nix-direnv/direnvrc`

## 2. Instalación del paquete

- [x] 2.1 Crear `zsh/modules/nix/internal/direnv.zsh` con función `nix::internal::direnv::setup`
- [x] 2.2 Implementar instalación idempotente: verificar si `nix-direnv` ya está en el perfil antes de `nix profile install`
- [x] 2.3 Sourcear `direnv.zsh` desde `zsh/modules/nix/internal/main.zsh` (tras la llamada a `nix::install`)

## 3. Función sync

- [x] 3.1 Agregar `nix::sync` a `zsh/modules/nix/pkg/base.zsh` que delegue a `nix::internal::config::sync`
- [x] 3.2 Implementar `nix::internal::config::sync` en `zsh/modules/nix/internal/base.zsh` con rsync de `data/sync/` a `$HOME/`
- [x] 3.3 Agregar variable `NIX_DATA_PATH` en `zsh/modules/nix/config/base.zsh`

## 4. Orquestación global

- [x] 4.1 Agregar `nix` al array `DOTFILES_SYNC_MODULES` en `zsh/core/pkg/sync.zsh`
