## Context

The `zsh/modules/devops/` module uses a 3-layer architecture: `config/<tool>.zsh` (registration/exports), `internal/<tool>.zsh` (logic/helpers), `pkg/<tool>.zsh` (public wrappers), each wired through its `main.zsh` and the `DEVOPS_TOOLS` array in `config/base.zsh`. `caddy` is a PATH-only CLI (no shell hooks, no `eval "$(caddy init zsh)"`), so it follows the `bruno`/`cloudflared` pattern, not the `atuin` shell-hook pattern. See proposal.md — Why for motivation.

## Goals / Non-Goals

**Goals:**
- Integrate `caddy` into the devops module using the existing 3-layer pattern.
- Idempotent, low-friction install (brew on macOS; apt or official script on Linux).
- Thin, discoverable public helper functions (`install`, `upgrade`, `post_install`).

**Non-Goals:**
- Managing a `Caddyfile` or a `data/caddy/` directory — caddy is config-less by default (see Decisions).
- Auto-starting caddy as a daemon or managing systemd units.
- Replacing the system package manager on systems that already provide `caddy` via apt.

## Decisions

- **PATH-only pattern (bruno/cloudflared-style)**: `caddy` needs no shell hooks, so we only check availability with `core::exists` and add nothing to the shell environment beyond PATH. Rationale: matches the tool's design and the existing `bruno`/`cloudflared` references; avoids the heavier `atuin` hook machinery.
- **Registration lines**: add one explicit `source` line per layer, mirroring the existing `cloudflared` registration:
  - `config/main.zsh` (after the base source):
    ```zsh
    # shellcheck source=/dev/null
    source "${DEVOPS_PATH}/config/caddy.zsh"
    ```
  - `internal/main.zsh`:
    ```zsh
    # shellcheck source=/dev/null
    source "${DEVOPS_PATH}/internal/caddy.zsh"
    ```
  - `pkg/main.zsh`:
    ```zsh
    # shellcheck source=/dev/null
    source "${DEVOPS_PATH}/pkg/caddy.zsh"
    ```
  - Add `"caddy"` to the `DEVOPS_TOOLS` array in `config/base.zsh`.
- **Install command per platform**: macOS uses `core::install caddy` (brew-backed). Linux uses `core::install caddy` (apt-backed) or the official caddy install script as a fallback. Rationale: `core::install` is the module's existing convention for package installs (see `cloudflared.zsh`/`bruno.zsh`), keeping the install path uniform and idempotent.
- **Internal function shape**: `internal/caddy.zsh` defines `devops::caddy::internal::{load,install,upgrade,main::factory}`. `load` guards with `core::exists caddy` and returns early when absent; the file ends by invoking `devops::caddy::internal::load` and `devops::caddy::internal::main::factory` (mirroring `helm`/`k9s`/`atuin`). `main::factory` runs `core::ensure caddy` so a missing binary triggers the idempotent install on demand.
- **Public wrappers (pkg)**: `pkg/caddy.zsh` exposes `devops::caddy::{install,upgrade,post_install}` (and `load`/`sync` if applicable) that delegate to the internal layer. `post_install` prints usage guidance: `caddy run`, `caddy file-server`, `caddy reverse-proxy`.
- **Config left to the tool**: `~/.config/caddy/` is created and owned by `caddy`; the module never writes there. No `data/caddy/` directory and no `sync` target are added because caddy is config-less by default. A `Caddyfile` template is intentionally out of scope unless a later change warrants one.

## Risks / Trade-offs

- **Platform install divergence** → Mitigation: install is delegated to `core::install`, which already abstracts brew vs apt; the official caddy script is the documented fallback for non-apt Linux.
- **Version drift** → Mitigation: `caddy upgrade` is the documented upgrade path; the install helper can be re-run to refresh.
- **Network dependency at install** → Mitigation: install is a one-time, explicit step; module load only checks availability, it does not fetch on every shell start.
- **No managed Caddyfile** → Mitigation: acceptable because caddy's defaults cover the dev use cases (`file-server`, `reverse-proxy`); users who need a `Caddyfile` create it themselves in `~/.config/caddy/`.

## Migration Plan

1. Create the three `caddy.zsh` files (`config/`, `internal/`, `pkg/`).
2. Register caddy in the three `main.zsh` files and add `"caddy"` to `DEVOPS_TOOLS`.
3. Validate with `openspec validate` and `shellcheck` on the new zsh files.
4. Rollback: remove the three source lines and the `DEVOPS_TOOLS` entry; the module loads as before. No data is migrated because the module manages no caddy state.

## Open Questions

- None that affect the specs, approach, or task breakdown. (Whether to ship a `Caddyfile` template can be decided later as a separate change.)
