## ADDED Requirements

### Requirement: Guide covers three-layer architecture for tool integration

The guide SHALL document the three-layer architecture pattern (config → internal → pkg) for adding tools to existing modules.

#### Scenario: Architecture overview is explained
- **WHEN** a developer reads the guide
- **THEN** the guide SHALL explain that each tool has config/, internal/, and pkg/ directories with specific responsibilities

#### Scenario: Layer responsibilities are documented
- **WHEN** a developer reads about each layer
- **THEN** the guide SHALL explain that config/ holds environment variables, internal/ holds private implementation, and pkg/ holds public API functions

### Requirement: Guide uses atuin as reference implementation

The guide SHALL use atuin in the devops module as the annotated reference implementation.

#### Scenario: Atuin code examples are provided
- **WHEN** a developer reads about any layer
- **THEN** the guide SHALL provide the corresponding atuin code with inline annotations explaining each decision

#### Scenario: Atuin file structure is documented
- **WHEN** a developer reads the file structure section
- **THEN** the guide SHALL show the complete atuin file structure across config/, internal/, and pkg/ directories

### Requirement: Guide documents naming conventions

The guide SHALL document the naming convention pattern for tool functions and variables.

#### Scenario: Function naming pattern is explained
- **WHEN** a developer reads the naming conventions section
- **THEN** the guide SHALL document that internal functions use `devops::<tool>::internal::<verb>` and public functions use `devops::<tool>::<verb>`

#### Scenario: Variable naming pattern is explained
- **WHEN** a developer reads the naming conventions section
- **THEN** the guide SHALL document that config variables use `DEVOPS_<TOOL>_` prefix

### Requirement: Guide documents guard patterns

The guide SHALL document the guard pattern for checking tool existence.

#### Scenario: core::exists guard is explained
- **WHEN** a developer reads about the internal layer
- **THEN** the guide SHALL explain that all functions should check `core::exists <tool>` before proceeding and return early if the tool is not installed

#### Scenario: Auto-install pattern is explained
- **WHEN** a developer reads about the factory function
- **THEN** the guide SHALL explain that `main::factory` runs at source time and auto-installs missing tools

### Requirement: Guide documents shell integration pattern (conditional)

The guide SHALL document that shell integration is optional and depends on the tool's needs.

#### Scenario: Tools requiring shell hooks
- **WHEN** a tool provides shell integration (keybindings, history hooks, completions)
- **THEN** the guide SHALL explain that shell hooks are eval'd at load time using `eval "$(tool init zsh)"` with configurable flags (e.g., atuin)

#### Scenario: Tools not requiring shell hooks
- **WHEN** a tool is a standalone CLI without shell integration
- **THEN** the guide SHALL explain that the load function only needs to add the tool to PATH via `path::prepend` (e.g., bruno)

#### Scenario: Decision guidance is provided
- **WHEN** a developer is integrating a new tool
- **THEN** the guide SHALL provide a decision tree: "Does the tool provide shell hooks? → eval pattern. No? → PATH-only pattern."

### Requirement: Guide documents registration in DEVOPS_TOOLS

The guide SHALL document how to register a new tool in the module's tool list.

#### Scenario: Registration location is documented
- **WHEN** a developer reads the registration section
- **THEN** the guide SHALL explain that tools must be added to the `DEVOPS_TOOLS` array in `config/base.zsh`

### Requirement: Guide includes testing instructions

The guide SHALL include instructions for testing the tool integration.

#### Scenario: Load test is documented
- **WHEN** a developer reads the testing section
- **THEN** the guide SHALL provide a command to test loading the module with the new tool

#### Scenario: Function verification is documented
- **WHEN** a developer reads the testing section
- **THEN** the guide SHALL provide commands to verify that public functions are available

### Requirement: Guide includes a checklist

The guide SHALL include a checklist for verifying complete tool integration.

#### Scenario: Checklist covers all layers
- **WHEN** a developer reads the checklist
- **THEN** the guide SHALL include items for config, internal, pkg, and registration steps

#### Scenario: Checklist includes quality checks
- **WHEN** a developer reads the checklist
- **THEN** the guide SHALL include items for naming conventions, guard patterns, and message functions
