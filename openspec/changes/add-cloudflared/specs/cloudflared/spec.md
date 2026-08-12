## Purpose

Provides Cloudflare Tunnel (`cloudflared`) as a managed PATH-only tool in the devops module, so local services can be securely exposed over HTTPS without firewall changes.

## ADDED Requirements

### Requirement: cloudflared is available on PATH
The devops module SHALL ensure `cloudflared` is installed and resolvable on `PATH` after the module loads.

#### Scenario: Binary already present
- **WHEN** `cloudflared` is already on `PATH` at module load
- **THEN** the module does not reinstall and the existing binary is used

#### Scenario: Binary missing
- **WHEN** `cloudflared` is not on `PATH` at module load
- **THEN** the module installs it (binary download or apt) so it becomes available on `PATH`

### Requirement: Install is idempotent
The install routine SHALL be idempotent: running it repeatedly produces the same end state and never errors if the tool is already present.

#### Scenario: Repeated install
- **WHEN** the install routine runs twice in the same environment
- **THEN** the second run detects the existing binary and exits without re-downloading or failing

### Requirement: Tunnel helper functions
The module SHALL expose helper functions for the common tunnel operations: authenticate (`login`), create a named tunnel (`create`), route a DNS record to a tunnel (`route dns`), and start a quick ad-hoc tunnel (`tunnel --url`).

#### Scenario: Quick tunnel helper
- **WHEN** a user invokes the quick-tunnel helper with a local URL
- **THEN** `cloudflared tunnel --url <local-url>` is executed and a public HTTPS URL is returned

#### Scenario: DNS route helper
- **WHEN** a user invokes the route-dns helper with a hostname and tunnel id
- **THEN** `cloudflared tunnel route dns <tunnel-id> <hostname>` is executed

### Requirement: Respects user config location
The module SHALL not relocate or overwrite the tool's configuration; it SHALL rely on the default `~/.cloudflared/` directory managed by `cloudflared` itself.

#### Scenario: Config untouched
- **WHEN** the module loads or installs `cloudflared`
- **THEN** any existing `~/.cloudflared/` configuration is left intact
