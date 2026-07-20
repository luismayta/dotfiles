## ADDED Requirements

### Requirement: Internal layer domain separation
The `internal/` layer of the `ai` module SHALL contain domain-specific `.zsh` files instead of a single monolithic `base.zsh`. Each domain file SHALL contain only functions belonging to that domain.

#### Scenario: internal/base.zsh is reduced to shared utilities only
- **WHEN** the refactoring is complete
- **THEN** `internal/base.zsh` SHALL contain only the `ai::internal::packages::install` function (batch installer) and any truly shared utilities
- **AND** `internal/base.zsh` SHALL be under 50 lines

#### Scenario: All tool install functions exist in domain files
- **WHEN** a tool has an `ai::internal::<tool>::install` function
- **THEN** that function SHALL exist in exactly one domain-specific file under `internal/`
- **AND** no function SHALL appear in more than one file

#### Scenario: Domain files follow naming convention
- **WHEN** a domain file is created under `internal/`
- **THEN** it SHALL be named `<domain>.zsh` (e.g., `opencode.zsh`, `skills.zsh`, `tools.zsh`)
- **AND** every function inside SHALL be prefixed with `ai::internal::<domain>::`

### Requirement: pkg layer domain separation
The `pkg/` layer of the `ai` module SHALL contain domain-specific `.zsh` files instead of a single `helper.zsh`. Each domain file SHALL contain only public API wrappers belonging to that domain.

#### Scenario: pkg/helper.zsh is removed
- **WHEN** the refactoring is complete
- **THEN** `pkg/helper.zsh` SHALL not exist
- **AND** all functions formerly in `pkg/helper.zsh` SHALL exist in domain-specific files under `pkg/`

#### Scenario: Public API functions are preserved
- **WHEN** a public function existed before the refactoring (e.g., `ai::opencode::install`, `ai::skills::setup`)
- **THEN** that function SHALL exist after the refactoring with the identical name and signature
- **AND** calling the function SHALL produce the same result as before

### Requirement: Internal helper.zsh removal
The `internal/helper.zsh` file SHALL be removed. Its functions SHALL migrate to the appropriate domain files.

#### Scenario: fabric functions migrate to fabric.zsh
- **WHEN** `internal/helper.zsh` is removed
- **THEN** `ai::internal::fabric::patterns::sync` and `ai::internal::fabric::patterns::pull` SHALL exist in `internal/fabric.zsh`

#### Scenario: ollama functions migrate to ollama.zsh
- **WHEN** `internal/helper.zsh` is removed
- **THEN** `ai::internal::ollama::models::list`, `ai::internal::ollama::models::pull`, and `ai::internal::ollama::models::install` SHALL exist in `internal/ollama.zsh`

### Requirement: Source order in main.zsh
`internal/main.zsh` and `pkg/main.zsh` SHALL source domain files in a dependency-safe order.

#### Scenario: internal/main.zsh sources in correct order
- **WHEN** `internal/main.zsh` is loaded
- **THEN** it SHALL source files in this order: `base.zsh`, `tools.zsh`, `opencode.zsh`, `fabric.zsh`, `ollama.zsh`, `skills.zsh`, `openspec.zsh`, `graphify.zsh`, `hunk.zsh`, OS dispatch

#### Scenario: pkg/main.zsh sources in correct order
- **WHEN** `pkg/main.zsh` is loaded
- **THEN** it SHALL source files in this order: `base.zsh`, `opencode.zsh`, `fabric.zsh`, `ollama.zsh`, `skills.zsh`, `openspec.zsh`, `graphify.zsh`, `hunk.zsh`, `tools.zsh`, OS dispatch, `alias.zsh`

### Requirement: Module loads without errors
The refactored module SHALL load identically to the pre-refactoring version.

#### Scenario: Module sources cleanly
- **WHEN** `source zsh/core/main.zsh && source zsh/modules/ai/plugin.zsh` is executed
- **THEN** no errors or warnings SHALL be produced
- **AND** all functions from the original module SHALL be available

#### Scenario: Guard prevents double-loading
- **WHEN** the module is sourced twice
- **THEN** the loading message SHALL appear only once
- **AND** no errors SHALL be produced on the second source

### Requirement: All functions are accounted for
Every function from the original files SHALL exist in exactly one new file.

#### Scenario: No lost functions
- **WHEN** the refactoring is complete
- **THEN** `grep -rn "ai::" zsh/modules/ai/internal/ zsh/modules/ai/pkg/ | wc -l` SHALL return a count equal to or greater than the original function count
- **AND** no function SHALL be duplicated across files

#### Scenario: No new public functions
- **WHEN** the refactoring is complete
- **THEN** no new public API functions SHALL be introduced (only existing ones are reorganized)
