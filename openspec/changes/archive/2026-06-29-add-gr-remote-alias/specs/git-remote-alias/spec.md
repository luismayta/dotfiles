## ADDED Requirements

### Requirement: Git remote alias `gr`
The system SHALL define a ZSH alias `gr` that maps to the `git remote` command.

#### Scenario: `gr` invokes git remote
- **WHEN** user types `gr` in a shell
- **THEN** the system SHALL execute `git remote`

#### Scenario: `gr -v` displays remote URLs
- **WHEN** user types `gr -v` in a git repository with remotes configured
- **THEN** the system SHALL display the remote URLs (equivalent to `git remote -v`)

#### Scenario: Alias is available after module load
- **WHEN** the git ZSH module is loaded
- **THEN** the `gr` alias SHALL be available in the shell session

#### Scenario: No conflict with existing aliases
- **WHEN** the git ZSH module is loaded
- **THEN** the `gr` alias SHALL not override any previously defined alias in the module
