## Why

The current apps config duplicates OS dispatch logic: `main.zsh` already selects `osx.zsh`/`linux.zsh` via `case $OSTYPE`, yet `base.zsh` also stores `__DARWIN`/`__LINUX` arrays and re-resolves them at runtime. This forces every category to define the same app twice even when names are identical, and requires a nameref loop to collapse them. By letting the OS-specific files own their respective package names, we eliminate an entire layer of indirection.

## What Changes

- **Remove** all `APPS_<CATEGORY>__DARWIN` and `APPS_<CATEGORY>__LINUX` suffixed arrays from `base.zsh`
- **Remove** the OSTYPE resolution block (suffix selector + nameref loop + unset) from `base.zsh`
- **Move** macOS-specific app names (brew package names) from `__DARWIN` arrays into `config/osx.zsh` as direct `APPS_<CATEGORY>` arrays
- **Move** Linux-specific app names (Arch package names) from `__LINUX` arrays into `config/linux.zsh` as direct `APPS_<CATEGORY>` arrays
- **Keep** in `base.zsh` only apps whose package name is identical on both OS (`tig`, `meld`, `discord`, `android-studio`, `openvpn`, `jira-cli`, etc.)
- `APPS_PACKAGES` aggregate in `base.zsh` continues to merge all resolved arrays; OS-specific files append extras via `APPS_PACKAGES+=()`

## Capabilities

### New Capabilities
*(none — no new capabilities introduced)*

### Modified Capabilities
- `apps-names`: Change how OS-specific app names are organized. Instead of `__DARWIN`/`__LINUX` suffix arrays in `base.zsh` with OSTYPE-based resolution, the OS-specific config files (`osx.zsh`/`linux.zsh`) SHALL own their respective category arrays directly. `base.zsh` SHALL only define apps common to both OS.

## Impact

- `zsh/modules/apps/config/base.zsh` — remove ~40 lines (suffixed arrays + resolution block), keep common-apps arrays + `APPS_PACKAGES`
- `zsh/modules/apps/config/osx.zsh` — add category arrays for macOS-specific package names (brew cask)
- `zsh/modules/apps/config/linux.zsh` — populate with category arrays for Linux-specific package names (Arch)
- `zsh/modules/apps/config/main.zsh` — unchanged (already dispatches by OSTYPE)
