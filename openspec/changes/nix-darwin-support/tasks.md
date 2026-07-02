## 1. Agregar Inputs al Flake

- [ ] 1.1 Agregar nix-darwin como input a `flake.nix` con `follows = "nixpkgs"`
- [ ] 1.2 Agregar home-manager como input a `flake.nix` con `follows = "nixpkgs"`
- [ ] 1.3 Agregar `darwinConfigurations."Lucho-MacBook"` como output usando `//` para mergear attrsets
- [ ] 1.4 Verificar con `nix flake show` que el output `darwinConfigurations` aparece sin romper `devShells`

## 2. Crear Módulo de Sistema nix-darwin

- [ ] 2.1 Crear `nix/darwin/default.nix` con configuración de sistema: nix-daemon, experimental-features, build users
- [ ] 2.2 Configurar `nixpkgs.hostPlatform = "aarch64-darwin"`
- [ ] 2.3 Habilitar `security.pam.enableSudoTouchIdAuth`
- [ ] 2.4 Configurar `system.defaults` para Dock, Finder, screenshots y login window
- [ ] 2.5 Definir paquetes de sistema: git, zsh, rsync, jq, fd, ripgrep, direnv, glow, neovim, nushell, carapace
- [ ] 2.6 Versionar `nix/nix.conf` como referencia para instalaciones manuales en Linux
- [ ] 2.7 Verificar que el módulo evalúa sin errores con `nix flake check`

## 3. Crear Módulo home-manager

- [ ] 3.1 Crear `nix/darwin/home.nix` con `home.username = "lucho"` y `home.homeDirectory = "/Users/lucho"`
- [ ] 3.2 Configurar `programs.zsh.initExtra` para sourcear nix-daemon profile
- [ ] 3.3 Configurar `home.sessionPath` y `home.sessionVariables` (EDITOR, LANG)
- [ ] 3.4 Habilitar `programs.direnv` con `nix-direnv`
- [ ] 3.5 Definir paquetes de usuario: lazygit, bat, eza, zoxide, fzf

## 4. Crear Módulo Homebrew

- [ ] 4.1 Crear `nix/darwin/brew.nix` con `homebrew.enable = true`
- [ ] 4.2 Configurar `homebrew.onActivation.cleanup = "zap"`
- [ ] 4.3 Definir listas extensibles de casks y brews (inicialmente vacías)
- [ ] 4.4 Verificar integración con nix-darwin — el módulo evalúa sin errores

## 5. Crear Módulo ZSH Independiente nix-darwin

- [ ] 5.1 Crear estructura `zsh/modules/nix-darwin/` con `plugin.zsh` y directorio `config/`
- [ ] 5.2 Crear `config/base.zsh` con `ZSH_NIX_DARWIN_ENABLED="${ZSH_NIX_DARWIN_ENABLED:-true}"` y variables de ruta
- [ ] 5.3 Crear `config/main.zsh` con dispatch por OSTYPE (osx → osx.zsh, linux → linux.zsh)
- [ ] 5.4 Crear `config/linux.zsh` con `export ZSH_NIX_DARWIN_ENABLED=false` (auto-disable en Linux)
- [ ] 5.5 Crear `config/osx.zsh` con función `nix::darwin::rebuild` que ejecuta `sudo darwin-rebuild switch --flake .#Lucho-MacBook`
- [ ] 5.6 Crear `config/osx.zsh` con función `nix::darwin::update` que ejecuta `nix flake update` + rebuild
- [ ] 5.7 Crear `config/osx.zsh` con función `nix::darwin::status` que muestra estado activo/inactivo
- [ ] 5.8 Crear `config/osx.zsh` con hint de bootstrap en macOS sin nix-darwin instalado
- [ ] 5.9 Verificar que el módulo se carga en zsh sin errores y `$ZSH_NIX_DARWIN_ENABLED` es `false` en Linux

## 6. Verificación Final

- [ ] 6.1 `nix flake show` en Linux — outputs `devShells` intactos + `darwinConfigurations` presente
- [ ] 6.2 `nix flake check` sin errores
- [ ] 6.3 Los helpers zsh `nix::darwin::*` se muestran en `which nix::darwin::` sin errores
- [ ] 6.4 El módulo zsh existente en Linux sigue funcionando: `nix build`, `nix flake show`
