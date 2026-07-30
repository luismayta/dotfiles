## ADDED Requirements

### Requirement: Sync nix.conf on Linux
The system SHALL synchronize `nix/nix.conf` from the repository root to `~/.config/nix/nix.conf` when the Nix module loads on Linux.

#### Scenario: File does not exist at destination
- **WHEN** the nix module loads on Linux
- **AND** `~/.config/nix/nix.conf` does not exist
- **THEN** the system SHALL copy `nix/nix.conf` to `~/.config/nix/nix.conf`
- **AND** display an info message confirming the sync

#### Scenario: File exists and is identical
- **WHEN** the nix module loads on Linux
- **AND** `~/.config/nix/nix.conf` exists with identical content
- **THEN** the system SHALL NOT overwrite the file
- **AND** display a debug message indicating no change needed

#### Scenario: File exists but differs
- **WHEN** the nix module loads on Linux
- **AND** `~/.config/nix/nix.conf` exists with different content
- **THEN** the system SHALL display a warning with the diff
- **AND** SHALL NOT overwrite automatically (user must resolve manually)

### Requirement: macOS skip
On macOS, the system MUST skip nix.conf sync because nix-darwin manages it declaratively via `nix.settings`.

#### Scenario: macOS detected
- **WHEN** OSTYPE is darwin*
- **THEN** the system SHALL skip the nix.conf sync
