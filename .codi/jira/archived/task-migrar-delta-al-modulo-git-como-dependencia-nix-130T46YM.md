# Task: Migrar delta al módulo git como dependencia nix

## Issue Metadata

- projectKey: PE
- issueType: Task
- summary: Integrar delta como dependencia nix en el módulo git
- component: 
- labels: []
- parentEpic: 
- issueKey: PE-583
- jpdSource: NIP-23

## Scenario

## Plan de implementación

**Tarea A — Módulo git: delta como dependencia nix** *(KentBeck)*
1. `zsh/modules/git/config/base.zsh` → declarar `GIT_DELTA_NIX_PACKAGE="nixpkgs#delta"` (patrón de `devops/internal/linux.zsh:30-40`)
2. `zsh/modules/git/internal/delta.zsh` (nuevo) → `git::internal::delta::install` (`core::nix::exists` + `nix profile install nixpkgs#delta`) y `git::internal::delta::load` aplicando `core.pager = delta`, `interactive.diffFilter = delta --color-only`, `delta.navigate = true`, `merge.conflictStyle = zdiff3` (migrado del `rust::internal::delta::load` muerto)
3. `zsh/modules/git/internal/main.zsh` → source + invocación (junto al `core::ensure git/hub/rsync/scmpuff` existente)
4. `zsh/modules/git/data/sync/.gitconfig:13` → `pager = delta` (hoy dice `hunk pager`), dejando `hunk pager` como alternativa comentada — coherente con el OpenSpec Decision 5
5. `zsh/modules/git/README.yaml` → delta en `requirements`

**Tarea B — Módulo rust: quitar propiedad duplicada de delta** *(LinusTorvalds, paralela a A)*
1. `rust/config/base.zsh:18` → quitar `git-delta` del array cargo
2. `rust/internal/packages.zsh:3-6` → eliminar la función muerta `rust::internal::delta::load`
3. `rust/plugin.zsh:7` → limpiar comentario huérfano

**Pendiente:** el spec `openspec/specs/rust-module/spec.md:42-47` exige hoy la config delta en el módulo rust — quedará desactualizado y habría que sincronizarlo vía OpenSpec después (follow-up, no bloquea).


### Acceptance Tests

## Plan de implementación

**Tarea A — Módulo git: delta como dependencia nix** *(KentBeck)*
1. `zsh/modules/git/config/base.zsh` → declarar `GIT_DELTA_NIX_PACKAGE="nixpkgs#delta"` (patrón de `devops/internal/linux.zsh:30-40`)
2. `zsh/modules/git/internal/delta.zsh` (nuevo) → `git::internal::delta::install` (`core::nix::exists` + `nix profile install nixpkgs#delta`) y `git::internal::delta::load` aplicando `core.pager = delta`, `interactive.diffFilter = delta --color-only`, `delta.navigate = true`, `merge.conflictStyle = zdiff3` (migrado del `rust::internal::delta::load` muerto)
3. `zsh/modules/git/internal/main.zsh` → source + invocación (junto al `core::ensure git/hub/rsync/scmpuff` existente)
4. `zsh/modules/git/data/sync/.gitconfig:13` → `pager = delta` (hoy dice `hunk pager`), dejando `hunk pager` como alternativa comentada — coherente con el OpenSpec Decision 5
5. `zsh/modules/git/README.yaml` → delta en `requirements`

**Tarea B — Módulo rust: quitar propiedad duplicada de delta** *(LinusTorvalds, paralela a A)*
1. `rust/config/base.zsh:18` → quitar `git-delta` del array cargo
2. `rust/internal/packages.zsh:3-6` → eliminar la función muerta `rust::internal::delta::load`
3. `rust/plugin.zsh:7` → limpiar comentario huérfano

**Pendiente:** el spec `openspec/specs/rust-module/spec.md:42-47` exige hoy la config delta en el módulo rust — quedará desactualizado y habría que sincronizarlo vía OpenSpec después (follow-up, no bloquea).


### Sources

## Plan de implementación

**Tarea A — Módulo git: delta como dependencia nix** *(KentBeck)*
1. `zsh/modules/git/config/base.zsh` → declarar `GIT_DELTA_NIX_PACKAGE="nixpkgs#delta"` (patrón de `devops/internal/linux.zsh:30-40`)
2. `zsh/modules/git/internal/delta.zsh` (nuevo) → `git::internal::delta::install` (`core::nix::exists` + `nix profile install nixpkgs#delta`) y `git::internal::delta::load` aplicando `core.pager = delta`, `interactive.diffFilter = delta --color-only`, `delta.navigate = true`, `merge.conflictStyle = zdiff3` (migrado del `rust::internal::delta::load` muerto)
3. `zsh/modules/git/internal/main.zsh` → source + invocación (junto al `core::ensure git/hub/rsync/scmpuff` existente)
4. `zsh/modules/git/data/sync/.gitconfig:13` → `pager = delta` (hoy dice `hunk pager`), dejando `hunk pager` como alternativa comentada — coherente con el OpenSpec Decision 5
5. `zsh/modules/git/README.yaml` → delta en `requirements`

**Tarea B — Módulo rust: quitar propiedad duplicada de delta** *(LinusTorvalds, paralela a A)*
1. `rust/config/base.zsh:18` → quitar `git-delta` del array cargo
2. `rust/internal/packages.zsh:3-6` → eliminar la función muerta `rust::internal::delta::load`
3. `rust/plugin.zsh:7` → limpiar comentario huérfano

**Pendiente:** el spec `openspec/specs/rust-module/spec.md:42-47` exige hoy la config delta en el módulo rust — quedará desactualizado y habría que sincronizarlo vía OpenSpec después (follow-up, no bloquea).

- https://github.com/luismayta/dotfiles.git