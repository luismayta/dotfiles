## Purpose

Provides vim-mode keybindings and a customizable leader key (',') for Helix editor, enabling Vim users to leverage familiar muscle memory while retaining Helix's selection-first benefits.

## ADDED Requirements

### Requirement: Vim-mode keybindings in normal mode
The system SHALL provide vim-style keybindings in Helix's normal mode for common editing operations.

#### Scenario: Word navigation
- **WHEN** user presses `w` in normal mode
- **THEN** cursor moves to next word start (Helix's `move_next_word_start`)

#### Scenario: Line deletion
- **WHEN** user presses `dd` in normal mode
- **THEN** current line is deleted and copied to register

#### Scenario: Line yank
- **WHEN** user presses `yy` in normal mode
- **THEN** current line is copied to register without deletion

### Requirement: Insert mode exit via jj/jk
The system SHALL allow users to exit insert mode using `jj` or `jk` sequences.

#### Scenario: Exit insert mode with jj
- **WHEN** user types `jj` in insert mode
- **THEN** editor transitions to normal mode

#### Scenario: Exit insert mode with jk
- **WHEN** user types `jk` in insert mode
- **THEN** editor transitions to normal mode

### Requirement: Leader key ',' for quick commands
The system SHALL provide a leader key sequence using ',' for common file operations.

#### Scenario: Save with leader key
- **WHEN** user types `,w` in normal mode
- **THEN** current file is saved (`:write`)

#### Scenario: Quit with leader key
- **WHEN** user types `,q` in normal mode
- **THEN** current buffer is closed (`:quit`)

#### Scenario: File picker with leader key
- **WHEN** user types `,e` in normal mode
- **THEN** file picker opens (`file_picker`)

#### Scenario: Find in files with leader key
- **WHEN** user types `,f` in normal mode
- **THEN** global search opens (`global_search`)

### Requirement: Preserve Helix native selection mode
The system SHALL maintain Helix's native selection-mode keybindings without override.

#### Scenario: Selection mode unchanged
- **WHEN** user enters select mode (pressing `v`)
- **THEN** all default Helix selection keybindings remain functional

### Requirement: Configuration in data/config.toml
The system SHALL store vim-mode configuration in `zsh/modules/helix/data/config.toml`.

#### Scenario: Config file contains vim bindings
- **WHEN** helix module is synced
- **THEN** `~/.config/helix/config.toml` contains `[keys.normal]`, `[keys.insert]`, and `[keys.select]` sections with vim-mode bindings
