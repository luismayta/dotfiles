## Purpose

Defines the durable rules for deriving a herdr workspace label from directory context: the three derivation branches, slug normalization, the explicit parent-directory prefix map with full-name fallback, legacy-label lookup for pre-existing workspaces, and the single shared source of truth consumed by both herdr and tmux.

## ADDED Requirements

### Requirement: Three derivation branches
Workspace label derivation SHALL use three mutually exclusive branches based on directory context. When the current working directory equals the user's home directory, the label SHALL be `core`. When the parent directory equals the home directory, the label SHALL be `core-{dir}` where `{dir}` is the basename of the current directory. Otherwise the label SHALL be `{parent}-{dir}` where `{parent}` is the basename of the parent directory.

#### Scenario: Home directory yields core
- **WHEN** the current working directory is the user's home directory
- **THEN** the derived label SHALL be `core`

#### Scenario: Direct child of home yields core prefix
- **WHEN** the current working directory is `<home>/scratch` and its parent directory is the home directory
- **THEN** the derived label SHALL be `core-scratch`

#### Scenario: Nested directory yields parent and dir
- **WHEN** the current working directory is `<home>/work/myproject` and its parent directory is `work`
- **THEN** the derived label SHALL be `work-myproject`

### Requirement: Slug normalization
Directory-name components SHALL be normalized to a slug before they are combined: every character that is not an ASCII letter or digit SHALL become a hyphen, runs of adjacent hyphens SHALL collapse to a single hyphen, leading and trailing hyphens SHALL be removed, and uppercase letters SHALL be converted to lowercase.

#### Scenario: Spaces become single hyphens
- **WHEN** a directory named `My Project Files` contributes to a derived label
- **THEN** each space SHALL become a hyphen
- **THEN** uppercase letters SHALL be converted to lowercase
- **AND** the resulting slug SHALL be `my-project-files`

#### Scenario: Dots and repeated hyphens collapse
- **WHEN** a directory named `api..v2` contributes to a derived label
- **THEN** each dot SHALL become a hyphen
- **THEN** the run of adjacent hyphens SHALL collapse to a single hyphen
- **AND** the resulting slug SHALL be `api-v2`

#### Scenario: Leading and trailing hyphens removed
- **WHEN** a directory named `-draft-` contributes to a derived label
- **THEN** the leading and trailing hyphens SHALL be removed
- **AND** the resulting slug SHALL be `draft`

#### Scenario: Non-ASCII characters become hyphens
- **WHEN** a directory named `café` contributes to a derived label
- **THEN** the non-ASCII character `é` SHALL become a hyphen
- **THEN** the resulting trailing hyphen SHALL be removed
- **AND** the resulting slug SHALL be `caf`

### Requirement: Explicit parent prefix map
The derivation SHALL consult an explicit map of parent directory names to label prefixes. When the parent directory has an entry in the map, the mapped prefix SHALL replace the parent component in the derived label.

#### Scenario: Mapped parent uses short prefix
- **WHEN** the parent directory is `codiplab` and the current directory is `base-template`
- **AND** the map contains the entry `codiplab` mapped to `cl`
- **THEN** the derived label SHALL be `cl-base-template`
- **AND** the full parent name SHALL NOT appear in the label

### Requirement: Full-parent-name fallback
When the parent directory has no entry in the prefix map, the derivation SHALL fall back to the full slugified parent directory name, preserving existing labels for projects outside the mapped organization.

#### Scenario: Unmapped parent keeps full name
- **WHEN** the parent directory is `sideproject`, which has no entry in the prefix map
- **AND** the current directory is `tool`
- **THEN** the derived label SHALL be `sideproject-tool`
- **AND** the full parent directory name SHALL be preserved

### Requirement: Legacy-label lookup fallback
Workspace resolution SHALL first look up the workspace list using the newly derived label. If no workspace with that label exists, the system SHALL fall back to the legacy `{parent_dir}-{current_dir}` label. An existing workspace found by either label SHALL be reused and MUST NOT be recreated.

#### Scenario: Legacy label resolves existing workspace
- **WHEN** the newly derived label is absent from the workspace list
- **AND** a workspace exists under the legacy `{parent_dir}-{current_dir}` label
- **THEN** the system SHALL resolve that existing workspace by the legacy label

#### Scenario: Existing workspace is never recreated
- **WHEN** a workspace already exists under either the new label or the legacy label
- **THEN** the system SHALL open the existing workspace
- **AND** the system MUST NOT create a new workspace

### Requirement: Explicit argument takes priority
When a label or name is supplied explicitly as an argument, the system SHALL use it as-is and SHALL NOT derive a label from directory context. Directory-context derivation SHALL apply only when no explicit argument is given.

#### Scenario: Explicit argument overrides derivation
- **WHEN** the user supplies an explicit label argument
- **THEN** the system SHALL use the supplied value unchanged
- **AND** the system SHALL NOT use the label that directory context would derive

#### Scenario: Directory context used when no argument
- **WHEN** no explicit label argument is supplied
- **THEN** the label SHALL be derived from directory context using the documented branches

### Requirement: Single shared source of truth
Workspace label derivation SHALL be implemented exactly once, in a single shared source consumed by both the herdr module and the tmux module. Neither module SHALL carry its own copy of the derivation logic.

#### Scenario: Both modules produce the same derived name
- **WHEN** herdr and tmux each derive a label from the same directory context
- **THEN** both SHALL produce the identical label
- **AND** both SHALL read from the same shared source

#### Scenario: Rule change applies to both modules
- **WHEN** a derivation rule changes in the shared source
- **THEN** both herdr and tmux SHALL reflect the change
- **AND** neither module SHALL require its own modification

### Requirement: Derivation is pure
Label derivation SHALL be a pure computation: it MUST NOT mutate global state, MUST NOT create, modify, or delete any file, and MUST NOT produce side effects beyond the returned label.

#### Scenario: Derivation has no side effects
- **WHEN** a label is derived
- **THEN** no global shell state SHALL be changed
- **AND** no filesystem operation SHALL occur
- **AND** the only result SHALL be the derived label
