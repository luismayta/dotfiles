# Design

## Context

`notify::internal::play` (`zsh/modules/notify/internal/base.zsh:43-45`) runs `mpg123 "${1}" > /dev/null 2>&1` synchronously inside the `precmd` hook chain (`internal/main.zsh:58-60` registers `notify::command::store` on preexec and `notify::command::completed` on precmd; `internal/base.zsh:30-36` calls `play` from there via `success`/`error`). `> /dev/null 2>&1` redirects only stdout/stderr — the player keeps the tty as its controlling terminal and its inherited stdin, so it can and does take terminal control; with no timeout and no detach, a hung `mpg123` (observed: `futex_wait` 70+ min on a 1.56 s file) holds the shell in `rt_sigsuspend` and the prompt is never drawn. `mpg123` catches `SIGTERM`/`SIGINT` but acts on neither while blocked, so SIGTERM-only timeouts do not terminate it. Adjacent debt in the same load path: `internal/main.zsh:50,54` call `core::ensure` (= exists-or-install, `zsh/system/core/pkg/base.zsh:18-20`) so shell startup can run a package manager; `internal/base.zsh:7` uses `[ ... -regex-match ... ]` instead of the documented `[[ ... -regex-match ... ]]` (module loads `zmodload zsh/regex` at `internal/main.zsh:9`); `internal/base.zsh:12,22` fork `date` twice per prompt; the adapters (`internal/adapter/noti.zsh:99-101`, `internal/adapter/notify-send.zsh:31-32`, reached synchronously from `internal/linux.zsh:10`) are unbounded network/D-Bus calls. See proposal.md — Why (RD-256).

## Goals / Non-Goals

**Goals:**
- Make `play()` incapable of blocking the prompt: detached, terminal-safe, hard-bounded, always returning 0 (spec: *Sound playback never blocks the prompt*, *never touches the terminal*, *hard-bounded*, *only one playback at a time*).
- Make startup non-destructive: detect + warn, never install (`internal/main.zsh:50,54`).
- Bound adapter dispatch so a hung provider cannot freeze the prompt either.
- Keep completion-notification semantics byte-for-byte: 10 s strict threshold (`config/base.zsh:20`, `internal/base.zsh:30`), skip-list, sound theme, provider dispatch, `$?` capture through the pkg wrapper (`pkg/base.zsh:25-31` → `internal/base.zsh:18`).
- Remove the per-prompt `date` forks (`EPOCHSECONDS`) and fix the skip-list conditional to the documented `[[ -regex-match ]]`.
- Land a regression suite under `zsh/modules/notify/tests/` (bats, `zsh -f`, herdr conventions) plus a `test` task in `zsh/modules/notify/Taskfile.yml`.

**Non-Goals:**
- The underlying PipeWire/ALSA driver hang that made `mpg123` wedge — upstream, not this repo.
- Re-enabling the module: `notify` stays in `ZSH_DISABLED_MODULES` in `~/.customrc` until the user deliberately removes it after this change lands (RD-256 containment; `~/.customrc` is not touched here).
- The `~/.customrc` double-assignment and `BW_SESSION`/`env-secrets` debt.
- Notification content, format, provider selection (`ZSH_NOTIFY_PROVIDER`), sound theme paths, or the `notify-noti-pattern` spec's noti-binary auto-install guard in `plugin.zsh` (a different flow from the `mpg123`/`gomplate` startup ensure removed here).

## Decisions

### D1 — `play()` becomes a detached, always-0 wrapper
`play()` checks presence (return 0, nothing spawned), checks the singleton guard, then starts `timeout -k 2 8 mpg123 ... </dev/null >/dev/null 2>&1` in the background, disowned (`&!`), and returns 0 unconditionally.
*Alternatives considered:* (a) foreground + `timeout 8` — still freezes the prompt up to 8 s and leaves the player owning the tty; (b) foreground + short timeout — same failure class, just shorter; (c) wait for the job — reintroduces blocking. Rejected. Only detached execution makes the hook truly non-blocking, and only an unconditional `return 0` guarantees the `precmd_functions` chain is never truncated (a non-zero return from one hook can abort the rest).

### D2 — `--no-control` + `stdin </dev/null` are mandatory alongside backgrounding
Backgrounding alone is not terminal-safe: `mpg123` opens `/dev/tty` and calls `tcsetattr()` from a background process group → the tty driver raises **SIGTTOU** and the job is permanently `suspended (tty output)`. `--no-control` removes the `tcsetattr` path; `</dev/null` guarantees the player can never read from (or block on) the interactive tty. Redirecting stdout/stderr alone — the current code — does neither.
*Alternatives considered:* rely on `> /dev/null 2>&1` only — this is the observed bug.

### D3 — `timeout -k 2 8` is mandatory (plain `timeout` is proven ineffective)
8 s covers the longest sound plus margin; on expiry `timeout` sends SIGTERM, and `-k 2` escalates to SIGKILL after a 2 s grace — the only signal that reliably ends a wedged `mpg123` (it catches SIGTERM/SIGINT and acts on neither while blocked in `futex_wait`). Worst case lifetime: 10 s, so even an orphan reparented to `PPID=1` after tab close dies within the bound instead of surviving for hours.
*Alternatives considered:* plain `timeout` (proven ineffective here); `kill -9` directly (denies the player any clean exit path); `pkill` after the fact (no bound on when it runs).

### D4 — Singleton guard by live-process check, not by shell state
Before spawning, `play()` checks whether an `mpg123` for the current user is already running (e.g. `pgrep -u "$UID" -x mpg123`) and skips with return 0 if so.
*Alternatives considered:* a shell-variable lock — cannot observe completion of a disowned job; a pidfile/lockfile — goes stale across shells and tmp reboots. A live process check reflects reality in every shell.
*Rationale:* the guard exists to stop accumulation (one player per lost prompt), not to queue sounds — dropping a redundant chime is the correct trade.

### D5 — Startup: detect + `message_warning`, never `core::ensure`
`internal/main.zsh:50` (`mpg123`) and `:54` (`gomplate`, noti provider only) become `core::exists <tool> || message_warning "<tool> missing: notifications/sounds degrade; install it explicitly"`. Package installation stays an explicit user action through the existing pkg/install functions.
*Alternatives considered:* keep `core::ensure` — shell startup would run a package manager (slow, may prompt, may fail offline/sandboxed); silent skip — users lose sound with no explanation. Warnings cost nothing and keep startup deterministic.

### D6 — Skip-list conditional uses the documented `[[ -regex-match ]]`
`internal/base.zsh:7` changes `[ "${1}" -regex-match "..." ]` → `[[ "${1}" -regex-match "..." ]]`. `-regex-match` is a documented `[[ ]]` conditional (provided by `zsh/regex`, already loaded at `internal/main.zsh:9`); the `[` builtin has no such operator, so the skip guard does not behave as documented. The pattern itself (`config/base.zsh:21`) is unchanged.
*Alternatives considered:* porting to a different matching mechanism — unnecessary churn; the documented form is one character of difference.

### D7 — `EPOCHSECONDS` instead of `$(date +%s)`
`internal/base.zsh:12` (`_zsh_notify_start_time`) and `:22` (`now`) read the `EPOCHSECONDS` special parameter, with `zmodload zsh/datetime` added in the notify load path (zshrc only loads it inside the darwin compinit branch — `zsh/zshrc:94` — so notify must not rely on that).
*Alternatives considered:* keep `date` — 2 fork+execs per prompt, exactly the class of work that must not run inside a frozen-hook investigation; `strftime` alone — no epoch-seconds parameter without the module anyway.

### D8 — Adapters bounded with `timeout -k` (5 s, 2 s grace)
`noti` (network I/O to Telegram) and `notify-send` (D-Bus) are invoked synchronously from the popup path inside the precmd chain, so each becomes `timeout -k 2 5 <adapter cmd>` with output redirection as today. A hung provider degrades to "no popup this time" instead of "no prompt".
*Note:* RD-256 fixes the exact numbers only for playback (8/2); 5/2 for adapters is this design's choice — notification delivery is lightweight and should never need 8 s. The spec states the bound as a requirement without pinning seconds, so this can be tuned without a spec change.

### D9 — Test harness mirrors the herdr module convention
`zsh/modules/notify/tests/` gets `run.sh` (herdr's four anti-vacuous guards: zero `*.bats` → fail, `bats` missing → fail with install hints, zero `@test` blocks → fail, propagate bats' exit code), `test_helper.bash` (zsh -f snippet runner + PATH shims), and `*.bats` files. `zsh/modules/notify/Taskfile.yml` gains a `test` task cloned from `zsh/modules/herdr/Taskfile.yml`: a `zsh -n` syntax pass over the module's `*.zsh`, then `bash tests/run.sh`, with `dir` pinned to the repo root; invocable from the root Taskfile as `task module-notify:test` (include already exists at `Taskfile.yml:110-111`).
*Stub strategy:* a fake `mpg123` first on `PATH` that records argv + stdin state to a file, optionally sleeps (30 s hang), or runs `trap '' TERM` (SIGKILL test); the real coreutils `timeout` is exercised. The pty case (`icanon`/`echo` preserved) uses `script(1)` the way herdr's `run_herdr_zsh_pty` does (`zsh/modules/herdr/tests/test_helper.bash:151+`), with `SHELL=/bin/sh` to avoid rc contamination.

## Risks / Trade-offs

- [macOS ships no `timeout` by default (the module has a darwin path)] → Mitigation: resolve `timeout`/`gtimeout` at call time; if neither exists, degrade to background + disown + flags (still non-blocking and terminal-safe — the freeze class is gone) and warn once. Primary target (CachyOS/Linux) always has coreutils `timeout`. This degradation lives in code, not in the spec, whose bound applies where the tool exists.
- [Singleton guard race: two prompts pass the check simultaneously] → Mitigation: window is microseconds; D3's bound still caps any double run at ≤10 s, and accumulation across prompts is what the guard actually prevents.
- [Singleton guard can be fooled by another user's `mpg123`] → Mitigation: scope `pgrep` to the current UID; worst case one dropped sound, never a freeze.
- [Disowned player is invisible to `jobs`; user cannot `fg` it] → Mitigation: it is bounded and killable by name (`pkill -u "$UID" mpg123`); a notification sound is not interactive work.
- [Removing auto-install silently degrades sound for machines that relied on `core::ensure`] → Mitigation: `message_warning` names the missing binary and the explicit install path; RD-256 explicitly requires no package installs during shell startup.
- [Tests depend on `bats`, coreutils `timeout`, and `script(1)`] → Mitigation: `run.sh` fails loudly (never skips) when bats is missing, per the herdr precedent; the pty test fails explicitly rather than faking a pass when no pty runner is available.
- [Behavior overlap with `notify-noti-pattern`'s "auto-install guard" requirement] → Mitigation: that requirement targets the noti binary in `plugin.zsh`, which this change does not touch; no existing spec is modified (see proposal.md — Capabilities).

## Migration Plan

1. Implement `internal/base.zsh` (play rewrite, `[[ -regex-match ]]`, `EPOCHSECONDS`), `internal/main.zsh` (detect + warn, `zmodload zsh/datetime`), and the two adapters (bounded dispatch).
2. Land `zsh/modules/notify/tests/` + the `test` task; run `task module-notify:test` (zsh -n pass + bats suite) until green.
3. Smoke-check in a real shell: source `zsh/modules/notify/plugin.zsh` under `zsh -f`, fire a >10 s command, confirm prompt returns instantly, sound plays once, and `pgrep mpg123` is empty ≤10 s afterwards.
4. After merge, the user re-enables the module by removing `notify` from `ZSH_DISABLED_MODULES` in `~/.customrc` (deliberately out of scope here — containment remains until then).
5. Rollback: revert the change; the module can again be parked via `ZSH_DISABLED_MODULES`. No data or config migration involved.

## Open Questions

None. Playback bound (8 s + 2 s SIGKILL), `--no-control`/`</dev/null`, install-free startup, and preserved notification semantics are fixed by RD-256; the only free parameter (adapter bound) is decided in D8 and is spec-compatible as written.
