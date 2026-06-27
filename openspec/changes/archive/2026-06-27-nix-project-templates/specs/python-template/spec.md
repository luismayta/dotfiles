## ADDED Requirements

### Requirement: Python project flake template
The system SHALL provide a Nix flake template for Python projects under `data/templates/python/flake.nix`.

The template SHALL include:
- `nixpkgs` input pointing to `nixpkgs-unstable`
- A `devShells.default` with: `python3`, `uv`, `ruff`, `mypy`
- Shell hook that creates a virtual environment via `uv venv` if not present
- A `formatter` output pointing to `nixpkgs-fmt`

#### Scenario: Template creates devShell with Python toolchain
- **WHEN** a user runs `nix::scaffold::new /path --lang python`
- **THEN** the resulting `flake.nix` SHALL contain `python3`, `uv`, `ruff`, and `mypy` in `devShells.default.buildInputs`

#### Scenario: uv creates virtualenv on devShell entry
- **WHEN** a user enters `nix develop` in a project scaffolded with `--lang python`
- **THEN** a `.venv` directory SHALL be created by the shell hook if not already present

#### Scenario: Template is idempotent
- **WHEN** the template is applied twice to the same directory
- **THEN** the existing `flake.nix` SHALL NOT be overwritten
