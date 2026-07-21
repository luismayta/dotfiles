## Why

Bruno is a modern, open-source API client (alternative to Postman/Insomnia) that stores collections directly in your filesystem as plain text files. We need to add it to the devops module to automate its CLI installation via npm.

## What Changes

- Add Bruno configuration to `zsh/modules/devops/config/bruno.zsh`
- Add Bruno internal functions to `zsh/modules/devops/internal/bruno.zsh`
- Update `config/main.zsh` and `internal/main.zsh` to source the new files
- Install Bruno CLI via npm (`@usebruno/cli`) if not present

## Capabilities

### New Capabilities

- `bruno-cli`: Bruno CLI installation and management via npm

### Modified Capabilities

None — this is a new tool added to the existing devops module.

## Impact

- New files: `config/bruno.zsh`, `internal/bruno.zsh`
- Modified files: `config/main.zsh`, `internal/main.zsh`
- Dependency: Node.js module must be loaded first (for npm)
- Package manager dependency: npm for CLI installation
