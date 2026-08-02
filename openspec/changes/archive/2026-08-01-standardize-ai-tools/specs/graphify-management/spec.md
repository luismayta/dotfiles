## ADDED Requirements

### Requirement: Graphify init function
Graphify SHALL provide an init function that initializes graphify for the current project.

#### Scenario: Initialize graphify for project
- **WHEN** user calls `ai::graphify::init`
- **THEN** graphify initializes project configuration

### Requirement: Graphify update function
Graphify SHALL provide an update function that updates graphify to the latest version.

#### Scenario: Update graphify
- **WHEN** user calls `ai::graphify::update`
- **THEN** graphify updates to the latest version

## MODIFIED Requirements

### Requirement: Graphify install function
Graphify SHALL provide an install function that installs graphify using uv.

#### Scenario: Install graphify
- **WHEN** user calls `ai::graphify::install`
- **THEN** graphify installs using uv and registers the skill

### Requirement: Graphify upgrade function
Graphify SHALL provide an upgrade function that upgrades graphify to the latest version.

#### Scenario: Upgrade graphify
- **WHEN** user calls `ai::graphify::upgrade`
- **THEN** graphify upgrades to the latest version

### Requirement: Graphify setup function
Graphify SHALL provide a setup function that sets up graphify for the current project.

#### Scenario: Setup graphify for project
- **WHEN** user calls `ai::graphify::setup`
- **THEN** graphify sets up the project configuration