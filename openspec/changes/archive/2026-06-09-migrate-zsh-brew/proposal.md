## Why

Migrate `luismayta/zsh-brew` from an external antidote-managed plugin into the dotfiles monorepo as `zsh/modules/brew/`. This eliminates an external dependency, simplifies the bootstrap, and unifies brew package management under the modules convention established by `zsh/modules/core/`.

## What Changes

- Create `zsh/modules/brew/` with the same multi-file structure as `zsh/modules/core/` (config/, internal/, pkg/ subdirectories, OS dispatch)
- Port all functions from `zsh-brew.zsh` preserving their namespaces:
  - `brew::install`, `brew::install::osx`, `brew::install::linux`
  - `brew::dependences::install`, `brew::dependences::checked`
  - `brew::post_install`
  - `brew::load` (PATH/MANPATH/INFOPATH/LD_LIBRARY_PATH exports)
- Remove `luismayta/zsh-brew` from `zsh/zsh_plugins.txt`
- The existing `brew::load` auto-invocation and auto-install side-effect is preserved

## Capabilities

### New Capabilities
- `brew`: Homebrew installation, PATH management, and post-install package setup with OS-specific dispatch (macOS/Linux)

### Modified Capabilities

None.

## Impact

- **Removed dependency**: `luismayta/zsh-brew` external plugin (antidote bundle)
- **New module**: `zsh/modules/brew/` with multi-file structure
- **zsh_plugins.txt**: Remove `luismayta/zsh-brew` line
- **No breaking changes**: All public function namespaces preserved
