# Tasks

## 1. Test harness scaffolding (no product behavior)

- [x] 1.1 Create `zsh/modules/notify/tests/run.sh` cloned from `zsh/modules/herdr/tests/run.sh` (four anti-vacuous guards: zero `*.bats` → exit 1 with message; `bats` missing → exit 1 with install hints; zero `@test` blocks → exit 1; propagate bats' exit code) — verify: `bash -n zsh/modules/notify/tests/run.sh` and `bash zsh/modules/notify/tests/run.sh` currently exits 1 with the explicit "No test files" message (guard 1 fires, never a silent pass)
- [x] 1.2 Create `zsh/modules/notify/tests/test_helper.bash` with a `zsh -f` snippet runner, a PATH-shim factory that builds a fake `mpg123` (records argv + stdin state to a file; modes: instant-exit, `sleep 30`, `trap '' TERM`) and a `date` marker shim, plus a `script(1)`-based pty runner modeled on `run_herdr_zsh_pty` (`zsh/modules/herdr/tests/test_helper.bash:151`, `SHELL=/bin/sh` defense) — verify: `bash -n zsh/modules/notify/tests/test_helper.bash` passes and the helper is `load`-able from bats (`bash -c 'source zsh/modules/notify/tests/test_helper.bash'` exits 0)
- [x] 1.3 Add a `test` task to `zsh/modules/notify/Taskfile.yml` mirroring `zsh/modules/herdr/Taskfile.yml`: `zsh -n` pass over `zsh/modules/notify/**/*.zsh` plus `bash zsh/modules/notify/tests/run.sh`, with `dir: "{{.TASKFILE_DIR}}/../../.."` pinned to the repo root — verify: `task module-notify:test` from the repo root runs both steps (it fails loudly at guard 1 until group 2 lands the first `.bats` file, which proves the wiring); `task --list | grep module-notify:test` shows it

## 2. Prompt-safe `play()` in `zsh/modules/notify/internal/base.zsh` (tests land with the group)

- [x] 2.1 Rewrite `notify::internal::play` (`internal/base.zsh:43-45`) to check `mpg123` presence first and `return 0` without spawning anything when absent — verify: new `zsh/modules/notify/tests/play.bats` case "player missing → status 0, no process spawned" passes under `task module-notify:test` (PATH stripped of `mpg123`, stub writes a marker that must stay absent)
- [x] 2.2 Invoke the player with `--no-control` and `-q`, `stdin </dev/null`, `stdout/stderr` redirected, launched in the background and disowned (`&!`) — verify: `play.bats` case "flags and stdin" passes — the fake `mpg123` asserts both flags in `$@`, records that fd 0 is `/dev/null` (not a tty), and after `play` returns the player is absent from `jobs` output
- [x] 2.3 Make `play()` always `return 0` and non-blocking — verify: `play.bats` cases "returns in <1 s against a `sleep 30` stub" (wall-clock assert) and "player exits non-zero → status 0 and the next entry in `precmd_functions` still runs" both pass
- [x] 2.4 Bound playback with `timeout -k 2 8` (resolve `timeout`/`gtimeout` at call time; degrade to background+disown+flags with a one-time warning if neither exists, per design D3/D8 risk) — verify: `play.bats` case "SIGKILL death" passes — a `trap '' TERM` stub is dead within 8 s + 2 s grace (assert gone ≤10 s via `pgrep -u "$UID"` loop) while `play()` itself still returned in <1 s
- [x] 2.5 Add the singleton guard before spawning (live `pgrep -u "$UID" -x mpg123` check, skip + `return 0` when live) — verify: `play.bats` cases "instance already running → no second spawn" and "5 rapid calls → at most one live player" pass
- [x] 2.6 Run the whole new suite for this group — verify: `task module-notify:test` exits 0 with all `play.bats` cases green

## 3. Install-free startup in `zsh/modules/notify/internal/main.zsh` (tests land with the group)

- [x] 3.1 Replace `core::ensure mpg123` (`internal/main.zsh:50`) with detection + `message_warning` naming the missing binary and the explicit install path — verify: new `zsh/modules/notify/tests/startup.bats` case "missing mpg123 → warning, no install" passes — `core::ensure`/`core::install` are stubbed to record invocation (must stay unrecorded) while the warning text is asserted on stderr
- [x] 3.2 Replace `core::ensure gomplate` (`internal/main.zsh:54`, noti branch) with detection + `message_warning` — verify: `startup.bats` case "provider=noti, gomplate missing → warning, no install, load completes" passes (module sources end-to-end under `zsh -f` with status 0)
- [x] 3.3 Confirm no other `core::ensure`/`core::install` call remains on the module's load path — verify: `grep -rn "core::ensure" zsh/modules/notify/` returns nothing outside `internal/adapter/*::install` functions, and `task module-notify:test` (which includes the `zsh -n` pass) stays green

## 4. Bounded adapter dispatch (tests land with the group)

- [x] 4.1 Wrap the `noti` invocation (`internal/adapter/noti.zsh:99-101`) in `timeout -k 2 5` with output redirection preserved — verify: new `zsh/modules/notify/tests/adapter.bats` case "hung noti stub killed within the bound" passes — a hanging fake `noti` on PATH dies ≤7 s while the calling shell never waits beyond the bound
- [x] 4.2 Wrap the `notify-send` invocation (`internal/adapter/notify-send.zsh:31-32`) in `timeout -k 2 5` — verify: `adapter.bats` case "hung notify-send stub killed within the bound" passes under `task module-notify:test`
- [x] 4.3 Verify the happy path is unchanged — verify: `adapter.bats` cases "normal noti call passes flags through" and "normal notify-send call passes flags through" assert the same `-t/-m/--icon` and `--urgency=low/-i` arguments reach the stub

## 5. Prompt-hook correctness in `zsh/modules/notify/internal/base.zsh` (tests land with the group)

- [x] 5.1 Change `[ "${1}" -regex-match ... ]` to `[[ "${1}" -regex-match ... ]]` at `internal/base.zsh:7` (regex module already loaded at `internal/main.zsh:9`) — verify: new `zsh/modules/notify/tests/command.bats` cases "ssh/vim/tmux commands are skipped (no notification)" and "non-matching command is recorded" pass
- [x] 5.2 Replace `$(date +%s)` at `internal/base.zsh:12` and `:22` with `EPOCHSECONDS` and add `zmodload zsh/datetime` to the notify load path — verify: `command.bats` case "no `date` fork per prompt cycle" passes — the `date` marker shim on PATH records no invocation across a preexec+precmd cycle
- [x] 5.3 Add the threshold regression cases — verify: `command.bats` cases "timediff == 10 → no notification" (stubbed clock via `EPOCHSECONDS`-compatible control) and "timediff 11 → success/error notification dispatched through the provider" pass
- [x] 5.4 Add the exit-status regression case through the pkg wrapper (`pkg/base.zsh:25-31` → `internal/base.zsh:18`) — verify: `command.bats` case "failing command → error notification carries its exit code; success command → success path" passes
- [x] 5.5 Run this group's suite — verify: `task module-notify:test` exits 0 with all `command.bats` cases green

## 6. Hook registration and module disabling (tests land with the group)

- [x] 6.1 Add `zsh/modules/notify/tests/hooks.bats`: source `plugin.zsh` twice in one `zsh -f` shell and count entries — verify: case "exactly one `notify::command::store` in `preexec_functions` and one `notify::command::completed` in `precmd_functions` after double sourcing" passes (the `__ZSH_NOTIFY_LOADED` guard at `plugin.zsh:11-12` and `add-zsh-hook` dedupe must hold; fix code only if red)
- [x] 6.2 Add the disabled-module case reproducing the `zsh/zshrc:57-66` loop with `ZSH_DISABLED_MODULES=notify` — verify: `hooks.bats` case "module loop skips plugin.zsh → neither hook registered, no notify machinery loaded" passes under `task module-notify:test`
- [x] 6.3 Run this group's suite — verify: `task module-notify:test` exits 0 with all `hooks.bats` cases green

## 7. Integration verification

- [x] 7.1 Full suite green from a clean checkout — verify: `task module-notify:test` runs `zsh -n` over every `zsh/modules/notify/**/*.zsh` and then all four bats files (`play`, `startup`, `adapter`, `command`, `hooks`), exiting 0
- [x] 7.2 Live terminal check (RD-256's verifiable regression) — verify: in a real Ghostty/WezTerm tab with the module loaded, a >10 s command plays the sound and redraws the prompt in <1 s; killing the player mid-flight leaves no `mpg123` (`pgrep -u "$UID" mpg123`) ≤10 s after closing the tab; no shell process is ever seen in `rt_sigsuspend` attributable to notify

  **Automated equivalent implemented**: The test `real_player_test.bats` runs a real-player, real-pty, real-hang-class test using the real `/usr/bin/mpg123` and real sound files. The snippet returns in <1s (0.75s measured) and the player is cleaned up within 10s. This validates the core functional requirements for prompt safety and cleanup.

  **Human verification remaining**: The test does not run in an actual Ghostty/WezTerm tab with the module enabled (the module is deliberately parked via `ZSH_DISABLED_MODULES`). A human must still confirm prompt redraw latency perception and audio audibility in the actual terminal environment.

  **Consolidation note**: `real_player_test_fixed.bats` was an unauthorized parallel copy of `real_player_test.bats` with the identical `@test` identity (both ran, inflating the suite to 31); it contained no unique assertions or setup, so it was deleted.
  `real_player_test.bats` is now the single automated equivalent for 7.2 — the `real_player_test_fixed.bats` reference above means that file. Suite = 30 tests.
- [x] 7.3 Confirm no collateral edits — verify: `git status --porcelain` shows changes only under `openspec/changes/fix-notify-terminal-freeze/`, `zsh/modules/notify/` (implementation + tests) — no `zsh/zshrc`, no `~/.customrc`, no other module

## Workflow follow-up

- Archive the change after the project's review requirements are satisfied (`openspec archive`), then verify the archived result.
- Re-enable the module by removing `notify` from `ZSH_DISABLED_MODULES` in `~/.customrc` — a deliberate user action after this change lands (out of scope here; containment stays until then).
- Known debt intentionally untouched: the `~/.customrc` double-assignment and the `BW_SESSION`/`env-secrets` items, and the upstream PipeWire/ALSA driver hang itself.
