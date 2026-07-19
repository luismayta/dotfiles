## ADDED Requirements

### Requirement: Simplified vault environment loading
The system SHALL provide a simplified `bitwarden::internal::load::env` function that delegates vault loading to `env-secrets` CLI tool.

#### Scenario: User selects vault from fzf
- **WHEN** `BITWARDEN_VARS_LIST` contains multiple entries
- **THEN** the function presents fzf selection prompt
- **AND** upon selection, executes `eval "$(env-secrets bw ${selected})"`
- **AND** does not manually call `bw get item` or extract passwords

#### Scenario: User cancels fzf selection
- **WHEN** user cancels fzf prompt (presses Escape/Ctrl+C)
- **THEN** the function returns silently without executing any commands
- **AND** no environment variables are modified

#### Scenario: Single vault in list
- **WHEN** `BITWARDEN_VARS_LIST` contains exactly one entry
- **THEN** the function automatically selects that entry without fzf prompt
- **AND** executes `eval "$(env-secrets bw ${selected})"`

#### Scenario: Empty vault list
- **WHEN** `BITWARDEN_VARS_LIST` is empty or unset
- **THEN** the function returns silently without executing any commands

### Requirement: Remove .bw_env file dependency
The system SHALL NOT check for or source `~/.bw_env` files during vault loading.

#### Scenario: .bw_env file exists
- **WHEN** `~/.bw_env` file exists on the system
- **THEN** the function ignores it completely
- **AND** uses only `BITWARDEN_VARS_LIST` for vault selection

#### Scenario: .bw_env file does not exist
- **WHEN** `~/.bw_env` file does not exist
- **THEN** the function operates normally without error

### Requirement: env-secrets dependency check
The system SHALL verify `env-secrets` is available before attempting vault loading.

#### Scenario: env-secrets is installed
- **WHEN** `env-secrets` command exists in PATH
- **THEN** the function proceeds with vault selection and loading

#### Scenario: env-secrets is not installed
- **WHEN** `env-secrets` command does not exist in PATH
- **THEN** the function displays a warning message
- **AND** returns without modifying environment

### Requirement: Preserve backward compatibility
The system SHALL maintain the existing public API through the `bw::load::env` wrapper function.

#### Scenario: Direct function call
- **WHEN** external code calls `bw::load::env`
- **THEN** it delegates to `bitwarden::internal::load::env`
- **AND** all existing callers continue to work without modification

#### Scenario: Search functions invoke load
- **WHEN** `bw::search::*` functions are called
- **THEN** they invoke `bw::load::env` before performing search
- **AND** the simplified loading completes before search executes
