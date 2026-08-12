## Purpose

Provides Caddy as a managed PATH-only web server / reverse-proxy tool in the devops module, so local services can be served, proxied, and exposed over automatic HTTPS for development without manual TLS or nginx config.

## ADDED Requirements

### Requirement: caddy is available on PATH
The devops module SHALL ensure `caddy` is installed and resolvable on `PATH` after the module loads.

#### Scenario: Binary already present
- **WHEN** `caddy` is already on `PATH` at module load
- **THEN** the module does not reinstall and the existing binary is used

#### Scenario: Binary missing
- **WHEN** `caddy` is not on `PATH` at module load
- **THEN** the module installs it (brew on macOS, apt/official script on Linux) so it becomes available on `PATH`

### Requirement: Install is idempotent
The install routine SHALL be idempotent: running it repeatedly produces the same end state and never errors if the tool is already present.

#### Scenario: Repeated install
- **WHEN** the install routine runs twice in the same environment
- **THEN** the second run detects the existing binary and exits without re-installing or failing

### Requirement: Helper functions are exposed
The module SHALL expose public helper functions for the common operations: `install`, `upgrade`, and `post_install` (usage guidance).

#### Scenario: post_install guidance
- **WHEN** a user invokes the `post_install` helper
- **THEN** it prints usage guidance covering `caddy run`, `caddy file-server`, and `caddy reverse-proxy`

#### Scenario: upgrade delegates to caddy
- **WHEN** a user invokes the `upgrade` helper
- **THEN** `caddy upgrade` is executed to refresh the binary in place

### Requirement: Registration and module load integrity
The module SHALL register `caddy` in the three `main.zsh` files (`config/`, `internal/`, `pkg/`) and add `"caddy"` to the `DEVOPS_TOOLS` array in `config/base.zsh`, and the devops module SHALL load without errors after registration.

#### Scenario: Module loads cleanly
- **WHEN** the devops module sources its `main.zsh` files with caddy registered
- **THEN** the module loads without shell errors and `caddy` is resolvable when installed

### Requirement: Respects user config location
The module SHALL not relocate or overwrite the tool's configuration; it SHALL rely on Caddy's default config location (`~/.config/caddy/`) managed by `caddy` itself, and the module SHALL NOT manage a `Caddyfile` or `data/caddy/` directory by default.

#### Scenario: Config untouched
- **WHEN** the module loads or installs `caddy`
- **THEN** any existing `~/.config/caddy/` configuration is left intact and no `data/caddy/` directory is created by the module
