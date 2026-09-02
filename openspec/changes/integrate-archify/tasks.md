## 1. Config Layer

- [x] 1.1 Create `config/archify.zsh` with `ZSH_AI_ARCHIFY_BIN`, `ZSH_AI_ARCHIFY_INSTALL_URL`, `ZSH_AI_ARCHIFY_SKILL_REPO` variables
- [x] 1.2 Add `"archify"` to `ZSH_AI_TOOLS` array in `config/base.zsh`

## 2. Internal Layer

- [x] 2.1 Create `internal/archify.zsh` with `ai::internal::archify::load` (add bin to PATH)
- [x] 2.2 Implement `ai::internal::archify::install` (idempotent, uses `bunx skills add tt-a1i/archify -g`)
- [x] 2.3 Implement `ai::internal::archify::setup` (runs `archify doctor`)

## 3. Pkg Layer

- [x] 3.1 Create `pkg/archify.zsh` with public API functions
- [x] 3.2 Implement `ai::archify::install` (delegates to internal)
- [x] 3.3 Implement `ai::archify::doctor` (runs `archify doctor`)
- [x] 3.4 Implement `ai::archify::render`, `ai::archify::validate`, `ai::archify::deliver` (thin wrappers)
- [x] 3.5 Source `pkg/archify.zsh` from `pkg/main.zsh`

## 4. Skills Integration

- [x] 4.1 Add `tt-a1i/archify` to skills repo list in `config/skills.zsh`

## 5. Aliases

- [x] 5.1 Add `archify-render`, `archify-validate`, `archify-deliver`, `archify-doctor` aliases to `pkg/alias.zsh`

## 6. Validation

- [ ] 6.1 Run `ai::archify::install` and verify `archify --version` returns version
- [ ] 6.2 Run `archify doctor` and verify health check passes
- [ ] 6.3 Run `archify demo /tmp/archify-test` and verify HTML output is generated
