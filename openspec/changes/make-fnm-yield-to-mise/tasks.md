# Tasks

## 1. Guard fnm activation (zsh/modules/nodejs/internal/base.zsh)

- [ ] 1.1 Add `nodejs::internal::mise::manages_dir`: walk from `$PWD` upward checking each directory for `mise.toml`, `.mise.toml`, or `.tool-versions`, stopping at the first match, at `$HOME`, or at `/` — POSIX `[ -f ]` tests and `${dir%/*}` only (bash 3.2 portable, docs/contributing.md:81-95) — verify: returns true inside a directory containing `mise.toml`, true from a nested subdirectory of that repository, false in a directory without any of the three files.
- [ ] 1.2 In `nodejs::internal::fnm::load` (`base.zsh:11-17`): keep the `FNM_PATH` prepend (fnm binary, never shadows `node`), but when `manages_dir` is true for `$PWD` skip the `eval "$(fnm env)"` / `eval "$(fnm env --use-on-cd --shell zsh)"` PATH prepend so startup inside a mise-managed directory never puts fnm ahead of mise — verify: `zsh -n zsh/modules/nodejs/internal/base.zsh` passes; starting a shell inside the mise-managed repository leaves `command -v node` resolving under `$HOME/.local/share/mise`, not `fnm_multishells`.
- [ ] 1.3 Replace `_fnm_autoload_hook` in `chpwd_functions` with a guarded wrapper (`nodejs::internal::fnm::autoload`) that re-checks `manages_dir` on every `cd`: in a mise-managed directory it returns without re-prepending the fnm multishell; otherwise it delegates to fnm's original autoload (lazily running the `fnm env` eval if load-time activation was skipped) — verify: `cd` into the mise-managed repository keeps mise entries ahead of `fnm_multishells` in `which -a node`; `cd` back to a non-mise directory restores fnm switching.

## 2. Remove or guard duplicate inline fnm block (~/.zshrc — manual, untracked)

- [x] 2.1 Remove or guard the duplicate fnm block at `~/.zshrc:121-127` — exact lines: `121 # fnm`, `122 FNM_PATH="/home/lucho/.local/share/fnm"`, `123 if [ -d "$FNM_PATH" ]; then`, `124 export PATH="$FNM_PATH:$PATH"`, `125 eval "$(fnm env --shell zsh)"`, `126 fi`, `127` (blank line). The block re-runs `fnm env` a second time after module load and re-establishes fnm-first PATH even with the task 1 guard — verify: `grep -n "fnm env" ~/.zshrc` no longer matches the inline block (or the block is wrapped in the `manages_dir` guard). NOTE: `~/.zshrc` is a regular file, NOT a symlink, NOT in this repository — manual, non-versioned step.

## 3. Align node version pins (zsh/modules/nodejs/config/base.zsh)

- [ ] 3.1 Update `NODEJS_VERSIONS` (`config/base.zsh:4-6`) and `NODEJS_VERSION_GLOBAL` (`:12`) from `24.11.1` to `24.20.0` to match `mise.toml:8` — alternative considered: defer entirely to mise as the single source of truth (deferred with option 3, see design.md) — verify: `grep -n "24.20.0" zsh/modules/nodejs/config/base.zsh` shows both the array and the global variable; no `24.11.1` remains in the file.
- [ ] 3.2 Align the runtime fnm state: `fnm install 24.20.0 && fnm alias default 24.20.0` so non-mise directories resolve the same version — verify: in a directory without mise config, `node --version` reports `v24.20.0`.

## 4. Harden mise-check-versions (mise-managed repository Taskfile.yml:302-337)

- [ ] 4.1 Add a second assertion to `mise-check-versions` that runs OUTSIDE `mise exec` (ambient PATH, as inherited by `task`): `node --version` must equal the `mise.toml` pin and `command -v node` must not resolve under `fnm_multishells` or `~/.local/share/fnm` — verify: from a shell where fnm shadows mise, `task mise-check-versions` fails with a clear shadowing message; after the task 1 guard, it passes. NOTE: `Taskfile.yml:302-337` lives in the mise-managed project repository, not this dotfiles repository (cross-repo task).

## 5. Validation

- [x] 5.1 Run `zsh -n` syntax check on every modified zsh file (`zsh/modules/nodejs/internal/base.zsh`, `zsh/modules/nodejs/config/base.zsh`) — verify: each exits 0 with no output.
- [ ] 5.2 Run shellcheck via pre-commit on the modified zsh files (`pre-commit run shellcheck --files zsh/modules/nodejs/internal/base.zsh zsh/modules/nodejs/config/base.zsh`) — verify: no findings; guard code contains no bashisms beyond the bash 3.2 baseline.
- [ ] 5.3 Manual verification: inside the mise-managed repository directory, `which -a node` shows the mise shims/installs FIRST and `node --version` reports `v24.20.0`; in a directory without mise config, fnm still resolves node and `command -v fnm` succeeds — verify: both checks pass in a fresh interactive shell after `cd` into and out of the repository.
