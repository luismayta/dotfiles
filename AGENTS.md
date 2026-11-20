# Agent Guide

<!-- BEGIN:agents-md-generator -->
## 🧭 Navigation (CodeGraph-driven)
### Guides

- [Create Module](docs/guides/create-module.md)
- [Implement Module Update](docs/guides/implement-module-update.md)
- [Implement Tool in Module](docs/guides/implement-tool-in-module.md)
- [GitHub Flow](docs/contribute/github-flow.md)

### Usage

- [Usage](docs/usage.md)
- [Commands](docs/commands.md)
- [Functions](docs/functions.md)
- [Environment Variables](docs/env-vars.md)
- [Testing](docs/testing.md)
- [Troubleshooting](docs/troubleshooting.md)
- [FAQ](docs/faq.md)
- [Modules](zsh/modules/README.md)
- [Git Module Usage](zsh/modules/git/docs/usage.md)
- [Hyprland Keybindings Reference](zsh/modules/hyprland/docs/KEYBINDINGS.md)
- [OpenCode MCP Lifecycle](zsh/modules/ai/docs/opencode-mcp.md)
- [freellmapi](zsh/modules/ai/docs/freellmapi.md)
- [hrd::project — Functional Specification](zsh/modules/herdr/herdr-project.md)
- [alacritty](zsh/modules/alacritty/README.md)
- [aliases](zsh/modules/aliases/README.md)
- [apps](zsh/modules/apps/README.md)
- [bitwarden](zsh/modules/bitwarden/README.md)
- [clean](zsh/modules/clean/README.md)
- [devbox](zsh/modules/devbox/README.md)
- [devops](zsh/modules/devops/README.md)
- [docker](zsh/modules/docker/README.md)
- [ghq](zsh/modules/ghq/README.md)
- [github](zsh/modules/github/README.md)
- [git](zsh/modules/git/README.md)
- [ghostty](zsh/modules/ghostty/README.md)
- [hammerspoon](zsh/modules/hammerspoon/README.md)
- [helix](zsh/modules/helix/README.md)
- [herdr](zsh/modules/herdr/README.md)
- [hyprland](zsh/modules/hyprland/README.md)
- [issues](zsh/modules/issues/README.md)
- [keybase](zsh/modules/keybase/README.md)
- [mobile](zsh/modules/mobile/README.md)
- [mpd](zsh/modules/mpd/README.md)
- [nodejs](zsh/modules/nodejs/README.md)
- [notify](zsh/modules/notify/README.md)
- [nvim](zsh/modules/nvim/README.md)
- [osx](zsh/modules/osx/README.md)
- [pazi](zsh/modules/pazi/README.md)
- [python](zsh/modules/python/README.md)
- [resources](zsh/modules/resources/README.md)
- [rust](zsh/modules/rust/README.md)
- [rvm](zsh/modules/rvm/README.md)
- [smolvm](zsh/modules/smolvm/README.md)
- [ssh](zsh/modules/ssh/README.md)
- [starship](zsh/modules/starship/README.md)
- [templates](zsh/modules/templates/README.md)
- [tmux](zsh/modules/tmux/README.md)
- [waybar](zsh/modules/waybar/README.md)
- [wezterm](zsh/modules/wezterm/README.md)
- [yazi](zsh/modules/yazi/README.md)
- [zed](zsh/modules/zed/README.md)
- [ai](zsh/modules/ai/README.md)
- [Helix Themes](zsh/modules/helix/data/themes/README.md)
- [notify-send data](zsh/modules/notify/data/notify-send/README.md)
- [noti data](zsh/modules/notify/data/noti/README.md)
- [nix](zsh/system/nix/README.md)
- [nix-darwin](zsh/system/nix-darwin/README.md)

### Reference

- [Documentation Index](docs/index.md)
- [Contributing](docs/contributing.md)
- [Code of Conduct](docs/code_of_conduct.md)
- [Authors](docs/authors.md)
- [Components](docs/components.md)
- [Support](docs/support.md)
- [Releasing](docs/releasing.md)
- [Disclaimer](docs/disclaimer.md)
- [Common Examples](docs/examples/common.md)
- [Installation via Curl](docs/include/installation/curl.md)
- [Installation via Wget](docs/include/installation/wget.md)
- [Commands Reference](zsh/modules/git/docs/include/commands.md)
- [README Template](provision/templates/README.tpl.md)
- [Module README Template](provision/templates/README.module.tpl.md)
- [Security Policy](SECURITY.md)
- [Changelog](CHANGELOG.md)


## 📋 Agent Rules

- Do NOT duplicate configuration rules
- Always use source-of-truth files
- Run all commits only through the `goji-commit-smart` skill.
- Ask before executing ambiguous tasks.
- Before executing a task, check the Navigation guide list for an applicable guide and follow it; when no guide exists, recommend creating one before proceeding.

- All diagrams use Mermaid syntax in ```mermaid fenced blocks of Markdown.
- The agent selects the diagram type according to content (flowchart, sequence, class, state, ER).
- ASCII diagrams and alternative formats are forbidden unless explicitly requested or Mermaid is insufficient.
- This rule applies to all documentation: architecture docs, ADRs, guides, research, reports, and generated artifacts.

## 💬 Code Comments

Default to no explanatory comments. Prefer self-documenting code.
Allow comments required by tools, compilers, linters, frameworks, or infrastructure directives (e.g. `tfsec:ignore`, `eslint-disable`, `@ts-ignore`, `noqa`). Keep them scoped, justified, and as specific as possible.
Add explanatory comments only for non-obvious business rules, constraints, security considerations, invariants, or decisions that prevent incorrect changes.
Avoid redundant explanations, visual separators, Jira references, change history, and agent-related context.
When modifying code, update or remove obsolete comments within the affected scope. Preserve valid directives and meaningful comments. Avoid unrelated cleanup.
Follow project conventions for public API documentation.

## 📁 Artifact Placement

- Resolve the current Jira issue key with `codi commit issue-key`.
- When an issue key exists (e.g. `PE-548`), create reports and other issue artifacts under `.codi/jira/<ISSUE-KEY>/`, inside the subfolder matching the artifact type: `adr/`, `reports/`, `requirements/`, `research/`.
- When `codi commit issue-key` returns no value, use `.codi/inbox/<subfolder>` with the same subfolder names (e.g. `.codi/inbox/adr`, `.codi/inbox/reports`, `.codi/inbox/research`).
- Create missing folders on demand.

### 📄 ADR Placement

- Transversal/project-wide decisions → `docs/adr/` at repo root (existing 001–004 live here; never migrated — their OKF ids embed the path).
- Module-scoped decisions → `<module>/docs/adr/` (each module has one; created 2026-11).
- Sequence numbers are local per directory (001 may exist in multiple dirs); OKF `id` is unique repo-wide (path+hash) — dedupe by id, never by number alone.
- One decision per document; follow the `adr` skill (`skills/adr/`) for template, lifecycle and validation.
- Issue-scoped ADRs (`.codi/jira/<KEY>/adr/`) and inbox ADRs (`.codi/inbox/adr/`) are provisional: when the task completes, classify and PROMOTE them (move) into the target module's `docs/adr/` per the `adr` skill's Promote procedure; the issue/inbox copy does not remain.

## 🛡️ Guard Rails

- Source code SHALL be written in English.
- Documentation SHALL be written in English.
- Releases, publish, and tags are manual; never run them automatically.
- All `git push` is manual.
- `terraform` and `terragrunt` plan, diff, fmt, and validate are allowed; apply, destroy, and state writes stay manual.
- Never run destructive git history operations: amend, `reset --hard`, rebase on a shared branch, `clean -fd`, `checkout -- <file>`, or `--no-verify`.
- Never commit or print secrets.
- New dependencies and any change under `.github/workflows` or `turbo.json` require prior approval.
- Schema changes and destructive queries are executed manually.

<!-- Generated by agents-md-generator at 2026-10-31T02:49:12Z -->
<!-- END:agents-md-generator -->
