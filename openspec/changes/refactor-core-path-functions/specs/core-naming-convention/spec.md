## ADDED Requirements

### Requirement: Functions in zsh/core/ SHALL follow the core::*::* naming convention

All functions defined in the `zsh/core/` module SHALL use the `core::` prefix followed by optional namespace separators. The naming pattern SHALL be `core::<namespace>::<function>` for namespaced functions or `core::<function>` for flat utilities.

#### Scenario: Path functions are properly namespaced
- **WHEN** a function is defined in `zsh/core/internal/path.zsh`
- **THEN** the function name SHALL start with `core::path::` (e.g., `core::path::prepend`, `core::path::append`, `core::path::clean`)

#### Scenario: Editor functions are properly namespaced
- **WHEN** a function is defined in `zsh/core/internal/editor.zsh`
- **THEN** the function name SHALL start with `core::` (e.g., `core::editrc`, `core::editprivaterc`, `core::editcustomrc`)

#### Scenario: Reload function is properly namespaced
- **WHEN** a function is defined in `zsh/core/internal/reload.zsh`
- **THEN** the function name SHALL be `core::reload`

#### Scenario: Backup internal function is properly namespaced
- **WHEN** a legacy function is defined in `zsh/core/internal/backup.zsh`
- **THEN** the function name SHALL start with `core::internal::` (e.g., `core::internal::backup`)

### Requirement: Callers SHALL use the new function names

All references to renamed functions throughout the codebase SHALL be updated to use the new `core::*::*` naming convention.

#### Scenario: Path prepend callers are updated
- **WHEN** any script or function calls `path::prepend`
- **THEN** it SHALL be updated to call `core::path::prepend`

#### Scenario: Path append callers are updated
- **WHEN** any script or function calls `path::append`
- **THEN** it SHALL be updated to call `core::path::append`

#### Scenario: Path clean callers are updated
- **WHEN** any script or function calls `path::clean`
- **THEN** it SHALL be updated to call `core::path::clean`

#### Scenario: Reload callers are updated
- **WHEN** any script or function calls `reload`
- **THEN** it SHALL be updated to call `core::reload`

#### Scenario: Editor function callers are updated
- **WHEN** any script or function calls `editrc`, `editprivaterc`, or `editcustomrc`
- **THEN** they SHALL be updated to call `core::editrc`, `core::editprivaterc`, or `core::editcustomrc` respectively

### Requirement: Duplicate reload implementations SHALL be consolidated

The duplicate `reload` function definitions in `internal/reload.zsh` and `internal/osx.zsh` SHALL be consolidated into a single implementation in `internal/reload.zsh` that handles platform differences.

#### Scenario: Consolidated reload handles Linux
- **WHEN** `core::reload` is called on Linux
- **THEN** it SHALL execute `exec "${SHELL}"` without the `-l` flag

#### Scenario: Consolidated reload handles macOS
- **WHEN** `core::reload` is called on macOS
- **THEN** it SHALL execute `exec "${SHELL}" -l` with the `-l` flag

#### Scenario: Duplicate reload removed from osx.zsh
- **WHEN** the refactoring is complete
- **THEN** the `reload` function definition in `internal/osx.zsh` SHALL be removed
