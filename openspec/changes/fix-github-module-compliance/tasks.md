## 1. Rename Files to Convention

- [ ] 1.1 Rename `config/gh.zsh` → `config/base.zsh` (add `ZSH_GITHUB_ENABLED` toggle)
- [ ] 1.2 Rename `internal/gh.zsh` → `internal/base.zsh` (fix `core::exists` usage, remove hardcoded gh-dash)
- [ ] 1.3 Rename `pkg/gh.zsh` → `pkg/base.zsh` (extract aliases to alias.zsh, keep install/upgrade/post_install/sync)

## 2. Create main.zsh Dispatch Files

- [ ] 2.1 Create `config/main.zsh` — source `config/base.zsh` + OS-specific config
- [ ] 2.2 Create `internal/main.zsh` — source `internal/base.zsh` + OS-specific internal + extensions
- [ ] 2.3 Create `pkg/main.zsh` — source `pkg/base.zsh`, `pkg/helper.zsh`, `pkg/alias.zsh` + OS-specific pkg

## 3. Create OS Placeholder Files

- [ ] 3.1 Create `config/osx.zsh` (2-line placeholder)
- [ ] 3.2 Create `config/linux.zsh` (2-line placeholder)
- [ ] 3.3 Create `internal/osx.zsh` (2-line placeholder)
- [ ] 3.4 Create `internal/linux.zsh` (2-line placeholder)
- [ ] 3.5 Create `pkg/osx.zsh` (2-line placeholder)
- [ ] 3.6 Create `pkg/linux.zsh` (2-line placeholder)

## 4. Fix plugin.zsh Entry Point

- [ ] 4.1 Update `plugin.zsh` guard to `[[ -n "${__ZSH_GITHUB_LOADED:-}" ]] && return`
- [ ] 4.2 Update `plugin.zsh` path to `${0:A:h}`
- [ ] 4.3 Add `message_info "Loading module: github"` to `plugin.zsh`
- [ ] 4.4 Move `ZSH_GITHUB_ENABLED` toggle to after config sourcing in `plugin.zsh`

## 5. Create pkg Helper and Alias Files

- [ ] 5.1 Create `pkg/helper.zsh` with `github::setup` orchestrator function
- [ ] 5.2 Create `pkg/alias.zsh` — move `ghd` alias and `editghdash` function from `pkg/gh.zsh`

## 6. Add Extension Management Pattern

- [ ] 6.1 Add `ZSH_GITHUB_EXTENSIONS=(dlvhdr/gh-dash)` to `config/base.zsh`
- [ ] 6.2 Create `internal/extension.zsh` with `github::internal::extension::install` and `github::internal::extensions::install`
- [ ] 6.3 Add public wrappers `github::extension::install` and `github::extensions::install` to `pkg/base.zsh`
- [ ] 6.4 Source `internal/extension.zsh` from `internal/main.zsh`
- [ ] 6.5 Remove hardcoded `dlvhdr/gh-dash` from `internal/base.zsh`

## 7. Verify Compliance

- [ ] 7.1 Verify zero `DEVOPS_GH_*` or `devops::gh::*` references remain
- [ ] 7.2 Verify all `main.zsh` files source correct layer files
- [ ] 7.3 Verify `plugin.zsh` guard and path conventions match `create-module.md`
- [ ] 7.4 Verify no hardcoded extension references in internal layer
