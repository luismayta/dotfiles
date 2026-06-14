## Why

Currently `fnm::internal::packages::install` installs every package in `FNM_PACKAGES` at once via `bun install -g`. There is no way to install a single package individually. This blocks selective or on-demand package installation — for example, installing a package outside the default set or re-installing a single failed package without re-running the full batch.

## What Changes

- Add `fnm::internal::package::install` function that accepts a package name argument and installs it with `bun install -g <package>`
- Add corresponding public function `fnm::package::install` in `pkg/base.zsh`
- Wire the new function so it is available through the module's public interface

## Capabilities

### New Capabilities
- `package-install`: Install a single bun package by name, with argument validation and error handling

### Modified Capabilities

None — no existing specs are changing.

## Impact

- **`zsh/modules/fnm/internal/base.zsh`**: New `fnm::internal::package::install` function
- **`zsh/modules/fnm/pkg/base.zsh`**: New `fnm::package::install` public delegating function
