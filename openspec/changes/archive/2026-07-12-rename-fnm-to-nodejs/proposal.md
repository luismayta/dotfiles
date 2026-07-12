## Why

The `fnm` module has evolved beyond its original scope of managing just the FNM (Fast Node Manager) binary. It now handles Node.js version management, npm package installation, and overall Node.js toolchain setup — but the naming still reflects only one tool (`fnm`). Renaming to `nodejs` aligns module identity with its actual responsibility and makes the module discoverable alongside related tooling (`python`, `rust`, `goenv`, `rvm`, `nix`).

## What Changes

- Rename `zsh/modules/fnm/` to `zsh/modules/nodejs/` (directory move)
- Rename all internal variable scopes: `ZSH_FNM_*` → `ZSH_NODEJS_*` (LOADED, PATH, ENABLED)
- Rename all function scopes: `fnm::*` → `nodejs::*` (both internal and public API)
- Rename module config variables: `FNM_PACKAGE_NAME` → `NODEJS_TOOL_NAME`, `FNM_VERSION_GLOBAL` → `NODEJS_VERSION_GLOBAL`, `FNM_PACKAGES` → `NODEJS_PACKAGES`
- Keep external tool references unchanged: `FNM_PATH`, `FNM_INSTALL_URL`, `FNM_VERSION`, `fnm install`, `fnm env`, `fnm use`, `fnm alias` still point to the actual fnm binary
- Update `.goji.json` scope reference: `"fnm"` → `"nodejs"`
- Add `nodejs` to `DOTFILES_SETUP_MODULES` in `zsh/core/pkg/setup.zsh` (fnm was missing)

## Capabilities

### New Capabilities
- (none — this is a rename of existing `fnm-module`)

### Modified Capabilities
- `fnm-module`: All REQUIREMENTS shift from `fnm`-scoped identifiers to `nodejs`-scoped identifiers. The spec file location is renamed to `nodejs-module`.

## Impact

- **Affected module**: `zsh/modules/fnm/` → `zsh/modules/nodejs/` (16 files across 4 subdirectories)
- **External references**: `.goji.json` (one scope entry)
- **Module registration**: `zsh/core/pkg/setup.zsh` — should add `nodejs` to `DOTFILES_SETUP_MODULES`
- **Spec**: `openspec/specs/fnm-module/` renamed to `openspec/specs/nodejs-module/`
- **No breakage**: Module is auto-discovered by directory iteration in `zshrc` — no hardcoded module imports
- **No external consumers**: No other files reference `fnm` outside the module itself
