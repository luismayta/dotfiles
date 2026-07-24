## ADDED Requirements

### Requirement: Module README
The `zsh/modules/git/` directory SHALL contain a README.md documenting the entire toolkit.

#### Scenario: README exists
- **WHEN** user navigates to `zsh/modules/git/`
- **THEN** README.md is present and readable

#### Scenario: README content
- **WHEN** user opens README.md
- **THEN** content includes: module description, installation instructions, script listing with descriptions, usage examples for top 5 scripts

### Requirement: Script listing
The README SHALL include a table listing all scripts with name, description, and usage example.

#### Scenario: Complete listing
- **WHEN** user views the script table
- **THEN** every script in `bin/` is listed with its purpose and a one-line usage example

#### Scenario: Categorized listing
- **WHEN** user views the script table
- **THEN** scripts are grouped by category (Branch Management, Remote, History, etc.)

### Requirement: Individual script documentation
Each script SHALL include a usage comment at the top of the file.

#### Scenario: Usage header
- **WHEN** user runs `git-root --help` or reads the script header
- **THEN** they see: script name, description, usage syntax, available flags

#### Scenario: Example header format
- **WHEN** script has usage comment
- **THEN** format matches: `# git-root - Print the root directory of the git repository`