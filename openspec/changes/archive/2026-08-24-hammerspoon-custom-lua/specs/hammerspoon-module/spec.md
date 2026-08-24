## Purpose

Defines where the hammerspoon user customization file lives, how the module seeds it on first run, and why a sync can never modify it: the file resides outside the managed configuration tree and is loaded from its own dedicated directory.

## ADDED Requirements

### Requirement: Custom override lives outside the managed tree
The user customization file SHALL reside at `<home>/.config/hammerspoon/custom.lua`, separate from the module-managed configuration directory, and the module sync SHALL NOT create, modify, or delete it while it exists.

#### Scenario: User edits survive sync
- **WHEN** `~/.config/hammerspoon/custom.lua` exists with user modifications and the user runs the module sync any number of times
- **THEN** the file remains byte-identical to the user's version

#### Scenario: Managed sync cannot reach the override
- **WHEN** the module sync copies the managed data tree into the Hammerspoon configuration directory
- **THEN** no file outside that destination directory is created, modified, or deleted by the sync

### Requirement: First-run seeding of the custom override
The module SHALL seed `~/.config/hammerspoon/custom.lua` from a shipped example file only when no customization file exists at that path, creating the target directory if needed.

#### Scenario: Fresh machine gets a starting point
- **WHEN** `~/.config/hammerspoon/custom.lua` does not exist and the user runs the module sync
- **THEN** the directory `~/.config/hammerspoon/` is created if missing and `custom.lua` is seeded from the shipped example content

#### Scenario: Existing override is never regenerated
- **WHEN** `~/.config/hammerspoon/custom.lua` exists and the user runs the module sync
- **THEN** the sync leaves it untouched and does not replace it with the example content

### Requirement: Deterministic resolution of the custom override
The Hammerspoon entrypoint SHALL guarantee that requiring the custom override module loads `~/.config/hammerspoon/custom.lua`, regardless of any other file named `custom.lua` elsewhere on the Lua module search path.

#### Scenario: Override loads from the customization directory
- **WHEN** Hammerspoon reloads its configuration and both `~/.config/hammerspoon/custom.lua` and a different `custom.lua` exist somewhere else on the search path
- **THEN** the loaded custom override module is the one in `~/.config/hammerspoon/custom.lua`

### Requirement: Repository tracks an example, never a live override
The module repository SHALL track an example customization file and SHALL NOT track a live `custom.lua`; repository ignore rules SHALL remain consistent with that layout.

#### Scenario: Inspecting tracked files
- **WHEN** the module data directory is inspected in version control
- **THEN** an example customization file is tracked and no live `custom.lua` is tracked or ignored inconsistently
