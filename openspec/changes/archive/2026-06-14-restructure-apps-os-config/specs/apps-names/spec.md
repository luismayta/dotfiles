## DELTA Requirements

The following requirements from `openspec/specs/apps-names/spec.md` are **replaced** by this change:

**REPLACED:** Requirement "The system SHALL resolve app names per operating system using __DARWIN / __LINUX suffix arrays"
**NEW:** The system SHALL organize app names per operating system using OS-specific config files loaded by main.zsh.

### Requirement: The system SHALL organize app names per operating system using OS-specific config files
Each category SHALL define app names in the file corresponding to the target OS:
- **Cross-OS apps** (identical package name on macOS and Linux) SHALL be defined in `config/base.zsh` as bare `APPS_<CATEGORY>` arrays.
- **macOS-specific apps** SHALL be defined in `config/osx.zsh` as bare `APPS_<CATEGORY>` arrays (or appended to `APPS_PACKAGES` via `+=(...)` for exclusive apps).
- **Linux-specific apps** SHALL be defined in `config/linux.zsh` as bare `APPS_<CATEGORY>` arrays (or appended to `APPS_PACKAGES` via `+=(...)` for exclusive apps).

The `case $OSTYPE` dispatch in `config/main.zsh` SHALL be the sole mechanism for selecting the correct OS-specific file. No `__DARWIN`/`__LINUX` suffix arrays or OSTYPE resolution block SHALL exist in `base.zsh`.

#### Scenario: Cross-OS apps are defined in base.zsh
- **WHEN** the config is loaded
- **THEN** `APPS_<CATEGORY>` arrays in `base.zsh` SHALL contain only apps whose package name is identical on macOS and Linux (e.g., `tig`, `meld`, `discord`, `android-studio`, `openvpn`, `jira-cli`)
- **AND** `base.zsh` SHALL NOT contain any `__DARWIN` or `__LINUX` suffixed arrays

#### Scenario: macOS app names are defined in osx.zsh
- **WHEN** `$OSTYPE` matches `darwin*`
- **AND** `config/osx.zsh` is sourced
- **THEN** `APPS_<CATEGORY>` arrays in `osx.zsh` SHALL override or supplement the ones from `base.zsh` with macOS-specific package names (e.g., `intellij-idea-ce`, `obsidian`, `brave-browser`)

#### Scenario: Arch Linux app names are defined in linux.zsh
- **WHEN** `$OSTYPE` matches `linux*`
- **AND** `config/linux.zsh` is sourced
- **THEN** `APPS_<CATEGORY>` arrays in `linux.zsh` SHALL override or supplement the ones from `base.zsh` with Arch Linux package names (e.g., `intellij-idea-community-edition`, `obsidian-bin`, `brave-bin`)
