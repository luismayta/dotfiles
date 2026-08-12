## Why

We repeatedly need to expose local services over HTTPS (OAuth callbacks, webhooks, preview demos) without opening firewall ports or managing TLS. Cloudflare Tunnel (`cloudflared`) solves this, but it is not yet installed or managed by the dotfiles, so each machine sets it up ad hoc. Adding it to the devops module makes it available, idempotently installed, and documented across all environments.

## What Changes

- Add `cloudflared` as a PATH-only tool in the `zsh/modules/devops/` module, following the existing 3-layer pattern (`config/` → `internal/` → `pkg/`).
- Provide an idempotent install path: download the official binary to `/usr/local/bin` (fallback to the Cloudflare apt repository).
- Provide thin helper functions for the most common tunnel operations (`login`, `create`, `route dns`, quick `tunnel --url`).
- Document usage and the local HTTPS-exposure use case in the module docs.

## Capabilities

### New Capabilities
- `cloudflared`: Managed PATH-only Cloudflare Tunnel tool — idempotent install plus helper functions for exposing local services over HTTPS.

### Modified Capabilities
<!-- none -->

## Impact

- New files under `zsh/modules/devops/`: `config/cloudflared.zsh`, `internal/cloudflared.zsh`, `pkg/cloudflared.zsh`, plus registration in the three `main.zsh` files and the `DEVOPS_TOOLS` array in `config/base.zsh`.
- New runtime dependency: the `cloudflared` binary (installed to `/usr/local/bin` or via apt).
- User config directory `~/.cloudflared/` is created/used by the tool itself; the module does not manage tunnel credentials.
