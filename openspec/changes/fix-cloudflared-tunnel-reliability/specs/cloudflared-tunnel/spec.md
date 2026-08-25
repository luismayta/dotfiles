## Purpose

Provides reliable cloudflared tunnel lifecycle management — creation, UUID resolution, config generation, DNS routing, and pre-flight validation — within the devops zsh module.

## ADDED Requirements

### Requirement: UUID lookup uses JSON output

The tunnel create function SHALL resolve tunnel UUIDs by parsing `cloudflared tunnel list --format json` output with `jq`, rather than fragile `tail | awk` text parsing.

#### Scenario: Existing tunnel UUID resolved via JSON

- **WHEN** `devops::cloudflared::internal::tunnel::create` is called with a name that matches an existing tunnel
- **THEN** the function SHALL execute `cloudflared tunnel list --format json` and extract the UUID using `jq` with a filter matching the tunnel name
- **AND** the extracted UUID SHALL be used for subsequent operations (config generation, DNS routing)

#### Scenario: Non-existent tunnel triggers creation

- **WHEN** the tunnel name does not match any entry in the JSON output
- **THEN** the function SHALL create the tunnel via `cloudflared tunnel create`
- **AND** re-resolve the UUID from a fresh `cloudflared tunnel list --format json` call

### Requirement: Config file updated on re-run

The tunnel create function SHALL update the config.yml file when hostname or port values differ from the existing file, not only when the file is missing.

#### Scenario: Config updated when hostname changes

- **WHEN** config.yml exists and the provided hostname differs from the hostname in the existing config
- **THEN** the function SHALL rewrite config.yml with the new hostname

#### Scenario: Config updated when port changes

- **WHEN** config.yml exists and the provided port differs from the port in the existing config
- **THEN** the function SHALL rewrite config.yml with the new port

#### Scenario: Config unchanged when values match

- **WHEN** config.yml exists and both hostname and port match the existing config
- **THEN** the function SHALL NOT rewrite config.yml

### Requirement: No-hostname config uses ingress format

The tunnel create function SHALL generate config.yml using the `ingress:` directive format for all configurations, including cases where no hostname is provided. The deprecated `url:` directive SHALL NOT be used.

#### Scenario: No-hostname config uses ingress with catch-all

- **WHEN** tunnel create is called without a hostname
- **THEN** config.yml SHALL contain an `ingress:` block with a single catch-all rule: `- service: http://localhost:<port>` followed by `- service: http_status:404`

#### Scenario: Hostname config uses ingress with hostname rule

- **WHEN** tunnel create is called with a hostname
- **THEN** config.yml SHALL contain an `ingress:` block with a hostname-specific rule followed by a catch-all 404 rule

### Requirement: DNS routing is idempotent

The tunnel create function SHALL check whether DNS routing already exists for the given hostname before attempting `cloudflared tunnel route dns`.

#### Scenario: DNS already routed

- **WHEN** the hostname is already routed to the tunnel (verifiable via `cloudflared tunnel route dns` output or DNS lookup)
- **THEN** the function SHALL skip the routing step and log that DNS is already configured

#### Scenario: DNS not yet routed

- **WHEN** the hostname is not currently routed
- **THEN** the function SHALL execute `cloudflared tunnel route dns` and report success or failure

### Requirement: Port availability verified before tunnel creation

The tunnel create function SHALL verify that the target port is available (not already in use) before proceeding with tunnel creation.

#### Scenario: Port is available

- **WHEN** the specified port is not in use
- **THEN** the function SHALL proceed with tunnel creation

#### Scenario: Port is already in use

- **WHEN** the specified port is already in use by another process
- **THEN** the function SHALL display a warning and still proceed (non-blocking), since the user may intend to use a port that will be available at tunnel run time

### Requirement: Backward compatibility maintained

All changes SHALL maintain backward compatibility with existing tunnel configurations. Existing tunnels created with the old function SHALL continue to work without modification.

#### Scenario: Existing tunnel re-run with same parameters

- **WHEN** the function is called with the same name, port, and hostname as a previously created tunnel
- **THEN** the function SHALL detect the existing tunnel, skip creation, and update config only if values differ
