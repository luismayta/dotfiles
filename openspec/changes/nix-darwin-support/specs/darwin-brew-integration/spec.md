## ADDED Requirements

### Requirement: Enable Homebrew integration
The system SHALL enable Homebrew integration via nix-darwin's `homebrew.enable` in `nix/darwin/brew.nix`.

#### Scenario: Homebrew module is enabled
- **WHEN** the nix-darwin configuration is built
- **THEN** `homebrew.enable` SHALL be `true`

#### Scenario: Cleanup on activation
- **WHEN** the nix-darwin configuration is applied
- **THEN** `homebrew.onActivation.cleanup` SHALL be `"zap"` to remove orphaned packages

### Requirement: Define brew casks and brews
The system SHALL define an extensible list of Homebrew casks (GUI apps) and brews (CLI tools) that starts empty.

#### Scenario: Casks list is extensible
- **WHEN** a user adds a cask to `homebrew.casks`
- **THEN** nix-darwin SHALL install the cask on next rebuild

#### Scenario: Brews list is extensible
- **WHEN** a user adds a brew to `homebrew.brews`
- **THEN** nix-darwin SHALL install the brew on next rebuild
