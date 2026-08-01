## MODIFIED Requirements

### Requirement: k9s config sync
The devops module SHALL provide a sync command that rsyncs bundled k9s YAML configuration files to the k9s config directory.

#### Scenario: sync k9s configuration
- **WHEN** user runs devops::k9s::sync
- **THEN** conf/k9s/ SHALL be rsynced to DEVOPS_K9S_CONF_PATH
