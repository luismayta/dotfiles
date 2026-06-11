## MODIFIED Requirements

### Requirement: Shell reload function
**EDIT**: No changes to reload behavior — the function already works when core loads. This spec documents that the fix is in zshrc, not in the reload function itself.

The shared utils layer SHALL provide a `reload` function that restarts the shell.

#### Scenario: reload restarts shell
- **WHEN** `reload` is called on macOS
- **THEN** it SHALL execute `exec "${SHELL}" -l`