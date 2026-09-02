## Why

The AI module currently manages 14 tools but lacks architecture visualization capability. Archify generates interactive HTML diagrams from typed JSON, enabling teams to document systems, review architectural changes in PRs, and create shareable visual assets. Integrating it as a skill aligns with the existing tool management pattern and fills a gap in our AI toolkit for architectural communication.

## What Changes

- Add Archify as a new managed tool in the AI module
- Create `config/archify.zsh` with tool variables (`ZSH_AI_ARCHIFY_*`)
- Create `internal/archify.zsh` with load/install/setup functions
- Create `pkg/archify.zsh` with public API (`ai::archify::*`)
- Register Archify in `ZSH_AI_TOOLS` registry (`config/base.zsh`)
- Add Archify repo to skills list (`config/skills.zsh`)
- Add shell aliases for convenience commands

## Capabilities

### New Capabilities

- `archify-integration`: Install, configure, and expose Archify architecture diagram generator as an AI module tool with CLI wrappers and skill registration

### Modified Capabilities

_(none — this is additive only)_

## Impact

- **Files created**: `config/archify.zsh`, `internal/archify.zsh`, `pkg/archify.zsh`
- **Files modified**: `config/base.zsh` (registry), `config/skills.zsh` (repo list), `pkg/alias.zsh` (aliases)
- **Dependencies**: Node.js >= 18, `bunx` (already present)
- **Downstream**: `ai::install` batch installer will include Archify; `ai::skills::setup` will install the skill globally
