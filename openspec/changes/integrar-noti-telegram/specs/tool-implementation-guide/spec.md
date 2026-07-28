## ADDED Requirements

### Requirement: Guide documents CLI standalone integration pattern

The guide SHALL document the pattern for integrating CLI tools that do NOT provide shell hooks (standalone binaries).

#### Scenario: CLI standalone tool is documented
- **WHEN** a developer reads about tools without shell hooks
- **THEN** the guide SHALL explain that the load function only needs to add the tool to PATH via `path::prepend`

#### Scenario: noti is provided as reference implementation
- **WHEN** a developer reads the CLI standalone section
- **THEN** the guide SHALL provide noti code examples with inline annotations explaining the PATH-only pattern

#### Scenario: Decision tree includes CLI standalone
- **WHEN** a developer is integrating a new tool
- **THEN** the guide SHALL extend the decision tree: "Does the tool provide shell hooks? → eval pattern. No? → CLI standalone pattern (PATH-only)."
