## ADDED Requirements

### Requirement: pcall failures are visible during debugging
When a `vim.o[k] = v` assignment fails inside the `pcall` in `options.lua`, the system SHALL log a warning via `vim.notify()` describing the failed option key, value, and error message.

#### Scenario: Invalid option logs warning
- **WHEN** `options.lua` runs and `vim.o[k] = v` fails for a specific key
- **THEN** `vim.notify()` SHALL be called with a message containing the option key and error
