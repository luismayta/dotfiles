## ADDED Requirements

### Requirement: Extension list is config-driven

The `zsh/modules/github/config/base.zsh` SHALL define `ZSH_GITHUB_EXTENSIONS` as a zsh array containing gh extension references (e.g., `dlvhdr/gh-dash`).

#### Scenario: Extensions array defined
- **WHEN** config/base.zsh is sourced
- **THEN** `ZSH_GITHUB_EXTENSIONS` SHALL be a zsh array
- **THEN** `dlvhdr/gh-dash` SHALL be the default entry

#### Scenario: User can add extensions
- **WHEN** user adds an entry to `ZSH_GITHUB_EXTENSIONS` in their config
- **THEN** the extension SHALL be installed on next module load

### Requirement: Extension install function exists

The `zsh/modules/github/internal/` layer SHALL provide `github::internal::extension::install` that installs a single gh extension by reference.

#### Scenario: Install single extension
- **WHEN** `github::internal::extension::install "dlvhdr/gh-dash"` is called
- **THEN** the function SHALL run `gh extension install dlvhdr/gh-dash`

#### Scenario: Install skips already-installed extension
- **WHEN** `github::internal::extension::install "dlvhdr/gh-dash"` is called and the extension is already installed
- **THEN** the function SHALL NOT re-install (idempotent)

### Requirement: Bulk extension install function exists

The `zsh/modules/github/internal/` layer SHALL provide `github::internal::extensions::install` that iterates over `ZSH_GITHUB_EXTENSIONS` and installs each.

#### Scenario: Bulk install iterates array
- **WHEN** `github::internal::extensions::install` is called
- **THEN** it SHALL iterate over `ZSH_GITHUB_EXTENSIONS`
- **THEN** it SHALL call `github::internal::extension::install` for each entry

### Requirement: Public wrapper functions exist

The `zsh/modules/github/pkg/` layer SHALL provide public wrapper functions: `github::extension::install` and `github::extensions::install`.

#### Scenario: Public wrappers call internal functions
- **WHEN** `github::extension::install` is called
- **THEN** it SHALL delegate to `github::internal::extension::install`

#### Scenario: Bulk public wrapper calls internal
- **WHEN** `github::extensions::install` is called
- **THEN** it SHALL delegate to `github::internal::extensions::install`

### Requirement: No hardcoded extension references in internal

The `zsh/modules/github/internal/` layer SHALL NOT contain hardcoded extension references (e.g., `dlvhdr/gh-dash`). All extension references SHALL come from the `ZSH_GITHUB_EXTENSIONS` config array.

#### Scenario: No hardcoded references in internal
- **WHEN** internal layer files are inspected
- **THEN** no file SHALL contain the string `dlvhdr/gh-dash` outside of install/load functions
