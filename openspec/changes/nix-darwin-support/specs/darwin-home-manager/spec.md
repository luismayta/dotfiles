## ADDED Requirements

### Requirement: Define home-manager user configuration
The system SHALL define a home-manager module in `nix/darwin/home.nix` for the user `lucho` on macOS.

#### Scenario: Home directory is set
- **WHEN** the home-manager configuration is applied
- **THEN** `home.homeDirectory` SHALL be `/Users/lucho`

#### Scenario: Home manager is enabled
- **WHEN** the home-manager configuration is built
- **THEN** `programs.home-manager.enable` SHALL be `true`

### Requirement: Configure zsh integration
The system SHALL configure `programs.zsh.initExtra` to source the nix-daemon profile script on macOS.

#### Scenario: nix-daemon is sourced in zsh
- **WHEN** a new zsh shell starts on macOS
- **THEN** the nix-daemon profile SHALL be sourced from `/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`

### Requirement: Configure session environment
The system SHALL set `home.sessionPath` and `home.sessionVariables` for the macOS user environment.

#### Scenario: Session path includes nix paths
- **WHEN** a new shell starts
- **THEN** `$PATH` SHALL include `/run/current-system/sw/bin`, `$HOME/.nix-profile/bin`, and `$HOME/.local/bin`

#### Scenario: Session variables are set
- **WHEN** a new shell starts
- **THEN** `EDITOR` SHALL be `nvim` and `LANG` SHALL be `en_US.UTF-8`

### Requirement: Configure direnv
The system SHALL enable direnv with nix-direnv support via home-manager.

#### Scenario: direnv is enabled
- **WHEN** the home-manager configuration is applied
- **THEN** `programs.direnv.enable` SHALL be `true` and `programs.direnv.nix-direnv.enable` SHALL be `true`

### Requirement: Define user-level packages
The system SHALL define user-level packages that are not system-wide: lazygit, bat, eza, zoxide, fzf.

#### Scenario: User packages are installed
- **WHEN** `home-manager switch` is executed
- **THEN** all specified user packages SHALL be available in the user's profile
