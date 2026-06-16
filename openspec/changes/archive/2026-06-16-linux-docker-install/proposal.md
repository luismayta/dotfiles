## Why

On Arch Linux, Docker is installed via `paru` (AUR helper) and requires additional post-install steps: enabling the systemd service, adding the user to the `docker` group, and verifying the installation. The current shared `install::provider` helper uses `core::install` which does not cover these Linux-specific steps.

## What Changes

- Modify `internal/docker.zsh` to detect Linux via `OSTYPE` and run Arch-specific install steps when on Linux:
  1. Install docker via `core::install` (which uses `paru` on Arch Linux)
  2. Install docker-compose via `core::install`
  3. Enable and start the docker systemd service
  4. Add the current user to the `docker` group
  5. Verify with `docker run hello-world`
- Keep macOS path unchanged (uses the shared `install::provider` helper as before)

## Capabilities

### New Capabilities

*(No new capabilities)*

### Modified Capabilities

- `docker-module`: The Docker provider install behavior on Linux changes from generic `core::install` to explicit `paru`-based installation with systemd and user group setup

## Impact

- **Affected code**: `zsh/modules/docker/internal/docker.zsh`
- **No breaking changes**: macOS path is unchanged; Linux path only runs on `linux*` OSTYPE
- **Dependencies**: Requires `paru` (AUR helper) on Arch Linux
