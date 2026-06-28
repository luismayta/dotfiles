## ADDED Requirements

### Requirement: Custom modules use consistent shell and format
All `[custom.*]` modules SHALL use the same `shell` setting and a uniform `format` pattern.

#### Scenario: Shell is consistent across custom modules
- **WHEN** inspecting `[custom.giturl]`, `[custom.githash]`, `[custom.proxy_is_on]`, `[custom.proxy_is_off]`
- **THEN** all SHALL use `shell = ["bash", "--noprofile", "--norc"]` (or a single agreed-upon shell)

#### Scenario: Format pattern is uniform
- **WHEN** inspecting custom module formats
- **THEN** they SHALL use `format = "$output "` or `format = "[$symbol]($style)"` consistently

### Requirement: Git custom modules have simplified commands
The `[custom.giturl]` and `[custom.githash]` command scripts SHALL be simplified for readability without changing output.

#### Scenario: Giturl command is readable
- **WHEN** inspecting the `command` for `[custom.giturl]`
- **THEN** it SHALL use a concise inline script (no external file needed) with clear variable names

#### Scenario: Githash command is readable
- **WHEN** inspecting the `command` for `[custom.githash]`
- **THEN** it SHALL use `git rev-parse --short HEAD` directly without intermediate variable

### Requirement: Proxy modules are grouped together
The proxy custom modules SHALL be placed adjacent to each other in the file with a shared comment header.

#### Scenario: Proxy sections are adjacent
- **WHEN** reading the file
- **THEN** `[custom.proxy_is_on]` and `[custom.proxy_is_off]` SHALL be consecutive entries
