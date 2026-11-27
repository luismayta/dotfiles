# Task: Revisar módulos zsh a archivar o desactivar bajo nix y mise

## Issue Metadata

- projectKey: PE
- issueType: Task
- summary: Revisar y desactivar módulos zsh redundantes con nix y mise
- component: DevOps
- labels: [improvement, devops]
- parentEpic: 
- issueKey: PE-699
- jpdSource: NIP-23

## Scenario

El ecosistema de dotfiles ahora usa nix y mise como fuente de verdad para toolchains y
versiones de proyectos. Los 40 módulos bajo `zsh/modules/` se sourcean automáticamente por
glob en `zsh/zshrc:56-66`, por lo que varios gestores de versiones y módulos GUI se cargan
en cada shell aunque no aporten valor y puedan duplicar hooks/PATH (p. ej. `mise activate zsh`
en `zsh/zshrc:121` y `zsh/modules/devops/internal/mise.zsh:10`). Se necesita una política de
ciclo de vida para clasificar cada módulo como ARCHIVE, DISABLE o KEEP, reutilizando los
mecanismos existentes `ZSH_DISABLED_MODULES` y `ZSH_<MODULE>_ENABLED`, sin romper helpers
compartidos (`git`, `devops::direnv::install`, `goenv::internal::package::install`,
`osx::ensure_clipboard`) y con reversibilidad por shell nuevo. La decisión debe documentarse
en un ADR transversal.


### Acceptance Tests

1. An ADR contains a decision matrix classifying all 40 modules under `zsh/modules/` as ARCHIVE, DISABLE, or KEEP, each with a one-line rationale and the C1–C6 criteria applied.
2. No new module-exclusion branch or central blacklist is added to `zsh/zshrc`; every DISABLE uses the existing `ZSH_DISABLED_MODULES` or `ZSH_<MODULE>_ENABLED` mechanism.
3. For every module marked ARCHIVE, `grep -r "<module>::" zsh/modules zsh/system` returns zero matches outside that module's directory.
4. The shared-helper smoke test passes: `git::get_module_path`, `devops::direnv::install`, `goenv::internal::package::install`, and `osx::ensure_clipboard` are defined after a fresh shell startup.
5. Exactly one effective `mise activate zsh` remains across `zsh/zshrc` and `zsh/modules/devops/`; the duplicate is removed or explicitly guarded.
6. In a directory with `mise.toml`, `node`, `go`, `python`, and `rust` resolve to mise- or nix-provided binaries after startup, and `PATH`/`FPATH` contain no duplicate entries.
7. Startup is measured with `ZSH_DEBUG=1` (`zprof`) before and after on Linux and macOS hosts; no regression greater than 10%, and the top-10 entries are attached to the task.
8. Each changed default has a bats test asserting that the disabled module's `__ZSH_<MODULE>_LOADED` is unset and its public functions are undefined, while the enabled case defines them.
9. Reversibility is verified in a fresh shell: `ZSH_DISABLED_MODULES=""` or `export ZSH_<MODULE>_ENABLED=true` in `$CUSTOMRC` restores the module without code changes.
10. Platform-scoped disables live only in `config/osx.zsh` or `config/linux.zsh` with a `:-true` base default; host-scoped disables live only in `$CUSTOMRC`.
11. Genuine dependency failures still emit `message_warning`/`message_error`; no diagnostic output is suppressed to hide a disabled module's missing helper.
12. `README`/`.customrc.example`/`docs/env-vars.md` and the affected openspec spec are updated, and the limitation that `$CUSTOMRC` is sourced after the `zsh/system/*` loop is documented.
13. ARCHIVE removals are delivered in a dedicated change separate from DISABLE changes, with git history referenced and no automatic push.


### Sources

- `zsh/zshrc:26-40,44-45,52-66,107-118`
- `zsh/modules/README.md:31-75`
- `.customrc.example:9-13`
- `openspec/changes/archive/2026-06-10-module-disable/specs/module-disable/spec.md`
- `openspec/specs/zshrc-load/spec.md:51-61`
- `openspec/specs/devops-mise/spec.md`
- `openspec/changes/make-fnm-yield-to-mise/*`
- `zsh/modules/notify/tests/hooks.bats:192,212`
- `docs/guides/create-module.md`, `docs/guides/implement-tool-in-module.md`

- https://github.com/luismayta/dotfiles.git
