## ADDED Requirements

### Requirement: yazi.toml configures custom linemode
The system SHALL ship a `yazi.toml` in `~/.config/yazi/` that sets:
```toml
[mgr]
linemode = "custom"
```

#### Scenario: yazi.toml exists after sync
- **WHEN** `yazi::sync` completes
- **THEN** `~/.config/yazi/yazi.toml` SHALL exist with `linemode = "custom"` under the `[mgr]` section

#### Scenario: yazi uses custom linemode
- **WHEN** yazi starts with `yazi.toml` containing `linemode = "custom"`
- **THEN** the file list SHALL render using `Linemode:custom()` from init.lua

### Requirement: yazi.toml is managed by the module
The system SHALL treat `yazi.toml` as a synced asset, written to `~/.config/yazi/` on every `yazi::sync` invocation.

#### Scenario: yazi.toml is overwritten on sync
- **WHEN** `yazi::sync` runs
- **THEN** `~/.config/yazi/yazi.toml` SHALL be overwritten with the module's version
