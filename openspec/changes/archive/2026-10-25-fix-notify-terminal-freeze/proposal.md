# Proposal

## Why

RD-256: the `notify` module intermittently freezes terminal tabs (Ghostty/WezTerm on CachyOS/Hyprland). The audit pinned the cause in code: `notify::internal::play` (`zsh/modules/notify/internal/base.zsh:43-45`) runs `mpg123` synchronously inside the `precmd` hook (registered at `zsh/modules/notify/internal/main.zsh:58-60`) with no timeout, no `stdin` redirect, and terminal control still enabled — `> /dev/null 2>&1` only redirects stdout/stderr, never the tty. Observed in runtime: `mpg123` stuck in `futex_wait` for 70+ minutes on a 1.56 s file; the parent shell waiting in `rt_sigsuspend` with the child's `TPGID`, so the prompt was never drawn and the tab died; orphaned players (`PPID=1`, `fd0` on a destroyed pty) survived tab close and accumulated one per lost tab. `mpg123` catches `SIGTERM`/`SIGINT` but acts on neither while blocked, so a plain `timeout` does not terminate it — `timeout -k` (SIGKILL) is required. Containment already applied outside this scope: `notify` was added to `ZSH_DISABLED_MODULES` in `~/.customrc` and the hung processes were killed. This change is the permanent fix so the module can be re-enabled without freezing terminals.

## What Changes

- Rewrite `notify::internal::play` (`zsh/modules/notify/internal/base.zsh`) into a prompt-safe wrapper: check `mpg123` presence and return 0 without executing when absent; invoke with `--no-control` and `-q`, `stdin </dev/null` (never the tty), backgrounded and disowned; hard-bound playback with `timeout -k 2 8`; skip when an `mpg123` instance is already running (singleton guard); **always return 0** so it can never truncate the `precmd_functions` chain.
- `zsh/modules/notify/internal/main.zsh:50,54`: replace `core::ensure` (exists-or-install, `zsh/system/core/pkg/base.zsh:18-20`) with detection + `message_warning` — shell startup never invokes package installation.
- Bound the notification adapters: `noti` (`internal/adapter/noti.zsh:99-101`) and `notify-send` (`internal/adapter/notify-send.zsh:31-32`) run under `timeout` with a SIGKILL backup so a slow provider cannot block the prompt.
- `zsh/modules/notify/internal/base.zsh:7`: `[ ... -regex-match ... ]` → `[[ ... -regex-match ... ]]` (the documented form; `zmodload zsh/regex` is already at `internal/main.zsh:9`) — skip-list filtering (`ssh|vim|nvim|tmux|...`, pattern at `config/base.zsh:21`) keeps working.
- `zsh/modules/notify/internal/base.zsh:12,22`: `$(date +%s)` → `EPOCHSECONDS` (with `zmodload zsh/datetime`), removing 2 forks per prompt.
- New `zsh/modules/notify/tests/` — bats suite running under `zsh -f`, following the `zsh/modules/herdr/tests/` convention (run.sh anti-vacuous guards, test_helper with plain + pty runners) — plus a `test` task in `zsh/modules/notify/Taskfile.yml` (invocable as `task module-notify:test`; root include at `Taskfile.yml:110-111`).

Notification semantics are otherwise unchanged: 10 s threshold (`config/base.zsh:20`, strict `>` at `internal/base.zsh:30`), skip-list, sound theme (`ZSH_NOTIFY_SOUND_THEME`), provider dispatch.

## Capabilities

### New Capabilities

- `notify-prompt-safety`: the interactive shell must never be blocked, frozen, or mutated by notify — detached and bounded sound/notification dispatch at prompt time, install-free startup, preserved completion-notification semantics, and idempotent, disable-respecting hook registration.

### Modified Capabilities

None. Existing notify specs keep their exact meaning: `notify-noti-pattern` covers module structure/naming and a noti-binary auto-install guard in `plugin.zsh` (untouched by this change — the removed `core::ensure` calls are for `mpg123`/`gomplate` in `internal/main.zsh`), `notify-sound-theme` covers theme selection (unchanged), `notification-controls` covers compositor keybinds (unrelated).

## Impact

- **Modified code** (implementation phase, not in this planning change):
  - `zsh/modules/notify/internal/base.zsh` — `play()` rewrite (lines 43-45), `[[ -regex-match ]]` (line 7), `EPOCHSECONDS` (lines 12, 22).
  - `zsh/modules/notify/internal/main.zsh` — startup detection + warning instead of `core::ensure` (lines 50, 54); `zmodload zsh/datetime`.
  - `zsh/modules/notify/internal/adapter/noti.zsh`, `zsh/modules/notify/internal/adapter/notify-send.zsh` — bounded dispatch.
  - `zsh/modules/notify/Taskfile.yml` — new `test` task.
- **New files**: `zsh/modules/notify/tests/` (run.sh, test_helper, `*.bats`).
- **Behavior users see**: a missing `mpg123`/`gomplate` at startup now yields a warning instead of an auto-install; notifications can no longer freeze a tab; no `precmd` hook truncation regardless of player outcome.
- **No changes** to `zsh/zshrc`, `~/.customrc`, the module's public API (`notify::play`, `notify::success`, ...), sound assets, or notification content.
