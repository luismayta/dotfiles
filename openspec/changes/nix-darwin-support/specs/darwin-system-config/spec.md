## ADDED Requirements

### Requirement: Define nix-darwin system module
The system SHALL define a nix-darwin module in `nix/darwin/default.nix` that configures the macOS system.

#### Scenario: Module evaluates without errors
- **WHEN** `nix flake check` is executed
- **THEN** the nix-darwin module SHALL evaluate without errors

#### Scenario: System packages are specified
- **WHEN** the nix-darwin configuration is applied
- **THEN** the following system packages SHALL be installed: git, zsh, rsync, jq, fd, ripgrep, direnv, glow, neovim, nushell, carapace

### Requirement: Enable nix-daemon and flakes
The system SHALL enable the nix-daemon service and experimental features (nix-command, flakes) for macOS.

#### Scenario: nix-daemon is enabled
- **WHEN** the nix-darwin configuration is built
- **THEN** `services.nix-daemon.enable` SHALL be `true`

#### Scenario: Experimental features are enabled
- **WHEN** the nix-darwin configuration is built
- **THEN** `nix.settings.experimental-features` SHALL include `"nix-command flakes"`

### Requirement: Configure macOS system defaults
The system SHALL configure macOS system defaults via nix-darwin's `system.defaults` for Dock, Finder, screenshots, and login window.

#### Scenario: Dock is configured
- **WHEN** the nix-darwin configuration is applied
- **THEN** the Dock SHALL have autohide enabled, MRU spaces disabled, and recents hidden

#### Scenario: Finder is configured
- **WHEN** the nix-darwin configuration is applied
- **THEN** Finder SHALL show all extensions, use column view, and show path/status bars

#### Scenario: Screenshot location is set
- **WHEN** the nix-darwin configuration is applied
- **THEN** screenshots SHALL be saved to `~/Pictures/screenshots`

### Requirement: Enable Touch ID for sudo
The system SHALL enable Touch ID authentication for sudo via `security.pam.enableSudoTouchIdAuth`.

#### Scenario: Touch ID sudo is enabled
- **WHEN** the nix-darwin configuration is built
- **THEN** `security.pam.enableSudoTouchIdAuth` SHALL be `true`

### Requirement: Set host platform
The system SHALL set the Nixpkgs host platform to `aarch64-darwin` for Apple Silicon Macs.

#### Scenario: Host platform is set
- **WHEN** the nix-darwin configuration is evaluated
- **THEN** `nixpkgs.hostPlatform` SHALL be `"aarch64-darwin"`
