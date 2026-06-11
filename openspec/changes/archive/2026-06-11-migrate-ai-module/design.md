## Context

The `zsh-ai` module from `hadenlabs/zsh-ai` needs to be migrated into the dotfiles monorepo at `zsh/modules/ai/`, following the same layered architecture used by `tmux` and `hyprland`: `plugin.zsh` → `config/` → `internal/` → `pkg/`.

The source module manages 7 AI developer tools (opencode, fabric, ollama, shimmy, hf, openclaw, tmuxai) with install, config sync, and helper functions. The dotfiles already have `core::install` / `core::exists` shared utilities for cross-distro package management, and modules auto-load via `modules/*/plugin.zsh` glob in zshrc.

The original module has a `core/` layer that is effectively empty (4 files, 2 lines each with just shebang). This will be omitted in the migration — no empty files.

## Goals / Non-Goals

**Goals:**
- Port all functionality from `zsh-ai` into `zsh/modules/ai/` with zero feature loss
- Match the module structure established by tmux/hyprland: `plugin.zsh` → `config/` → `internal/` → `pkg/`
- Maintain the same public API surface (`ai::*` functions) for backwards compatibility
- Sync fabric patterns directory (~253 directories) into dotfiles data directory
- Support both macOS and Linux (OS dispatch in each layer)
- Auto-load via existing zshrc module glob (no zshrc changes)

**Non-Goals:**
- Refactoring the AI tool installers themselves (pure migration)
- Adding new AI tools beyond the 7 already managed
- Updating fabric patterns content or opencode configs
- Creating new specs under `openspec/specs/` (change-local specs only)
- Modifying any existing modules or configuration

## Decisions

### Omit the `core/` layer (empty files)
The original has `core/base.zsh`, `core/linux.zsh`, `core/osx.zsh` — all empty (just shebang). The `core/main.zsh` sources them via a factory pattern then exits. This layer provides no actual functionality. **Decision**: Omit it entirely. The `plugin.zsh` chain goes `config/` → `internal/` → `pkg/` like all other modules.

### Use `AI_PATH` for module root (follow convention)
The original uses `ZSH_AI_PATH`; the dotfiles modules use bare module name (e.g., `TMUX_PATH`, `HYPRLAND_PATH`). **Decision**: Use `AI_PATH` matching the dotfiles convention.

### Keep `osx.zsh` and `linux.zsh` as no-ops in pkg/
The original has empty `pkg/osx.zsh` and `pkg/linux.zsh`. The dotfiles tmux module also has them as placeholders for potential OS-specific commands. **Decision**: Keep them as empty no-ops for consistency and future expansion.

### Data sync: rsync under `HOME_CONFIG_PATH`
The original syncs opencode configs to `~/.config/opencode/` and fabric patterns to `~/.config/fabric/patterns/`. **Decision**: Use `HOME_CONFIG_PATH` (from shared config layer) as the target base, matching the hyprland sync pattern.

### No AI_PACKAGES split needed in install
The original has `AI_TOOLS` and `AI_PACKAGES` as separate arrays (identical content). **Decision**: Use only `AI_TOOLS` in the migration.

## Risks / Trade-offs

- **Data directory size**: ~253 fabric pattern directories will be added. These are small text files but add to git clone size. Mitigation: This is the same data users would download anyway via `fabric --updatepatterns`.
- **Install URL breakage**: External install URLs (opencode.ai, ollama.com, etc.) could change. Mitigation: URLs are centralized in `config/base.zsh`, easy to update.
- **Ollama model names**: Default models specified (deepseek-coder:6.7b, qwen2.5-coder:7b, codellama:13) may become outdated. Mitigation: Users can override via `AI_OLLAMA_MODELS` env var.