## ADDED Requirements

### Requirement: Derive project name from argument

When `$1` is provided, the system SHALL use the argument as the project name and pass it through sanitization. No parent directory prefix SHALL be prepended.

#### Scenario: Explicit name
- **WHEN** `$1` is `"my-project"`
- **THEN** the output SHALL be `my-project`

#### Scenario: Explicit name with special chars
- **WHEN** `$1` is `"my.project;test"`
- **THEN** the output SHALL be `my_project_test`

### Requirement: Derive project name from directory context

When `$1` is not provided, the system SHALL derive the project name from `$PWD` and `$HOME` using hierarchy rules.

- If `$PWD` equals `$HOME`, the name SHALL be `core`
- If the parent directory equals `$HOME`, the name SHALL be `core-{current_dir}`
- Otherwise, the name SHALL be `{parent_dir}-{current_dir}`

#### Scenario: PWD is home
- **WHEN** `$PWD` is `/home/user` and `$HOME` is `/home/user`
- **THEN** the output SHALL be `core`

#### Scenario: Direct subdirectory of home
- **WHEN** `$PWD` is `/home/user/myapp` and `$HOME` is `/home/user`
- **THEN** the output SHALL be `core-myapp`

#### Scenario: Nested subdirectory
- **WHEN** `$PWD` is `/home/user/work/clients/acme`
- **THEN** the output SHALL be `clients-acme`

### Requirement: Sanitize project name

The complete project name SHALL be sanitized to replace special characters with underscore, collapse consecutive underscores, and strip leading/trailing underscores.

#### Scenario: Dot in folder name
- **WHEN** the folder is `frontend.app` and parent is `projects`
- **THEN** the output SHALL be `projects-frontend_app`

#### Scenario: Multiple special chars
- **WHEN** the folder is `foo.bar;baz` and parent is `test`
- **THEN** the output SHALL be `test-foo_bar_baz`
