## ADDED Requirements

### Requirement: Detect nix-darwin availability
The system SHALL detect whether nix-darwin is active on the current system.

#### Scenario: nix-darwin is detected
- **WHEN** `darwin-rebuild` is available in PATH
- **THEN** `ZSH_NIX_DARWIN` SHALL be set to `true`

### Requirement: Provide darwin::rebuild helper
The system SHALL provide a `nix::darwin::rebuild` shell function to rebuild the nix-darwin system configuration.

#### Scenario: Rebuild executes darwin-rebuild
- **WHEN** user runs `nix::darwin::rebuild`
- **THEN** `sudo darwin-rebuild switch --flake .#Lucho-MacBook` SHALL be executed in the dotfiles root directory

#### Scenario: Rebuild fails gracefully without nix-darwin
- **WHEN** user runs `nix::darwin::rebuild` on a system without nix-darwin
- **THEN** the function SHALL print an error message and return exit code 1

### Requirement: Provide darwin::update helper
The system SHALL provide a `nix::darwin::update` shell function to update nix-darwin inputs and rebuild.

#### Scenario: Update runs flake update then rebuild
- **WHEN** user runs `nix::darwin::update`
- **THEN** `nix flake update` SHALL be executed, followed by `nix::darwin::rebuild`

### Requirement: Provide darwin::status helper
The system SHALL provide a `nix::darwin::status` shell function to show the current nix-darwin status.

#### Scenario: Status shows active state
- **WHEN** user runs `nix::darwin::status` on a system with nix-darwin
- **THEN** it SHALL display "nix-darwin: active" with profile path and hostname

#### Scenario: Status shows inactive state
- **WHEN** user runs `nix::darwin::status` on a system without nix-darwin
- **THEN** it SHALL display "nix-darwin: not detected"

### Requirement: Provide bootstrap hint on macOS
The system SHALL show a bootstrap hint when running on macOS without nix-darwin installed.

#### Scenario: Bootstrap hint is shown
- **WHEN** zsh starts on macOS and `darwin-rebuild` is not found
- **THEN** a message SHALL be displayed with the command to bootstrap nix-darwin
