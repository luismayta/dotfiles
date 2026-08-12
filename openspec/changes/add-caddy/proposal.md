## Why

We repeatedly need a simple, automatic-HTTPS local web server and reverse proxy for development — serving static files, proxying a local app behind a trusted `https://localhost` cert, or quickly exposing a port — without hand-rolling nginx configs or self-signed cert juggling. Caddy does exactly this with sane defaults, but it is not yet installed or managed by the dotfiles, so each machine sets it up ad hoc. Adding it to the devops module makes it available, idempotently installed, and documented across all environments.

## What Changes

- Add `caddy` as a PATH-only tool in the `zsh/modules/devops/` module, following the existing 3-layer pattern (`config/` → `internal/` → `pkg/`).
- Provide an idempotent install path: `brew install caddy` on macOS, and `sudo apt install caddy` (or the official caddy install script) on Linux.
- Provide thin public helper functions for the most common operations: `install`, `upgrade`, and `post_install` usage guidance (`caddy run`, `caddy file-server`, `caddy reverse-proxy`).
- Register `caddy` in the three `main.zsh` files and add it to the `DEVOPS_TOOLS` array in `config/base.zsh`.

## Capabilities

### New Capabilities
- `caddy`: Managed PATH-only Caddy web server / reverse-proxy tool — idempotent install plus helper functions for local HTTPS dev tooling.

### Modified Capabilities
<!-- none -->

## Impact

- New files under `zsh/modules/devops/`: `config/caddy.zsh`, `internal/caddy.zsh`, `pkg/caddy.zsh`, plus registration in the three `main.zsh` files and the `DEVOPS_TOOLS` array in `config/base.zsh`.
- New runtime dependency: the `caddy` binary (installed via `brew` on macOS or `apt`/official script on Linux).
- Caddy is config-less by default; the module does not manage a `Caddyfile` or a `data/caddy/` directory unless a template is later warranted (see design.md). User config lives in `~/.config/caddy/` only if the user creates it.
