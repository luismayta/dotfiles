## ADDED Requirements

### Requirement: List available tmuxinator templates

The system SHALL discover all `.yml` template files in `TMUXINATOR_TEMPLATE_PATH` and return their names (without extension) one per line.

- If `fd` is available, the system SHALL use `fd -e yml` with `--max-depth 1` for listing
- If `fd` is not available, the system SHALL fall back to a zsh glob `"${TMUXINATOR_TEMPLATE_PATH}"/*.yml`

#### Scenario: Templates exist
- **WHEN** `TMUXINATOR_TEMPLATE_PATH` contains 3 `.yml` files
- **THEN** the function SHALL output 3 lines, each containing a template name without `.yml` extension

#### Scenario: No templates exist
- **WHEN** `TMUXINATOR_TEMPLATE_PATH` contains no `.yml` files
- **THEN** the function SHALL output nothing (empty stdout)

### Requirement: Build preview command

The system SHALL return a command string suitable for `fzf --preview` that renders a template's YAML content.

- If `bat` is available, the command SHALL use `bat --language=yaml --color=always`
- If `bat` is not available, the command SHALL use `cat -n`

#### Scenario: bat is installed
- **WHEN** `bat` is available on PATH
- **THEN** the command SHALL start with `bat --language=yaml --color=always`

#### Scenario: bat is not installed
- **WHEN** `bat` is not available on PATH
- **THEN** the command SHALL start with `cat -n`

### Requirement: Interactively select a template

The system SHALL pipe template names into `fzf` with a preview window, and return the selected template name. If the user cancels or no selection is made, the system SHALL fall back to `TMUXINATOR_DEFAULT_TEMPLATE`.

#### Scenario: User selects a template
- **WHEN** user picks a template from the fzf list
- **THEN** the function SHALL output the selected template name

#### Scenario: User cancels fzf
- **WHEN** user presses Escape or Ctrl+C in fzf
- **THEN** the function SHALL output the value of `TMUXINATOR_DEFAULT_TEMPLATE`
