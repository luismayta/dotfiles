## ADDED Requirements

### Requirement: Template flake.nix SHALL include a default devShell
The generic `flake.nix` template at `zsh/modules/nix/data/templates/flake.nix` SHALL include a `devShells.default` so that `nix develop` works out-of-the-box after scaffolding.

#### Scenario: Scaffold with generic template
- **WHEN** user runs `nix::scaffold::init` or copies the generic template
- **THEN** the generated `flake.nix` SHALL contain a `devShells.default` section
- **AND** `nix develop` SHALL succeed without additional configuration

### Requirement: Minimal package list
The default devShell SHALL include no packages (`pkgs.mkShell { packages = []; }`) to remain editor-agnostic, letting users add their own toolchain.

#### Scenario: nix develop with empty devShell
- **WHEN** user runs `nix develop` on a project scaffolded with the generic template
- **THEN** a shell SHALL open with only the base Nix environment
- **AND** no additional packages SHALL be pre-installed
