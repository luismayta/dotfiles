## ADDED Requirements

### Requirement: OSTYPE-based app name resolution

The system SHALL resolve cross-platform app name arrays based on the current operating system, selecting the correct set of package names for the running platform.

- On a macOS system (`$OSTYPE =~ ^darwin`): All `APPS_<CATEGORY>` arrays SHALL be populated from their `APPS_<CATEGORY>__DARWIN` counterparts.
- On a Linux system (`$OSTYPE =~ ^linux`): All `APPS_<CATEGORY>` arrays SHALL be populated from their `APPS_<CATEGORY>__LINUX` counterparts.
- On any other OSTYPE: `APPS_<CATEGORY>` arrays SHALL fall back to `APPS_<CATEGORY>__DARWIN`.
- The `APPS_PACKAGES` aggregate SHALL reference the resolved (non-suffixed) `APPS_<CATEGORY>` arrays after resolution.

#### Scenario: macOS resolution
- **WHEN** `$OSTYPE` starts with `darwin`
- **THEN** `APPS_<CATEGORY>` equals `APPS_<CATEGORY>__DARWIN` for all 12 categories

#### Scenario: Linux resolution
- **WHEN** `$OSTYPE` starts with `linux`
- **THEN** `APPS_<CATEGORY>` equals `APPS_<CATEGORY>__LINUX` for all 12 categories

#### Scenario: Unknown OS fallback
- **WHEN** `$OSTYPE` is neither `darwin*` nor `linux*`
- **THEN** `APPS_<CATEGORY>` equals `APPS_<CATEGORY>__DARWIN` for all 12 categories

#### Scenario: New category propagation
- **WHEN** a new category is added to the `_APPS_CATEGORIES` list
- **THEN** it SHALL be automatically resolved without modifying the OSTYPE resolution logic
