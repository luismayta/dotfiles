## ADDED Requirements

### Requirement: All modules are audited for platform compatibility

Every module under `zsh/modules/` SHALL be reviewed and tagged with an accurate `# Platform:` declaration based on its actual requirements. The audit SHALL consider:
- Whether the module's `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh` reference platform-specific tools or paths
- Whether the module has explicit no-op stubs for a platform (e.g., `hyprland/pkg/osx.zsh`)
- Whether the tool or functionality the module manages exists on the target platform

#### Scenario: Linux-only module is tagged
- **WHEN** a module only provides `linux.zsh` files with meaningful content
- **AND** its `osx.zsh` files are no-op stubs
- **THEN** the module SHALL declare `# Platform: linux`

#### Scenario: Cross-platform module with OS-specific internals is tagged for both
- **WHEN** a module has meaningful `osx.zsh` AND `linux.zsh` files
- **THEN** the module SHALL declare `# Platform: darwin, linux`

### Requirement: Audit produces a platform compatibility table

The audit SHALL produce a table listing each module and its determined platform compatibility. This table SHALL be included in the design documentation.

#### Scenario: Audit table exists
- **WHEN** the audit is complete
- **THEN** there SHALL be a documented table with columns: Module Name, Platform, Rationale

### Requirement: Modules with unknown status default to cross-platform

If a module's platform compatibility cannot be clearly determined during audit, it SHALL default to `darwin, linux` (cross-platform) to maintain backward compatibility.

#### Scenario: Uncertain module defaults to both
- **WHEN** a module's platform affinity is unclear
- **THEN** it SHALL be tagged `# Platform: darwin, linux`
