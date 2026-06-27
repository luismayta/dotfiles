## 1. Core Nix Layer

- [x] 1.1 Create `zsh/core/internal/nix.zsh` with `core::internal::nix::install` (official script --no-daemon) and `core::internal::nix::exists`
- [x] 1.2 Create `zsh/core/pkg/nix.zsh` with public API: `core::nix::install`, `core::nix::exists`, `core::nix::ensure`
- [x] 1.3 Update `zsh/core/config/paths.zsh` to add Nix paths (`~/.nix-profile/bin`, `/nix/var/nix/profiles/default/bin`) to PATH
- [x] 1.4 Update `zsh/core/config/env.zsh` to add `CORE_MESSAGE_NIX`, `NIX_CONF_DIR`, `NIXPKGS_ALLOW_UNFREE=1`
- [x] 1.5 Update `zsh/core/internal/main.zsh` to source `internal/nix.zsh`
- [x] 1.6 Update `zsh/core/pkg/main.zsh` to source `pkg/nix.zsh`

## 2. Nix Module — Scaffold

- [x] 2.1 Create directory structure: `zsh/modules/nix/config/`, `zsh/modules/nix/internal/`, `zsh/modules/nix/pkg/`
- [x] 2.2 Create `plugin.zsh` with idempotency guard `__ZSH_NIX_LOADED`, module path `ZSH_NIX_PATH`, chain `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`
- [x] 2.3 Create `config/main.zsh` with OS dispatch (osx/linux)
- [x] 2.4 Create `config/base.zsh` with exports: `NIX_PACKAGE_NAME=nix`, `NIX_INSTALL_URL=https://nixos.org/nix/install`, `NIX_CONF_DIR`
- [x] 2.5 Create `config/osx.zsh` and `config/linux.zsh` as empty placeholders

## 3. Nix Module — Internal Layer

- [x] 3.1 Create `internal/main.zsh` that sources `base.zsh` + OS dispatch, runs `core::ensure nix` for auto-installation
- [x] 3.2 Create `internal/base.zsh` with `nix::internal::nix::install` function that delegates to `core::nix::ensure` (no installer script — lives in core)
- [x] 3.3 Create `internal/osx.zsh` and `internal/linux.zsh` as empty placeholders

## 4. Nix Module — Public API

- [x] 4.1 Create `pkg/main.zsh` that sources `base.zsh` + OS dispatch
- [x] 4.2 Create `pkg/base.zsh` with public functions:
  - `nix::install` — delegates to `core::ensure nix`
  - `nix::channel::set <channel>` — switches channel via `nix-channel --add` + `nix-channel --update`
  - `nix::channel::list` — runs `nix-channel --list`
  - `nix::gc` — runs `nix-collect-garbage -d`
- [x] 4.3 Create `pkg/osx.zsh`, `pkg/linux.zsh`, `pkg/alias.zsh`, `pkg/helper.zsh` as empty placeholders

## 5. Devbox Module — Scaffold

- [x] 5.1 Create directory structure: `zsh/modules/devbox/config/`, `zsh/modules/devbox/internal/`, `zsh/modules/devbox/pkg/`, `zsh/modules/devbox/data/`
- [x] 5.2 Create `plugin.zsh` with idempotency guard `__ZSH_DEVBOX_LOADED`, module path `ZSH_DEVBOX_PATH`, chain `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`
- [x] 5.3 Create `config/main.zsh` with OS dispatch (osx/linux)
- [x] 5.4 Create `config/base.zsh` with exports: `DEVBOX_PACKAGE_NAME=devbox`, `DEVBOX_DATA_PATH`, `DEVBOX_GLOBAL_CONFIG_PATH`
- [x] 5.5 Create `config/osx.zsh` and `config/linux.zsh` as empty placeholders

## 6. Devbox Module — Internal Layer

- [x] 6.1 Create `internal/main.zsh` that sources `base.zsh` + OS dispatch, then runs `core::ensure nix` followed by `core::ensure devbox`
- [x] 6.2 Create `internal/base.zsh` with `devbox::internal::devbox::install` function that:
  - First checks `core::ensure nix` (pre-flight Nix check)
  - Then detects brew/paru and installs Devbox
  - Shows fallback warning if no package manager found
- [x] 6.3 Create `internal/osx.zsh` and `internal/linux.zsh` as empty placeholders

## 7. Devbox Module — Public API

- [x] 7.1 Create `pkg/main.zsh` that sources `base.zsh` + OS dispatch + `alias.zsh`
- [x] 7.2 Create `pkg/base.zsh` with public functions:
  - `devbox::install` — delegates to `core::ensure devbox`
  - `devbox::sync` — runs rsync from `DEVBOX_DATA_PATH` to `~/.config/devbox/`
  - `devbox::shell` — runs `devbox shell` in current directory
  - `devbox::init` — runs `devbox init` in current directory
- [x] 7.3 Create `pkg/osx.zsh` and `pkg/linux.zsh` as empty placeholders
- [x] 7.4 Create `pkg/alias.zsh` with alias `dbx=devbox`
- [x] 7.5 Create `pkg/helper.zsh` as empty placeholder

## 8. Configuration & Data

- [x] 8.1 Create `data/devbox.json` with a minimal global Devbox configuration template
- [x] 8.2 Create `keybindings.zsh` with optional ZLE keybinding (commented out by default, `^Xd`)

## 9. Verification

- [x] 9.1 Verify Nix module directory structure (`zsh/modules/nix/` — config/, internal/, pkg/ + plugin.zsh)
- [x] 9.2 Verify Devbox module directory structure (`zsh/modules/devbox/` — config/, internal/, pkg/, data/ + plugin.zsh)
- [x] 9.3 Verify all files have correct shebang and no syntax errors
- [x] 9.4 Verify idempotency guards work for both modules
- [x] 9.5 Run `zsh -n zsh/modules/nix/plugin.zsh` and `zsh -n zsh/modules/devbox/plugin.zsh` to validate syntax
