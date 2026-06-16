## 1. Fix Bugs

- [x] 1.1 Remove invalid `dangling=true` filter on `docker ps` in `container::stop::all` (only valid for images/volumes)
- [x] 1.2 Remove non-existent `network::dangling` function (not a valid Docker concept)
- [x] 1.3 Fix `container::delete::dangling` to actually delete containers (currently only stops them)

## 2. Remove Placeholder Files

- [x] 2.1 Delete placeholder files in `config/` directory (empty stub functions)
- [x] 2.2 Delete placeholder files in `internal/` directory (empty stub functions)
- [x] 2.3 Delete placeholder files in `pkg/` directory (empty stub functions)

## 3. Remove Dead Code

- [x] 3.1 Remove `container::core` function definitions from all 4 config files (defined but never invoked)

## 4. Unify Namespaces

- [x] 4.1 Rename `container::internal::container::install` → `docker::internal::container::install` in all provider files
- [x] 4.2 Rename `container::internal::container::load` → `docker::internal::container::load` in all provider files
- [x] 4.3 Update `internal/main.zsh` dispatch to call the new `docker::internal::container::*` names

## 5. Eliminate Duplicates and Redundancy

- [x] 5.1 Remove duplicate install/load call from `pkg/base.zsh` (lines 86-87) — already runs in `internal/main.zsh`
- [x] 5.2 Merge `process::stop::all` and `container::stop::all` — remove `process::stop::all` variant
- [x] 5.3 Merge duplicate colima/lima/podman install logic into a single shared function

## 6. Fix Naming

- [x] 6.1 Rename `clean::process::dangling` → `clean::process::exited` across all files
- [x] 6.2 Fix `process::list` to use `docker ps` (without `-l` flag) for listing containers
