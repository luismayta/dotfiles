# Spec Delta

## Purpose

Provides Obsidian-style daily notes in Neovim: one Markdown file per day stored at a fixed absolute root, openable from any working directory through a global command, without requiring the Obsidian app or a vault structure.

## ADDED Requirements

### Requirement: Daily note file naming
The system SHALL store exactly one daily note per day, named with the date in `YYYY-MM-DD.md` format.

#### Scenario: Note filename matches the date
- **WHEN** the user opens today's daily note
- **THEN** the file SHALL be named with today's date as `YYYY-MM-DD.md` (for example `2026-11-19.md`)

### Requirement: Fixed absolute root independent of cwd
The system SHALL store daily notes under the fixed absolute root `~/notes/daily`, regardless of Neovim's current working directory.

#### Scenario: Open from an arbitrary directory
- **WHEN** Neovim is started from any directory and the user opens a daily note
- **THEN** the note SHALL be created or opened under `~/notes/daily`, never under the current working directory

#### Scenario: Root directory created on demand
- **WHEN** `~/notes/daily` does not exist and the user opens a daily note
- **THEN** the system SHALL create the root directory before writing the note

### Requirement: Markdown filetype
The system SHALL create daily notes as Markdown files with `.md` extension, which Neovim detects as buffer filetype `markdown`.

#### Scenario: Note opens as Markdown
- **WHEN** a daily note is opened
- **THEN** the buffer filetype SHALL be `markdown`

### Requirement: Global journal command
The system SHALL provide a global `:Journal day` command available in every Neovim session that creates or opens today's note.

#### Scenario: Create or open today's note
- **WHEN** the user runs `:Journal day` from any directory
- **THEN** `<root>/YYYY-MM-DD.md` for today SHALL be created if it does not exist, or opened if it already exists

### Requirement: Flat daily notes layout
The system SHALL store daily notes flat directly under the root, without nested year or month directory segments.

#### Scenario: No nested path segments
- **WHEN** a daily note is created
- **THEN** it SHALL be written at `<root>/YYYY-MM-DD.md` with no intermediate year or month directories
