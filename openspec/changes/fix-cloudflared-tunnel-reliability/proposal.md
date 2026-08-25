## Why

The `devops::cloudflared::internal::tunnel::create` function in `zsh/modules/devops/internal/cloudflared.zsh` has five reliability issues that cause silent failures, stale configurations, and deprecated usage. These need fixing now because the function is the primary entry point for provisioning Cloudflare tunnels in this dotfiles setup, and the current fragility leads to manual debugging and config drift.

## What Changes

- Replace fragile `tail | awk` UUID parsing with `cloudflared tunnel list --format json` for reliable extraction
- Update config file (config.yml) when hostname or port changes on re-run, not just when the file is missing
- Replace deprecated `url:` directive with modern `ingress:` format for no-hostname configurations
- Add idempotent DNS routing that checks if already routed before calling `cloudflared tunnel route dns`
- Add port availability verification (via `nc` or `ss`) before tunnel creation

## Capabilities

### New Capabilities

- `cloudflared-tunnel`: Covers the cloudflared tunnel lifecycle — creation, UUID resolution, config generation, DNS routing, and pre-flight validation

### Modified Capabilities

- `devops`: The cloudflared module is part of the devops module; however, the spec-level behavior changes are captured in the new `cloudflared-tunnel` capability. No delta spec needed for `devops` itself.

## Impact

- **Code:** `zsh/modules/devops/internal/cloudflared.zsh` (primary), `zsh/modules/devops/pkg/cloudflared.zsh` (public API — no changes expected), `zsh/modules/devops/config/cloudflared.zsh` (no changes expected)
- **Dependencies:** Requires `jq` for JSON parsing of `cloudflared tunnel list --format json` output; requires `nc` or `ss` for port check
- **Backward compatibility:** Existing tunnel configurations must continue to work — changes are additive/improvement, not breaking
