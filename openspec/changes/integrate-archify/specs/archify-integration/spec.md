## Purpose

Integrate Archify architecture diagram generator as a managed tool in the AI module, providing install, configuration, and CLI wrapper capabilities.

## ADDED Requirements

### Requirement: Archify tool registered in AI module
The system SHALL register Archify as a managed tool in the AI module's tool registry.

#### Scenario: Tool appears in registry
- **WHEN** the AI module loads
- **THEN** `ZSH_AI_TOOLS` SHALL include `archify`

#### Scenario: Config file exists
- **WHEN** the AI module config layer loads
- **THEN** `config/archify.zsh` SHALL exist and export `ZSH_AI_ARCHIFY_*` variables

### Requirement: Archify installable via AI module
The system SHALL install Archify as an agent skill using `bunx skills add`.

#### Scenario: Successful install
- **WHEN** user runs `ai::archify::install`
- **THEN** system SHALL execute `bunx skills add tt-a1i/archify -g`
- **AND** `archify` command SHALL be available in PATH

#### Scenario: Idempotent install
- **WHEN** user runs `ai::archify::install` and Archify is already installed
- **THEN** system SHALL skip installation (check via `core::exists archify`)

### Requirement: Archify health check
The system SHALL provide a health check command to verify Archify installation.

#### Scenario: Doctor passes
- **WHEN** user runs `ai::archify::doctor`
- **THEN** system SHALL execute `archify doctor` and return exit code 0

### Requirement: Archify CLI wrappers exposed
The system SHALL expose Archify's core CLI commands via namespaced functions.

#### Scenario: Render wrapper
- **WHEN** user runs `ai::archify::render <type> <input> [output]`
- **THEN** system SHALL execute `archify render <type> <input> [output]`

#### Scenario: Validate wrapper
- **WHEN** user runs `ai::archify::validate <type> <input>`
- **THEN** system SHALL execute `archify validate <type> <input>`

#### Scenario: Deliver wrapper
- **WHEN** user runs `ai::archify::deliver <type> <input> [output]`
- **THEN** system SHALL execute `archify deliver <type> <input> [output]`

### Requirement: Archify skill auto-installed with skills setup
The system SHALL include Archify in the bulk skills installation.

#### Scenario: Skills setup includes Archify
- **WHEN** user runs `ai::skills::setup`
- **THEN** system SHALL install `tt-a1i/archify` from the skills repo list

### Requirement: Shell aliases available
The system SHALL provide convenience aliases for common Archify commands.

#### Scenario: Aliases defined
- **WHEN** the AI module pkg layer loads
- **THEN** aliases `archify-render`, `archify-validate`, `archify-deliver`, and `archify-doctor` SHALL be available
