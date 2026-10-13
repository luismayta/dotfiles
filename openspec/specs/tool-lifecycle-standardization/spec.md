# tool-lifecycle-standardization

## Purpose

Standardize the lifecycle interface across all AI tools so they expose consistent function naming, error handling, and success messages.

## Requirements

### Requirement: Standardized tool lifecycle interface
All AI tools (openspec, graphify, codegraph) SHALL provide a consistent set of lifecycle functions: init, install, setup, update, upgrade.

#### Scenario: Tool provides all lifecycle functions
- **WHEN** a user calls any lifecycle function on an AI tool
- **THEN** the tool responds with appropriate success or error messages

### Requirement: Consistent function naming

All lifecycle functions SHALL follow the naming pattern `ai::<tool>::<function>` where `<function>` is one of: init, install, setup, update, upgrade, status. The `status` verb is permitted for tools managed as local services with no binary in PATH (for example freellmapi, a Docker Compose service), because such tools have no executable to query and must instead report state from on-disk artifacts or the service health endpoint.

#### Scenario: Function naming convention

- **WHEN** a user calls `ai::graphify::init` or `ai::codegraph::setup`
- **THEN** the function exists and follows the naming pattern

#### Scenario: Status verb on a service-managed tool

- **WHEN** a user calls `ai::freellmapi::status`
- **THEN** the function exists and follows the naming pattern `ai::<tool>::<function>` with `function` = `status`

### Requirement: Status via service artifacts instead of binary lookup

For an AI tool managed as a local service without a binary in PATH, its `status` lifecycle function SHALL determine state from on-disk deployment artifacts (such as the tool's compose file) and/or the service health endpoint, and MUST NOT depend on `core::exists` resolving a PATH binary.

#### Scenario: Service deployed and healthy

- **WHEN** the tool's compose file exists and its health endpoint responds successfully
- **THEN** `ai::<tool>::status` SHALL report the service as running

#### Scenario: Service absent or unreachable

- **WHEN** the tool's compose file is missing or the health endpoint does not respond
- **THEN** `ai::<tool>::status` SHALL report the service as not running and SHALL suggest the install function

### Requirement: Consistent error handling
All lifecycle functions SHALL provide consistent error messages when prerequisites are missing.

#### Scenario: Missing prerequisite error
- **WHEN** a user calls a lifecycle function but the tool is not installed
- **THEN** the function returns an error message indicating the tool is not installed and suggests running the install function

### Requirement: Consistent success messages
All lifecycle functions SHALL provide consistent success messages upon completion.

#### Scenario: Successful operation
- **WHEN** a user calls a lifecycle function and it completes successfully
- **THEN** the function returns a success message indicating the operation completed
