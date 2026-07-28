## ADDED Requirements

### Requirement: YAML frontmatter on all docs markdown files
Every `.md` file in the `docs/` directory SHALL include YAML frontmatter with at minimum a `type` and `title` field.

#### Scenario: frontmatter is valid YAML
- **WHEN** parsing any `.md` file in `docs/`
- **THEN** the file SHALL begin with valid YAML frontmatter delimited by `---`

#### Scenario: type field is present
- **WHEN** reading frontmatter of any docs file
- **THEN** a `type` field SHALL be present

#### Scenario: title field is present
- **WHEN** reading frontmatter of any docs file
- **THEN** a `title` field SHALL be present

#### Scenario: description field is present
- **WHEN** reading frontmatter of any docs file
- **THEN** a `tags` field SHALL be present

### Requirement: Confluence comment removal
No `.md` file in the repository SHALL contain Confluence-specific HTML comments (`<!-- Space:`, `<!-- Parent:`, `<!-- Title:`, `<!-- Label:`, `<!-- Include:`).

#### Scenario: no Space comments in docs
- **WHEN** searching for `<!-- Space:` in `docs/` and `provision/templates/`
- **THEN** no matches SHALL be found
