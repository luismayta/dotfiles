# Task: Implement Bitwarden CLI Binary Installation

## Issue Metadata

- projectKey: HAD
- issueType: Task
- summary: Implement Bitwarden CLI installation via native binary download in devops module
- component: DevOps
- labels: [bitwarden, security, cli, devops]
- parentEpic:
- issueKey: HAD-103
- jpdSource:

## Scenario

The Bitwarden CLI npm package (`@bitwarden/cli`) was hijacked in version 2026.4.0 with a malicious payload that uses Bun to steal credentials. To ensure security, we need to implement installation via native binary download instead of npm/bun. This follows the established three-layer architecture pattern (config/internal/pkg) as documented in `docs/guides/implement-tool-in-module.md`.

The binary installation method is the recommended approach by Bitwarden for production environments and avoids the security risks associated with npm package management.

### Acceptance Tests

1. Create `config/bitwarden.zsh` with `DEVOPS_BITWARDEN_*` variables including download URL and binary path
2. Create `internal/bitwarden.zsh` with functions:
   - `devops::bitwarden::internal::load` - Add binary to PATH
   - `devops::bitwarden::internal::install` - Download and install binary from official URL
   - `devops::bitwarden::internal::upgrade` - Check for updates and reinstall
   - `devops::bitwarden::internal::main::factory` - Auto-install if missing
3. Create `pkg/bitwarden.zsh` with public API wrappers
4. Register in `DEVOPS_TOOLS` array in `config/base.zsh`
5. Add source lines to `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh`
6. Follow cross-platform pattern (macOS/Linux) with architecture detection (arm64/amd64)
7. Use `message_info`/`message_success`/`message_error` for user feedback
8. Include `core::exists` guard in load function

### Sources

- https://bitwarden.com/help/cli/#download-and-install
- https://github.com/bitwarden/clients/blob/main/apps/cli/README.md
- docs/guides/implement-tool-in-module.md
- Security advisory: JFrog Research - TeamPCP Campaign (npm package hijack)

- https://github.com/CodipLab/codip-ai.git