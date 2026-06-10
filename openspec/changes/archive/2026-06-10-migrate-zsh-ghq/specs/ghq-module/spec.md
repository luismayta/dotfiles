## ADDED Requirements

### Requirement: ghq path management
The system SHALL configure ghq root path and repository management.

#### Scenario: Configure ghq root
- **WHEN** the ghq module loads
- **THEN** the ghq root path SHALL be configured for repository management

### Requirement: Repository listing and lookup
The system SHALL provide functions for listing and looking up git repositories via ghq.

#### Scenario: List all managed repositories
- **WHEN** `ghq::list` is called
- **THEN** it SHALL list all repositories managed by ghq

#### Scenario: Get repository path
- **WHEN** `ghq::get` is called with a repository name
- **THEN** it SHALL return the full path to the repository

### Requirement: Cookiecutter integration
The system SHALL integrate with cookiecutter for project scaffolding.

#### Scenario: Scaffold new project
- **WHEN** a cookiecutter template is invoked
- **THEN** the system SHALL scaffold a new project from the template

### Requirement: Project listing by host
The system SHALL provide functions for listing repositories by host (GitHub, GitLab, etc.).

#### Scenario: List GitHub repositories
- **WHEN** `ghq::list::github` is called
- **THEN** it SHALL list all repositories hosted on GitHub managed by ghq
