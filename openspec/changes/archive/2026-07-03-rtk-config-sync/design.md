## Context

RTK is installed in the ai module (`ai::internal::rtk::install`, `ai::internal::rtk::load`) but has no managed configuration. Other tools in the module follow a consistent pattern: source config files live in `data/<tool>/` and are synced via `rsync` to their runtime config directory on demand.

- **opencode**: `data/opencode/` → `~/.config/opencode/` (sync in `ai::internal::opencode::sync`)
- **pi**: `data/pi/` → `~/.pi/agent/` (sync in `ai::internal::pi::config::sync`)
- **hunk**: `data/hunk/config.toml` → `~/.config/hunk/` (no sync function yet — file exists but isn't wired)

RTK's config file lives at `~/.config/rtk/config.toml` (Linux) and is optional — if missing, RTK uses built-in defaults.

## Goals / Non-Goals

**Goals:**
- Add `AI_RTK_CONFIG_PATH` and `AI_RTK_CONFIG_SOURCE_PATH` variables to `config/base.zsh`
- Create `data/rtk/config.toml` with tool exclusions (`[hooks] exclude_commands`) and sensible defaults
- Implement `ai::internal::rtk::config::sync` function following the established rsync pattern
- Make the sync function discoverable and callable

**Non-Goals:**
- NOT changing `ai::internal::rtk::install` or `ai::internal::rtk::load` — those stay as-is
- NOT adding automatic sync on shell load — sync is on-demand like opencode/pi
- NOT implementing TOML filter management (`.rtk/filters.toml`) — that's project-level, not user-level

## Decisions

### 1. Follow the rsync pattern (opencode/pi precedent)

**Decision**: Use `rsync -a "$src/" "$dst/"` like `ai::internal::opencode::sync` and `ai::internal::pi::config::sync`.

**Rationale**: Consistency with the module's existing pattern. rsync is already a dependency (guarded by `core::exists rsync` in `plugin.zsh`). No new dependencies needed.

### 2. Config file: TOML (RTK native format)

**Decision**: Create `data/rtk/config.toml` in TOML format, matching RTK's native config format exactly.

**Rationale**: RTK reads TOML natively. No transformation needed. Users can edit the source file and re-sync.

### 3. Tool exclusions as the primary config content

**Decision**: The default config will include `[hooks] exclude_commands` with common commands that should not be proxied through RTK (e.g., interactive editors, sensitive operations).

**Rationale**: This is the user's stated requirement. The exclusion mechanism is RTK's documented `[hooks] exclude_commands` array. Regex support (`^pattern`) is available for advanced patterns.

### 4. Config path variables naming

**Decision**: Use `AI_RTK_CONFIG_PATH` for destination and `AI_RTK_CONFIG_SOURCE_PATH` for source, matching `AI_PI_CONFIG_PATH`/`AI_PI_CONFIG_SOURCE_PATH` convention.

**Rationale**: Consistency with the pi tool's naming, which is the closest analog (separate config dir synced from `data/`).

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| rsync not installed | Guarded by `core::exists rsync` check in the sync function (same as opencode sync). `plugin.zsh` already ensures rsync is installed. |
| Config file at destination gets overwritten on re-sync | Acceptable — the source file is the source of truth. Document this behavior. |
| RTK config format changes upstream | The TOML format is stable. Monitor upstream releases. |
