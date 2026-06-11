## 1. Scaffold

- [x] 1.1 Create `zsh/modules/ai/` directory structure (config/, internal/, pkg/, data/)
- [x] 1.2 Create `plugin.zsh` entry point with idempotency guard, `AI_PATH`, and chain to config → internal → pkg
- [x] 1.3 Add auto-install guards for rsync, fzf, and AI tools at end of plugin.zsh

## 2. Config Layer

- [x] 2.1 Create `config/base.zsh` — export all variables: `ARCH_NAME`, `AI_PACKAGE_NAME`, opencode paths, fabric paths, ollama paths, shimmy/openclaw bin paths, all install URLs, `AI_TOOLS` array, `AI_OLLAMA_MODELS` array
- [x] 2.2 Create `config/main.zsh` — source base.zsh + OS dispatch to linux.zsh/osx.zsh
- [x] 2.3 Create `config/linux.zsh` — `AI_ARCHITECTURE_NAME`, linux-specific shimmy URL
- [x] 2.4 Create `config/osx.zsh` — `AI_APPLICATION_PATH`, `AI_ARCHITECTURE_NAME`, osx-specific shimmy URL

## 3. Internal Layer

- [x] 3.1 Create `internal/base.zsh` — `ai::internal::opencode::load`, `ai::internal::opencode::sync_quiet`, `ai::internal::shimmy::load`, `ai::internal::openclaw::load`, `ai::internal::packages::install`, and all 7 tool install functions (opencode, fabric, ollama, shimmy, hf, openclaw, tmuxai)
- [x] 3.2 Create `internal/helper.zsh` — `ai::internal::fabric::patterns::sync`, `ai::internal::fabric::patterns::pull`, `ai::internal::ollama::models::list`, `ai::internal::ollama::models::pull`, `ai::internal::ollama::models::install`
- [x] 3.3 Create `internal/main.zsh` — source base.zsh + OS dispatch + helper.zsh, call opencode::load and shimmy::load
- [x] 3.4 Create `internal/linux.zsh` — empty placeholder
- [x] 3.5 Create `internal/osx.zsh` — empty placeholder

## 4. Public API Layer (pkg/)

- [x] 4.1 Create `pkg/base.zsh` — `ai::install`, `ai::post_install`, `ai::upgrade`, `ai::packages::install`
- [x] 4.2 Create `pkg/helper.zsh` — `editopencode`, `ai::opencode::install`, `ai::opencode::sync`, `ai::fabric::install`, `ai::fabric::patterns::sync`, `ai::fabric::patterns::pull`, `ai::ollama::install`, `ai::ollama::models::list/pull/install`, `ai::shimmy::install`, `ai::hf::install`, `ai::openclaw::install`, `ai::tmuxai::install`
- [x] 4.3 Create `pkg/alias.zsh` — empty placeholder (original had no aliases)
- [x] 4.4 Create `pkg/main.zsh` — source base.zsh + OS dispatch + helper.zsh + alias.zsh
- [x] 4.5 Create `pkg/linux.zsh` — empty placeholder
- [x] 4.6 Create `pkg/osx.zsh` — empty placeholder

## 5. Data

- [x] 5.1 Copy opencode config data from `zsh-ai/data/opencode/` to `zsh/modules/ai/data/opencode/`
- [x] 5.2 Copy fabric patterns from `zsh-ai/data/patterns/` to `zsh/modules/ai/data/patterns/`

## 6. Verification

- [x] 6.1 Verify all files exist: `ls -la zsh/modules/ai/**/*.zsh`
- [x] 6.2 Verify plugin.zsh loads without errors (zsh -n syntax check)
- [x] 6.3 Verify public API functions match original: `ai::install`, `ai::opencode::*`, `ai::fabric::*`, `ai::ollama::*`, `ai::shimmy::install`, `ai::hf::install`, `ai::openclaw::install`, `ai::tmuxai::install`, `editopencode`