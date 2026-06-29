## 1. OS Dispatch Layer — Config

- [ ] 1.1 Create `config/osx.zsh` with macOS-specific defaults: `DOCKER_SOCKET_PATH` (provider-resolved), `DOCKER_BREW_PREFIX`, Docker Desktop app detection path
- [ ] 1.2 Create `config/linux.zsh` with Linux-specific defaults: `DOCKER_SOCKET_PATH=/var/run/docker.sock`, `DOCKER_GROUP_NAME=docker`, rootless detection path via `$XDG_RUNTIME_DIR`
- [ ] 1.3 Modify `config/base.zsh` to set platform-appropriate default provider: `orbstack` on macOS, `docker` on Linux (respecting user override via `DOCKER_CONTAINER_APP_NAME`)
- [ ] 1.4 Modify `config/main.zsh` to source `config/osx.zsh` or `config/linux.zsh` based on `$OSTYPE` before the existing provider dispatch

## 2. OS Dispatch Layer — Internal

- [ ] 2.1 Create `internal/osx.zsh` with macOS-specific Docker Desktop install/load (extracted from `internal/docker.zsh`): check `/Applications/Docker.app`, install via Homebrew, open app if not running
- [ ] 2.2 Create `internal/linux.zsh` with Linux Docker CE install/load: systemd service enable/start, docker group membership check, docker-compose detection
- [ ] 2.3 Modify `internal/main.zsh` to source `internal/osx.zsh` or `internal/linux.zsh` based on `$OSTYPE` before the provider dispatch

## 3. Provider Config Files

- [ ] 3.1 Populate `config/orbstack.zsh` with Orbstack-specific defaults (`DOCKER_HOST=unix://${HOME}/.orbstack/run/docker.sock`)
- [ ] 3.2 Populate `config/colima.zsh` with Colima-specific defaults and DOCKER_HOST resolver reference
- [ ] 3.3 Populate `config/lima.zsh` with Lima-specific defaults (`DOCKER_LIMA_MACHINE_NAME`, socket path resolver reference)
- [ ] 3.4 Populate `config/podman.zsh` with Podman-specific defaults (`DOCKER_PODMAN_MACHINE_NAME`, socket path `unix:///run/user/${UID}/podman/podman.sock`)

## 4. DOCKER_HOST Auto-Resolution

- [ ] 4.1 Add `docker::internal::resolve::socket` function in `internal/base.zsh` that sets `DOCKER_HOST` based on active provider, respecting user pre-set values
- [ ] 4.2 Integrate socket resolution into the internal factory flow in `internal/main.zsh`

## 5. Docker Connectivity Health Check

- [ ] 5.1 Add `docker::internal::health::check` function in `internal/base.zsh` that runs `docker info` with a 2-second timeout
- [ ] 5.2 Integrate health check into `internal/main.zsh` factory, emitting warning on failure, silent on success

## 6. Provider Auto-Detection

- [ ] 6.1 Add provider auto-detection to `config/osx.zsh` that enumerates available runtimes via `$PATH` checks (orbstack, colima, docker, limactl, podman)
- [ ] 6.2 Export `DOCKER_AVAILABLE_PROVIDERS` array with detected runtimes

## 7. OS-Specific Public Files (Placeholders)

- [ ] 7.1 Create `pkg/osx.zsh` — macOS-specific public functions (stub with header comment, per standard convention)
- [ ] 7.2 Create `pkg/linux.zsh` — Linux-specific public functions (stub with header comment, per standard convention)
- [ ] 7.3 Modify `pkg/main.zsh` to add OS dispatch sourcing `pkg/osx.zsh` or `pkg/linux.zsh`

## 8. Verify and Test

- [ ] 8.1 Verify module loads cleanly on macOS with Orbstack, Colima, Docker Desktop
- [ ] 8.2 Verify module loads cleanly on Linux with native Docker (rootful and rootless)
- [ ] 8.3 Verify user overrides (`DOCKER_CONTAINER_APP_NAME`, `DOCKER_HOST`) are respected
- [ ] 8.4 Run `lsp_diagnostics` on all modified files for syntax errors
