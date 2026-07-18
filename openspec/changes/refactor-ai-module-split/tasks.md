## 1. Create internal domain files

- [x] 1.1 Create `internal/opencode.zsh` with functions: `ai::internal::opencode::load`, `ai::internal::opencode::sync_quiet`, `ai::internal::opencode::install`, `ai::internal::opencode::sync`
- [x] 1.2 Create `internal/fabric.zsh` with functions: `ai::internal::fabric::install`, `ai::internal::fabric::patterns::sync`, `ai::internal::fabric::patterns::pull` (migrated from `internal/helper.zsh`)
- [x] 1.3 Create `internal/ollama.zsh` with functions: `ai::internal::ollama::models::list`, `ai::internal::ollama::models::pull`, `ai::internal::ollama::models::install` (migrated from `internal/helper.zsh`)
- [x] 1.4 Create `internal/skills.zsh` with functions: `ai::internal::skills::load`, `ai::internal::skills::install`, `ai::internal::skills::add`, `ai::internal::skills::use`, `ai::internal::skills::list`, `ai::internal::skills::update`, `ai::internal::skills::search`, `ai::internal::skills::publish`, `ai::internal::skills::_repo_var`, `ai::internal::skills::_install_repo`, `ai::internal::skills::setup`
- [x] 1.5 Create `internal/openspec.zsh` with functions: `ai::internal::openspec::load`, `ai::internal::openspec::install`, `ai::internal::openspec::upgrade`, `ai::internal::openspec::register_skill`, `ai::internal::openspec::init`, `ai::internal::openspec::update`, `ai::internal::openspec::setup`
- [x] 1.6 Create `internal/graphify.zsh` with functions: `ai::internal::graphify::install`, `ai::internal::graphify::upgrade`, `ai::internal::graphify::register_skill`, `ai::internal::graphify::setup`
- [x] 1.7 Create `internal/tools.zsh` with functions: all PATH loaders (`shimmy`, `openclaw`, `codegraph`, `rtk`, `hunk`, `pi`), simple tool installs (`shimmy`, `hf`, `openclaw`, `codegraph`, `tmuxai`, `rtk`, `hunk`, `pi`), config syncs (`rtk::config::sync`, `pi::config::sync`), and `ai::internal::packages::install`

## 2. Slim down internal/base.zsh

- [x] 2.1 Remove all functions from `internal/base.zsh` that have been migrated to domain files
- [x] 2.2 Verify `internal/base.zsh` contains only truly shared utilities (if any remain) and is under 50 lines

## 3. Update internal/main.zsh

- [x] 3.1 Update `internal/main.zsh` to source all new domain files in dependency order: `base.zsh`, `tools.zsh`, `opencode.zsh`, `fabric.zsh`, `ollama.zsh`, `skills.zsh`, `openspec.zsh`, `graphify.zsh`, `hunk.zsh`, OS dispatch

## 4. Remove internal/helper.zsh

- [x] 4.1 Delete `internal/helper.zsh` (its content has been migrated to `fabric.zsh` and `ollama.zsh`)

## 5. Create pkg domain files

- [x] 5.1 Create `pkg/opencode.zsh` with functions: `editopencode`, `ai::opencode::install`, `ai::opencode::sync`
- [x] 5.2 Create `pkg/fabric.zsh` with functions: `ai::fabric::install`, `ai::fabric::patterns::sync`, `ai::fabric::patterns::pull`
- [x] 5.3 Create `pkg/ollama.zsh` with functions: `ai::ollama::install`, `ai::ollama::models::list`, `ai::ollama::models::pull`, `ai::ollama::models::install`
- [x] 5.4 Create `pkg/skills.zsh` with functions: `ai::skills::install`, `ai::skills::add`, `ai::skills::use`, `ai::skills::list`, `ai::skills::update`, `ai::skills::search`, `ai::skills::publish`, `ai::skills::setup`
- [x] 5.5 Create `pkg/openspec.zsh` with functions: `ai::openspec::install`, `ai::openspec::upgrade`, `ai::openspec::init`, `ai::openspec::update`, `ai::openspec::setup`
- [x] 5.6 Create `pkg/graphify.zsh` with functions: `ai::graphify::install`, `ai::graphify::upgrade`, `ai::graphify::setup`
- [x] 5.7 Create `pkg/hunk.zsh` with functions: `ai::hunk::review`, `ai::hunk::show`, `ai::hunk::daemon::start`, `ai::hunk::config::sync`, `ai::hunk::install`
- [x] 5.8 Create `pkg/tools.zsh` with functions: `ai::shimmy::install`, `ai::hf::install`, `ai::openclaw::install`, `ai::codegraph::install`, `ai::tmuxai::install`, `ai::rtk::install`, `ai::pi::install`, `ai::pi::config::sync`, `ai::sync`

## 6. Update pkg/main.zsh

- [x] 6.1 Update `pkg/main.zsh` to source all new domain files in order: `base.zsh`, `opencode.zsh`, `fabric.zsh`, `ollama.zsh`, `skills.zsh`, `openspec.zsh`, `graphify.zsh`, `hunk.zsh`, `tools.zsh`, OS dispatch, `alias.zsh`

## 7. Remove pkg/helper.zsh

- [x] 7.1 Delete `pkg/helper.zsh` (its content has been migrated to domain files)

## 8. Verification

- [x] 8.1 Run `source zsh/core/main.zsh && source zsh/modules/ai/plugin.zsh` and verify no errors
- [x] 8.2 Verify guard prevents double-loading (source twice, message appears once)
- [x] 8.3 Verify all public functions exist: `type ai::install`, `type ai::setup`, `type ai::opencode::install`, `type ai::skills::setup`, etc.
- [x] 8.4 Run `grep -rn "ai::" zsh/modules/ai/internal/ zsh/modules/ai/pkg/` and verify no duplicated function names
- [x] 8.5 Verify no function was lost by comparing function count before and after
