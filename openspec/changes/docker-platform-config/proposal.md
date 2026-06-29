## Why

The Docker ZSH module currently assumes a single-platform environment, defaulting to `orbstack` (macOS-only) as the container runtime. There is no OS detection, no Linux-specific configuration (systemd, socket paths, group permissions), and no macOS-specific paths for Docker Desktop or alternative providers. This makes the module unusable out-of-the-box on Linux and fragile on macOS when the user has multiple providers installed.

## What Changes

- Add **OS dispatch layer** per the standard module convention (`config/main.zsh → config/osx.zsh / config/linux.zsh`)
- Add **Linux-specific configuration** (`config/linux.zsh`): Docker socket path, systemd integration, user group, rootless mode support
- Add **macOS-specific configuration** (`config/osx.zsh`): provider auto-detection (Docker Desktop, Orbstack, Colima), Docker socket path per provider, resource defaults
- Add **OS-specific internal files** (`internal/osx.zsh`, `internal/linux.zsh`) to split the current mixed `internal/docker.zsh`
- Populate the currently **empty provider config stubs** (`config/colima.zsh`, `config/lima.zsh`, `config/orbstack.zsh`, `config/podman.zsh`) with platform-aware defaults
- Extend `config/base.zsh` with OS-aware default provider selection (`orbstack` on macOS, `docker` on Linux)
- Add **DOCKER_HOST auto-detection** based on active provider and platform
- Add `docker info` health-check on load to verify the runtime is reachable

## Capabilities

### New Capabilities
- `os-detection`: Detect macOS vs Linux at module load and set platform-specific environment variables and defaults
- `provider-auto-detect`: Auto-detect which container runtime is installed and active, falling back to platform default
- `linux-systemd-integration`: Docker socket management, systemd service enable/start, user group membership, rootless mode detection

### Modified Capabilities
- *(None — this is a new module; no existing specs to modify)*

## Impact

- **`zsh/modules/docker/config/base.zsh`**: New OS-aware default provider logic; default DOCKER_CONTAINER_APP_NAME changes per platform
- **`zsh/modules/docker/config/main.zsh`**: Add OS dispatch sourcing `config/osx.zsh` or `config/linux.zsh` before provider dispatch
- **`zsh/modules/docker/config/osx.zsh`**: **New file** — macOS-specific config (socket paths, brew prefix, Docker Desktop detection)
- **`zsh/modules/docker/config/linux.zsh`**: **New file** — Linux-specific config (socket path, docker group, rootless detection)
- **`zsh/modules/docker/config/colima.zsh`**: Populate with Colima-specific defaults
- **`zsh/modules/docker/config/lima.zsh`**: Populate with Lima-specific defaults
- **`zsh/modules/docker/config/orbstack.zsh`**: Populate with Orbstack-specific defaults
- **`zsh/modules/docker/config/podman.zsh`**: Populate with Podman-specific defaults (Linux/macOS)
- **`zsh/modules/docker/internal/main.zsh`**: Add OS dispatch sourcing `internal/osx.zsh` or `internal/linux.zsh`
- **`zsh/modules/docker/internal/osx.zsh`**: **New file** — macOS Docker Desktop install/load (extracted from `internal/docker.zsh`)
- **`zsh/modules/docker/internal/linux.zsh`**: **New file** — Linux Docker CE install/load with systemd (extracted from `internal/docker.zsh`)
- **`zsh/modules/docker/internal/docker.zsh`**: Keep as Docker Desktop (macOS) provider file within OS dispatch
- **`zsh/modules/docker/internal/base.zsh`**: Add DOCKER_HOST resolution and health-check functions
- **`zsh/modules/docker/pkg/osx.zsh`**: **New file** — macOS-specific public functions (placeholder)
- **`zsh/modules/docker/pkg/linux.zsh`**: **New file** — Linux-specific public functions (placeholder)
