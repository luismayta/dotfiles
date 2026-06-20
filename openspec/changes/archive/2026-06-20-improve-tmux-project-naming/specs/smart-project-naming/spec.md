## ADDED Requirements

### Requirement: Auto-detect project name from directory context

When `tx::project` is called without an explicit project name argument (`$1`), the function SHALL derive the project name from the current working directory (`PWD`) using parent directory context.

- The function SHALL determine the parent directory name using `$(basename "$(dirname "$PWD")")`
- If the parent directory resolves to the user's `$HOME`, the project name SHALL be prefixed with `core-`: `core-{folder_name}`
- If the parent directory is NOT the user's `$HOME`, the project name SHALL use the format `{parent_name}-{folder_name}`
- If `PWD` IS the user's `$HOME` itself, the project name SHALL fall back to `core`

#### Scenario: Project in a subdirectory under home
- **WHEN** user runs `tx::project` in `/home/user/projects/myapp` (where `$HOME=/home/user`)
- **THEN** the auto-derived name SHALL be `projects-myapp`

#### Scenario: Project directly under home
- **WHEN** user runs `tx::project` in `/home/user/myfolder` (where `$HOME=/home/user`)
- **THEN** the auto-derived name SHALL be `core-myfolder`

#### Scenario: Project at home root itself
- **WHEN** user runs `tx::project` in `/home/user` (where `$HOME=/home/user`)
- **THEN** the auto-derived name SHALL be `core`

#### Scenario: Nested project at depth 3+
- **WHEN** user runs `tx::project` in `/home/user/work/clients/acme` (where `$HOME=/home/user`)
- **THEN** the auto-derived name SHALL be `clients-acme` (parent=`clients`, folder=`acme`)

### Requirement: Sanitize special characters in full project name

The complete project name (including prefix and folder) SHALL be sanitized to replace special characters with underscore (`_`).

- Characters matching `[^a-zA-Z0-9_-]` SHALL be replaced with `_`
- Consecutive underscores SHALL be collapsed to a single `_`
- Leading and trailing underscores SHALL be stripped
- This applies to the FULL constructed name (e.g., `{parent}-{folder}`), not just the basename

#### Scenario: Dot in folder name
- **WHEN** the folder name is `frontend.app` and parent is `projects`
- **THEN** the final name SHALL be `projects-frontend_app`

#### Scenario: Apostrophe in folder name
- **WHEN** the folder name is `client's-app` and parent is `work`
- **THEN** the final name SHALL be `work-clients-app`

#### Scenario: Multiple special characters combined
- **WHEN** the folder name is `foo.bar;baz` and parent is `test`
- **THEN** the final name SHALL be `test-foo_bar_baz`

### Requirement: Preserve explicit name behavior

When `$1` is explicitly provided to `tx::project`, the function SHALL preserve current behavior: use the argument as-is and sanitize it without any parent directory prefix.

#### Scenario: Explicit name with special chars
- **WHEN** user runs `tx::project "my.project;test"`
- **THEN** the sanitized name SHALL be `my_project_test` (no parent prefix)

#### Scenario: Explicit clean name
- **WHEN** user runs `tx::project "my-project"`
- **THEN** the sanitized name SHALL be `my-project`
