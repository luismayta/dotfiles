## Context

The `docker` provider (`internal/docker.zsh`) currently delegates install to the shared `docker::internal::container::install::provider` helper, which uses `core::install` (package manager generic). On Arch Linux, Docker installation requires `paru` and post-install steps (systemd enable, user group, verification) that `core::install` cannot handle.

## Goals / Non-Goals

**Goals:**
- Add Linux-specific install path in `internal/docker.zsh` that runs when `OSTYPE` matches `linux*`
- Steps: `core::install docker` + `core::install docker-compose` (via paru) → `sudo systemctl enable --now docker` → `sudo usermod -aG docker $USER` → `docker run hello-world`
- Keep macOS path unchanged (shared `install::provider` helper)

**Non-Goals:**
- No changes to other providers (colima, lima, podman, orbstack)
- No changes to non-Linux platforms
- No changes to the `install::provider` shared helper

## Decisions

1. **OSTYPE check in `internal/docker.zsh`** — The simplest, most maintainable approach. Check `[[ "${OSTYPE}" == linux* ]]` at the top of the install function to branch between Linux-specific and generic install. No need for early sourcing of a separate file.

2. **Use `core::install`** — `core::install` already delegates to `paru -S --noconfirm` on Linux (`zsh/core/internal/linux.zsh`). Using it instead of hardcoding `sudo paru -S` keeps the codebase consistent and avoids duplicating the paru dispatch logic.

3. **Run as sudo** — `systemctl enable` and `usermod` require root. Use `sudo` prefix for those commands only, not for `core::install` (the core module handles sudo via paru's own configuration).

4. **Idempotency** — `core::install` is idempotent (checks `core::exists`); `systemctl enable --now` is idempotent; `usermod -aG` is idempotent (adds only if not already in group); `docker run hello-world` is the verification step.

## Risks / Trade-offs

- **[Risk]** `paru` may not be installed → **Mitigation**: The function checks `core::exists docker` first; if Docker is already installed, it skips. If not, `paru` is expected on Arch Linux.
- **[Risk]** Non-Arch Linux distros → **Mitigation**: The check is `linux*` but the commands are Arch-specific. If needed, a distro detection step can be added later.
- **[Risk]** Running `docker run hello-world` in an install function is slow → **Mitigation**: This is a verification step that runs once during initial install; subsequent module loads skip because `core::exists docker` returns true.
