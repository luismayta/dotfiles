## Context

The `zsh/modules/devops/` module uses a 3-layer architecture: `config/<tool>.zsh` (registration/exports), `internal/<tool>.zsh` (logic/helpers), `pkg/<tool>.zsh` (install + availability check), each wired through its `main.zsh` and the `DEVOPS_TOOLS` array in `config/base.zsh`. `cloudflared` is a PATH-only CLI (no shell hooks), so it follows the `bruno` pattern, not the `atuin` shell-hook pattern. See proposal.md — Why for motivation.

## Goals / Non-Goals

**Goals:**
- Integrate `cloudflared` into the devops module using the existing 3-layer pattern.
- Idempotent, low-friction install (binary download preferred; apt as fallback).
- Thin, discoverable helper functions for the common tunnel operations.

**Non-Goals:**
- Managing named-tunnel lifecycle beyond create/route helpers (no auto-start daemons).
- Replacing the system package manager for systems that already provide `cloudflared` via apt.
- Storing or syncing tunnel credentials (those live in `~/.cloudflared/`, managed by the tool).

## Decisions

- **PATH-only pattern (bruno-style)**: `cloudflared` needs no shell hooks, so we only check availability with `core::exists` and add nothing to the shell environment beyond PATH. Rationale: matches the tool's design and the existing `bruno` reference; avoids the heavier `atuin` hook machinery.
- **Binary download to `/usr/local/bin`**: Direct download of the official `cloudflared-linux-amd64` release is the most portable and version-predictable path across the supported distros. Alternative considered: apt repo — kept as fallback because it requires adding Cloudflare's GPG key and source list, which is heavier and distro-specific.
- **Helpers as plain functions in `internal/cloudflared.zsh`**: Thin wrappers that call the binary with the right subcommand. Keeps the module's surface small and discoverable via `which`.
- **Config left to the tool**: `~/.cloudflared/` is created and owned by `cloudflared`; the module never writes there.

## Risks / Trade-offs

- **Binary integrity / supply chain** → Mitigation: download from the official Cloudflare release URL and verify the checksum/signature when feasible; document the expected version.
- **Version drift** → Mitigation: `cloudflared update` is the documented upgrade path; the install helper can be re-run to refresh.
- **Network dependency at install** → Mitigation: install is a one-time, explicit step; module load only checks availability, it does not fetch on every shell start.
