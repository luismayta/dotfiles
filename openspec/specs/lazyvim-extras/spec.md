## ADDED Requirements

### Requirement: Declare LazyVim extras
The system SHALL declare LazyVim extras in a `lazyvim.json` file to enable features that replace manually configured plugins.

#### Scenario: Extras are loaded on startup
- **WHEN** Neovim starts
- **THEN** all extras listed in `lazyvim.json` SHALL be automatically loaded by LazyVim

### Requirement: Enable editor extras
The system SHALL enable the following LazyVim editor extras: harpoon2, grug-far, edgy, diffview, neogit, undotree, trouble-ls.

#### Scenario: harpoon2 extra is available
- **WHEN** user presses `<leader>h` or configured harpoon keymap
- **THEN** the harpoon2 quick menu SHALL open for file navigation

#### Scenario: grug-far extra is available
- **WHEN** user invokes grug-far
- **THEN** a UI for global search and replace SHALL be available

#### Scenario: diffview extra is available
- **WHEN** user invokes diffview
- **THEN** a visual diff interface SHALL be available

### Requirement: Enable coding extras
The system SHALL enable the following LazyVim coding extras: mini-surround, neogen.

#### Scenario: mini-surround is available
- **WHEN** user presses `ys` or configured surround keymap
- **THEN** text surrounding operations SHALL work

### Requirement: Enable DAP extra
The system SHALL enable LazyVim DAP core extra for debugging support.

#### Scenario: DAP extra is available
- **WHEN** user sets a breakpoint
- **THEN** the debug adapter protocol SHALL be configured and ready

### Requirement: Enable language extras
The system SHALL enable LazyVim language extras for: docker, go, helm, json, markdown, python, rust, terraform, typescript, yaml.

#### Scenario: Language extras provide LSP support
- **WHEN** a file of a supported language type is opened
- **THEN** the corresponding LSP server SHALL be configured via mason and attached

### Requirement: Enable neoconf extra
The system SHALL enable LazyVim neoconf extra for project-local LSP configuration.

#### Scenario: Neoconf loads project settings
- **WHEN** a `.neoconf.json` file exists in the project root
- **THEN** neoconf SHALL load project-specific LSP settings
