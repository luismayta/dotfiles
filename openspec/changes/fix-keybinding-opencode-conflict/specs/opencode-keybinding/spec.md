## ADDED Requirements

### Requirement: Opencode select keybinding SHALL not conflict with window management prefix

The opencode plugin's "select" action SHALL be bound to `<C-z>` in normal and visual modes. The binding SHALL NOT use any key that serves as a prefix for window management shortcuts.

#### Scenario: Opencode select activates on Ctrl-Z
- **WHEN** user presses `<C-z>` in normal or visual mode
- **THEN** opencode's `select()` function is invoked

#### Scenario: Opencode select does not intercept window management prefix
- **WHEN** user presses `<C-x>` followed by a window management key (e.g., `1`, `2`, `3`, `h`, `j`, `k`, `l`, `v`, `s`, `o`, `c`, `q`)
- **THEN** the corresponding window management action executes without interference from opencode

### Requirement: Opencode ask keybinding SHALL remain unchanged

The opencode plugin's "ask" action SHALL remain bound to `<C-a>` in normal and visual modes.

#### Scenario: Opencode ask still works on Ctrl-A
- **WHEN** user presses `<C-a>` in normal or visual mode
- **THEN** opencode's `ask` function is invoked with the `@this:` prompt
