# Proposal

## Why

Jira RD-230 renamed `TMUX_SOCKET` to `HERDR_WORKSPACE` in the three terminal
emulator configs so that per-emulator workspace routing could move from tmux to
herdr. That rename already landed in commit `5082cd20`: Ghostty, WezTerm and
Alacritty now export `HERDR_WORKSPACE` with their emulator identifier, and no
emulator config references `TMUX_SOCKET` anymore.

The rename alone leaves `HERDR_WORKSPACE` a dangling producer. Three emulators
set it; nothing in the repo reads it — a repo-wide search finds zero occurrences
of `hrd::start` and no code consuming `HERDR_WORKSPACE` without a suffix. The
seam that was supposed to consume it, `_hrd()` in
`zsh/modules/herdr/pkg/helper.zsh`, claims in its comment to provide "optional
TMUX-like socket support" but its body is an empty passthrough
(`command herdr "$@"`). Without a consumer, the emulator-side rename produces no
observable behavior: opening Ghostty, WezTerm or Alacritty gives the same
undifferentiated herdr session.

This change closes the consumer gap: it gives the herdr module an entry-point
function (`hrd::start`) that routes herdr to a per-emulator session via
`HERDR_WORKSPACE`, mirroring how the tmux module consumed `TMUX_SOCKET` through
`tmux -L`. Part of RD-230 (the emulator configs) is already done and is not
repeated here; this change covers only the remaining herdr consumer plus its
documentation.

## What Changes

- `zsh/modules/herdr/pkg/helper.zsh` — `_hrd()` remains a plain
  argument-forwarding wrapper (`command herdr "$@"`) with no routing; its
  comment describes the forwarding it actually performs instead of promising
  seam behavior it does not have. (This reverses the earlier plan to make
  `_hrd()` the routing seam — see design.md D1 for the evidence and why the
  earlier reasoning was wrong.)
- `zsh/modules/herdr/pkg/helper.zsh` — new `hrd::start` function, placed near
  `hrd::project` (the structural template), using the `hrd::` prefix per the
  file's user-facing convention: error + `return 1` when `herdr` is missing from
  PATH; build `--session "${HERDR_WORKSPACE}"` directly at execution — inside
  `hrd::start`, not delegated — when the variable is set and `HERDR_ENV` is
  unset; invoke herdr without `--session` and inform the user via `message_info`
  when it is empty or unset (without failing); and when `HERDR_ENV=1` (already
  inside a herdr pane), invoke bare `command herdr` so herdr auto-attaches to
  the ambient session instead of opening a nested one.
- Routing is built in exactly one place — `hrd::start`, at execution.
  `_hrd()` does no routing: it is a plain argument-forwarding wrapper.
- `docs/env-vars.md` — add a `HERDR_WORKSPACE` section documenting the
  per-emulator values (`ghostty`, `wezterm`, `alacritty`); the existing
  `TMUX_SOCKET` subsection is retained but annotated as legacy/orphaned (see
  Impact — tmux code still reads it).
- **CLI constraint (authoritative):** verified against `herdr 0.9.1` at
  `/home/lucho/.local/bin/herdr`, the parser **silently discards unknown
  flags**. `herdr -s ghostty` exits 0 with no error and is ignored; only
  `herdr --session ghostty` actually applies (moves state to
  `~/.config/herdr/sessions/ghostty/`). Real short flags are only `-h`, `-V`,
  `-v`, `-y`; there is no `--socket` or `--instance`, and `--server` is a verb.
  **`--session` in long form is the ONLY correct invocation** — an
  implementation using `-s` would silently fall back to the `default` session
  with no error. No task or implementation of this change may use `-s`.

## Capabilities

### New Capabilities

- `herdr-workspace-routing`: routing herdr sessions by the active terminal
  emulator via the `HERDR_WORKSPACE` environment variable — `hrd::start` as the
  public entry point and the sole construction site of `--session`, graceful
  degradation when the variable is unset, and failure when the `herdr` binary is
  absent.

### Modified Capabilities

None. No existing capability's requirements change.

## Impact

**Affected code**

- `zsh/modules/herdr/pkg/helper.zsh` — two edits: correct `_hrd()`'s comment so
  it honestly describes the passthrough (lines 11-19; no routing is added
  there), and add `hrd::start` near `hrd::project` (line 83), where `--session`
  is constructed directly at execution.
- `docs/env-vars.md` — new `HERDR_WORKSPACE` subsection; `TMUX_SOCKET`
  subsection annotated as legacy, not deleted.
- No emulator config changes: `zsh/modules/ghostty/data/config`,
  `zsh/modules/wezterm/data/wezterm.lua` and `zsh/modules/alacritty/data/core.toml`
  already export `HERDR_WORKSPACE` (commit `5082cd20`), and RD-230's acceptance
  criteria for those files are already satisfied.

**Dependencies / conventions**

- `core::exists`, `message_error`, `message_info` (thin wrappers in
  `zsh/system/core/pkg/base.zsh`), called without a `core::` prefix per existing
  herdr code.
- `ZSH_HERDR_WORKSPACE_PREFIX` / `HERDR_WORKSPACE_PREFIX`
  (`zsh/modules/herdr/config/base.zsh:11,34`) are different variables and are
  explicitly out of scope — do not conflate them with `HERDR_WORKSPACE`.
- Validation: shellcheck via `.pre-commit-config.yaml` on `.zsh` files
  (excludes SC1072,SC1073,SC2068,SC1091), codespell+lychee on markdown. No
  executable test suite exists for zsh module functions (no bats/test runner) —
  shellcheck is the only automated gate.

**Out-of-scope regression discovered during planning (deliberate follow-up debt)**

Commit `5082cd20` renamed the emulator producers but left three live tmux code
paths reading `TMUX_SOCKET`, which nothing sets anymore:

- `zsh/system/core/pkg/helper/tmux.zsh:5-9,23` →
  `tmux -L "${TMUX_SOCKET:-default}" new-session -A -s allsafe`
- `zsh/modules/tmux/pkg/helper.zsh:49-50` → `command tmux -L "${TMUX_SOCKET}" "$@"`
- `zsh/modules/tmux/internal/base.zsh:130-131` → same pattern
- (plus a comment reference at `zsh/detect/terminal.zsh:5`)

The tmux module is still enabled by default (not in `ZSH_DISABLED_MODULES`), so
tmux's per-emulator socket routing is currently broken and silently falls back
to the `default` socket. The user explicitly scoped this change to the **herdr
consumer only**; fixing the tmux readers is deferred to a separate change and no
tasks for it belong here. This is also why `docs/env-vars.md` must retain the
`TMUX_SOCKET` subsection (annotated as legacy/orphaned) — deleting it while tmux
code still reads the variable would make the docs lie.
