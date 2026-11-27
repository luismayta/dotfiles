---
type: research
status: researched
source: web
captured_at: "2026-11-26T00:00:00Z"
tags:
  - orca
  - ade
  - coding-agents
  - worktrees
  - mcp
  - dotfiles
  - ai
---

# Orca ADE: Integration into the Dotfiles AI Ecosystem

## Hallazgos

### Hechos (verificados)

- Orca (stablyai/orca, MIT) is an Agent Development Environment: an Electron desktop app
  that runs multiple CLI coding agents in parallel, each in its own real `git worktree`.
  It bundles an `orca` CLI and a headless runtime (`orcad` / `orca serve`).
- It is not an AI model, not a Git replacement, and not a sandbox. It launches agents the
  user already owns (Claude Code, Codex, OpenCode, Cursor CLI, Gemini, Grok, others).
- Latest stable release verified: v1.4.278. Supported interfaces: CLI, Plugin Host API 1.10,
  Agent Skills, and MCP. No documented stable general-purpose REST API.
- Linux binary is `orca-ide` (GNOME Orca name collision); skills resolve `ORCA_CLI_COMMAND`
  first, then `orca-dev`, then `orca-ide`, then `orca`. Arch: `yay -S stably-orca-bin`;
  macOS: `brew install --cask stablyai/orca/orca`.
- Agents are launched with permission-bypass flags by default (`--dangerously-skip-permissions`,
  `--dangerously-bypass-approvals-and-sandbox`, or equivalent). Settings → Agents → Agent
  Permissions must be set to Manual/Ask before first use.
- Worktrees isolate files, not credentials, network, databases, cloud accounts, or ports.
- Jira has a native drawer, but no documented `orca jira` CLI subcommand. Agent-side Jira
  automation must use Jira MCP. `orca linear` does exist.
- Plugin manifests v2 (`orca-plugin.json`) with `contributes.mcpServers` are supported since
  1.4.276. Hooks are fail-open unless `onError: "deny"`; `agent.tool.before` blocks only
  Claude Code.
- Telemetry is pseudonymous (persistent install/session IDs, PostHog/US) unless disabled in
  Settings.
- Maturity: core desktop/worktrees released; bots, mobile, remote servers beta; plugins alpha;
  orchestration and cloud/VM environments experimental.
- Connector ingress (Slack, Linear, GitHub events) goes through Orca Cloud; the connector
  service is not in the public repository.

### Evidencia del codebase local

- `RESEARCH_ROOT` = `.codi/inbox/research` (`codi commit issue-key` returned empty, exit 0).
  No related active research; the only active file is unrelated (Neovim daily notes).
- `zsh/modules/ai/` uses strict three layers: `config/` (ZSH_AI_* vars), `internal/`
  (`ai::<tool>::internal::*`), `pkg/` (public `ai::<tool>::*`), `data/` (rsync templates).
  Registration in `internal/main.zsh` and `pkg/main.zsh`.
- Tool patterns: `archify` (simple install/setup), `rea` (MCP + multi-installer + Node gate),
  `mem0` (remote MCP disabled until API key).
- `ai::sync` in `zsh/modules/ai/pkg/base.zsh:22-31` is a hard-coded function list, not a
  dynamic registry. Adding a sync step requires editing it explicitly.
- MCP drift corrected: `zsh/modules/ai/config/opencode.zsh` and
  `zsh/modules/ai/data/opencode/opencode.jsonc` both define 28 servers with identical names.
  The real drift is live `~/.config/opencode/opencode.jsonc` (31 servers: unmanaged
  `codi-mcp`, `discord`, `penpot`).
- Modules are auto-discovered by glob in `zsh/zshrc:56-66`; no edit needed there. Root
  `Taskfile.yml` does need a `module-orca` entry.
- Guides and conventions: `docs/guides/create-module.md`,
  `docs/guides/implement-tool-in-module.md`, bats harness in
  `zsh/modules/notify/tests/{run.sh,test_helper.bash}`. English docs, no redundant comments.
  Commits only via goji-commit-smart; no automatic push/release.

### Inferencias

- Orca's strongest role in this ecosystem is a worktree/agent control plane around existing
  dotfiles, Jira MCP, GitHub and Codi skills — not a training scheduler, not production SRE
  observability, not a Jira automation CLI.
- A dedicated module is preferable to extending `zsh/modules/ai/` because Orca owns an
  independent desktop lifecycle, state dir, permission posture and plugin/MCP surface.

### Recomendaciones (architecture decision)

- Own Orca end-to-end in a new top-level `zsh/modules/orca/`; default `ZSH_ORCA_ENABLED=false`.
  Reject `apps/orca/ + ai/orca/` split (single-owner rule, duplicated package/PATH rules).
- Keep `zsh/modules/ai/` as owner of the MCP registry only, exposed as a data contract
  (`zsh/modules/ai/data/mcp/servers.jsonc`, canonical, secret-free). Orca reads data; it never
  calls `ai::internal::*`. Reuse only the public `ai::opencode::mcp::validate` for health checks.
- Generate the Orca plugin manifest with gomplate into a runtime-only `chmod 600` file under
  `ZSH_ORCA_STATE_DIR`; never copy the live opencode config (resolved secrets + three
  unmanaged servers) and never track manifests with secrets. Default MCP allowlist empty.
- Mandatory pre-pilot gate: disable telemetry in GUI and shell, set agent permissions to
  Manual, fail closed if `orca.yaml`/recipes/manifests contain bypass flags, disable bots,
  mobile, remote pairing, cloud environments and orchestration, minimize
  `worktree.sharedDirectories`, allowlist skills, use a scratch repo with a least-privilege
  token. Hooks are not a security boundary.
- Adoption phases: 0 evidence (verify version ≥1.4.276, `orca-ide` path, `{env:VAR}` semantics,
  reconcile 31-vs-28 drift, write ADR); 1 thin module (install/doctor/launch, no MCP);
  2 policy gate; 3 MCP bridge with one benign server; 4 separate changes/ADRs for parallel
  worktrees, multi-agent, Jira MCP, skills exposure. Promote the provisional ADR from
  `.codi/inbox/adr/` into `zsh/modules/orca/docs/adr/001-orca-ownership.md` once accepted.
- Anti-patterns: no auto-install at shell-source time, no auto-enable on install, no live-config
  copy, no wildcard MCP propagation, no `orca jira` wrapper, no cross-module `internal::` calls,
  no automatic update/push/release.

## Relación con el codebase

- New: `zsh/modules/orca/{plugin.zsh,config/,internal/,pkg/,data/orca/,tests/}`, `README.yaml`,
  generated `README.md`, `docs/adr/001-orca-ownership.md` (promoted).
- Existing: `Taskfile.yml` (`module-orca`), `zsh/modules/ai/data/mcp/servers.jsonc` (Phase 3),
  `zsh/modules/ai/config/opencode.zsh` and `data/opencode/opencode.jsonc` (reconcile drift),
  `.codi/inbox/research/`, `.codi/inbox/adr/`.
- No edit: `zsh/zshrc`, `zsh/modules/apps/`, `zsh/modules/ai/pkg/base.zsh`.
- Rollback: delete `zsh/modules/orca/` plus the `Taskfile.yml` entry; no other module depends on it.

## Fuentes

- Product/docs: https://orca.dev/ , https://orca.dev/docs , https://orca.dev/docs/install ,
  https://orca.dev/docs/model/worktrees , https://orca.dev/docs/agents/supported ,
  https://orca.dev/docs/cli/reference , https://orca.dev/docs/cli/orchestration ,
  https://orca.dev/docs/cli/automations , https://orca.dev/docs/cli/skills ,
  https://orca.dev/docs/review/jira , https://orca.dev/docs/remote-servers ,
  https://orca.dev/docs/telemetry , https://orca.dev/docs/bots/security
- Repo/specs: https://github.com/stablyai/orca , https://github.com/stablyai/orca/releases/tag/v1.4.278 ,
  https://github.com/stablyai/orca/blob/main/docs/reference/plugin-authoring.md ,
  https://github.com/stablyai/orca/blob/main/docs/reference/plugin-manifest.md ,
  https://github.com/stablyai/orca/blob/main/docs/reference/plugin-host-api.md ,
  https://github.com/stablyai/orca-plugins ,
  https://raw.githubusercontent.com/stablyai/orca/main/cloud/docs/relay-security-2026-10-21.md
- Local: `zsh/modules/ai/*`, `docs/guides/create-module.md`,
  `docs/guides/implement-tool-in-module.md`, `openspec/changes/add-mem0-mcp/*`, `zsh/zshrc`

## Conclusión

Orca is a strong fit as the agent/worktree control plane for this dotfiles-centric workflow,
provided the permission-bypass default is reversed before first use and MCP propagation stays
opt-in through a secret-free canonical registry. Ownership belongs in a dedicated, disabled-by-
default `zsh/modules/orca/` module; `zsh/modules/ai/` remains the MCP registry owner. It must not
be treated as a sandbox, a Jira automation CLI, a production orchestrator, or a fully self-hosted
replacement for Orca Cloud connectors. Phase 0 evidence gathering is a prerequisite, not an
assumption to encode in code.
