## ADDED Requirements

### Requirement: Remove disabled plugin files
The system SHALL remove all plugin files that have `enabled = false` flag.

#### Scenario: Delete lsp-signature.lua
- **WHEN** the cleanup is executed
- **THEN** the file `navigation/lsp-signature.lua` SHALL be deleted

#### Scenario: Delete hover.lua
- **WHEN** the cleanup is executed
- **THEN** the file `navigation/hover.lua` SHALL be deleted

#### Scenario: Delete searchbox.lua
- **WHEN** the cleanup is executed
- **THEN** the file `tools/searchbox.lua` SHALL be deleted

#### Scenario: Delete fine-cmdline.lua
- **WHEN** the cleanup is executed
- **THEN** the file `tools/fine-cmdline.lua` SHALL be deleted

#### Scenario: Delete dropbar.lua
- **WHEN** the cleanup is executed
- **THEN** the file `ui/dropbar.lua` SHALL be deleted

#### Scenario: Delete screenkey.lua
- **WHEN** the cleanup is executed
- **THEN** the file `ui/screenkey.lua` SHALL be deleted

### Requirement: Remove disabled plugin blocks from composite files
The system SHALL remove disabled plugin spec blocks from files containing multiple plugins.

#### Scenario: Remove indent-blankline from ui.lua
- **WHEN** the cleanup is executed
- **THEN** the `indent-blankline.nvim` spec block in `ui/ui.lua` SHALL be removed
- **AND** other plugin specs in ui.lua SHALL remain intact

### Requirement: Verify no broken references
The system SHALL ensure no active code references removed plugins.

#### Scenario: Check for removed plugin requires
- **WHEN** the cleanup is executed
- **THEN** `grep -r "require.*lsp_signature\|require.*hover\|require.*searchbox\|require.*fine-cmdline\|require.*dropbar\|require.*screenkey\|require.*indent_blankline"` SHALL return no results

### Requirement: Maintain directory structure
The system SHALL preserve the existing directory structure after cleanup.

#### Scenario: Plugin directories remain
- **WHEN** the cleanup is executed
- **THEN** the directories `navigation/`, `tools/`, `ui/` SHALL still exist
- **AND** other files in these directories SHALL remain untouched