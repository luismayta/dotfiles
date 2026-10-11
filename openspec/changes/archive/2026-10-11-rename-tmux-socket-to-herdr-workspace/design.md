# Design

## Context

`proposal.md` explains why this change exists (RD-230 renamed `TMUX_SOCKET` to
`HERDR_WORKSPACE` in the emulator configs but left the variable with no consumer)
and `specs/herdr-workspace-routing/spec.md` states the required behavior. This
document does not repeat either; it records the design decisions behind the
approach and the evidence they rest on, so implementation does not re-litigate
them.

Facts the decisions depend on:

- `_hrd()` (`zsh/modules/herdr/pkg/helper.zsh:7-10`) is an empty passthrough
  (`command herdr "$@"`) whose comment already promises "optional TMUX-like
  socket support" — a contract the code does not keep.
- The tmux module shows the intended shape (`zsh/modules/tmux/pkg/helper.zsh:47-54`):
  `_tmux()` conditionally injects `-L "${TMUX_SOCKET}"`, guarded so it does not
  re-route when already inside tmux.
- `herdr 0.9.1` (`/home/lucho/.local/bin/herdr`) silently discards unknown flags.
  Its help documents `herdr --session <name> [options]` as a root-level form with
  `--session <name>` described as "Use or create a named persistent session".
  Verified live: `herdr --session ghostty status` reports the session socket at
  `~/.config/herdr/sessions/ghostty/herdr.sock` (exit 0). See D1/D2.
- The emulator producers already landed (commit `5082cd20`); this change adds
  the consumer plus `docs/env-vars.md` updates only (proposal, Impact).

## Goals / Non-Goals

**Goals:**

- Deliver the `herdr-workspace-routing` capability exactly as the spec delta
  describes it: `hrd::start` entry point, long-form session selection, graceful
  fallback when the variable is absent, explicit failure when the binary is
  missing.
- Resolve routing in exactly one place — inline in `hrd::start` — so every
  launch made through the entry point is consistently scoped (proposal, "What
  Changes").
- Keep the change confined to `zsh/modules/herdr/pkg/helper.zsh` and
  `docs/env-vars.md`.

**Non-Goals:**

- Migrating the orphaned `TMUX_SOCKET` tmux readers
  (`zsh/system/core/pkg/helper/tmux.zsh:5-9,23`,
  `zsh/modules/tmux/pkg/helper.zsh:49-50`,
  `zsh/modules/tmux/internal/base.zsh:130-131`) — user-deferred to a separate
  change; deliberately absent from this change's tasks.
- Changing the three emulator configs (`ghostty/data/config`,
  `wezterm/data/wezterm.lua`, `alacritty/data/core.toml`) — already done in
  commit `5082cd20`; RD-230's acceptance criteria for those files are satisfied.
- `ZSH_HERDR_WORKSPACE_PREFIX` / `HERDR_WORKSPACE_PREFIX`
  (`zsh/modules/herdr/config/base.zsh:11,34`) — different variables; out of
  scope, must not be conflated with `HERDR_WORKSPACE`.
- Deleting the `TMUX_SOCKET` subsection from `docs/env-vars.md` — tmux code
  still reads the variable, so the subsection is annotated as legacy/orphaned
  instead. That annotation and the new `HERDR_WORKSPACE` section are
  documentation tasks within this change, not architectural decisions.

## Decisions

### D1 — Routing is built inline in `hrd::start`; `_hrd()` reverts to a passthrough

**This reverses the earlier D1 recorded in this document** (routing in `_hrd()`,
"the single seam"). The implementation was reviewed and that placement was
rejected. The decided direction — recorded, not an open option — is that
`hrd::start` builds the flag directly at execution, and `_hrd()` reverts to a
plain `command herdr "$@"` passthrough with an honest comment.

Why the earlier reasoning was wrong — the evidence is a call-site census. The
herdr module makes **29** `herdr` invocations, and only **2** route through
`_hrd()`: `hrd:49` (the known-subcommand branch of the `hrd` dispatcher at
`pkg/helper.zsh:46-54`) and `hrd::start`. The other **28** bypass `_hrd()`
entirely, calling `herdr`/`command herdr` directly:

- `pkg/helper.zsh:124` (`hrd::project`), `pkg/helper.zsh:211` (`hrd::plugin`)
- `internal/base.zsh:128`
- `internal/workspace.zsh:12,39,44,64`
- `internal/worktree.zsh:28,34,58,88,105,150,161`
- `internal/pane.zsh:30,68,77,85,86,87,119,135`
- `internal/install.zsh:65,84,99,122,153,158`

The entire `hrdw::*` family (list/create/open/remove) reaches herdr only via
`internal/worktree.zsh`, never via `_hrd()`. So `_hrd()` was a single seam in
name only: routing placed there would have applied to **2 of 29** call sites.
The previous D1's claims — "keeps every future herdr invocation routed
consistently" and "a single decision point that cannot drift apart from itself" —
described a property of the wrapper in the abstract, not of this codebase, where
28 call sites invoke the binary directly. The indirection bought consistency for
2 of 29 invocations while presenting itself as full coverage. Building the flag
where the invocation actually happens — at execution inside `hrd::start` — is
simpler, easier to scale and maintain, and does not pretend to cover call sites
it never sees. The tmux pattern the old D1 set out to replicate
(`zsh/modules/tmux/pkg/helper.zsh:47-54`) presumes call sites that actually
route through the wrapper; in this module they do not.

**What the implementation does.** `hrd::start` (placed per D5) checks binary
presence first (D4), then constructs `--session` itself, in three branches:

1. `HERDR_WORKSPACE` unset or empty → `message_info "HERDR_WORKSPACE is not
   set; starting herdr without routing."` + bare `command herdr` — graceful
   degradation, no failure (spec-required notice).
2. `HERDR_WORKSPACE` set, `HERDR_ENV` unset →
   `command herdr --session "${HERDR_WORKSPACE}"`, the flag at the **root
   position** of the argument list (root position is the verified-correct
   grammar: `herdr --session ghostty status` resolves the ghostty session
   socket; `--session` is documented on the root command, not on subcommands).
3. `HERDR_WORKSPACE` set, `HERDR_ENV=1` (already inside a herdr pane) → bare
   `command herdr`, so herdr auto-attaches to the ambient session instead of
   opening a nested one.

`_hrd()` (`pkg/helper.zsh:11-19`) reverts to a plain `command herdr "$@"`
passthrough with an honest comment — no routing, no flag construction, no
guard; the comment describes forwarding, matching what the body does. The `hrd`
dispatcher (`pkg/helper.zsh:46-54`) keeps forwarding known subcommands through
`_hrd`, which now passes them through unchanged (see Risks — subcommand
routing).

**The "already inside herdr" guard — moved into `hrd::start`, not dropped.** The
guard now lives as branch 3 above: the flag is only built when
`[[ -z "${HERDR_ENV:-}" ]]` holds. The tmux guard checks `[[ -z "${TMUX}" ]]`
(not inside tmux). The analogous herdr guard checks `[[ -z "${HERDR_ENV:-}" ]]`:
herdr sets `HERDR_ENV=1` and `HERDR_PANE_ID` inside its own panes (RD-230,
design note). Decision: **include the guard.** Justification (carried over from
the previous D1, re-anchored to `hrd::start`, unchanged in substance):

1. Inside herdr panes, herdr already auto-attaches to the current session when
   invoked without a flag (RD-230). Passing `--session` there is redundant at
   best; its in-pane semantics (a flag-given invocation from within a pane of a
   session) are unverified, and this change must guarantee that passing
   `--session` from inside a herdr session cannot produce a nested
   session/attach loop (Risks — double attach). The guard makes that unverified
   path unreachable rather than betting on untested behavior.
2. In every realistic chain the guarded and unguarded variants converge to the
   same session: Ghostty exports `HERDR_WORKSPACE=ghostty`, `hrd::start` routes
   to session `ghostty`, panes inherit both `HERDR_WORKSPACE=ghostty` and
   `HERDR_ENV=1`. Without the flag, herdr auto-attaches to the current session —
   which *is* the emulator session. The two designs differ only when the user
   has manually switched sessions inside herdr, and there the guard respects the
   ambient session, which is exactly what the tmux guard chose for the same
   reason (never re-target out from under the running tool).
3. The spec's scenarios launch from the emulator itself (fresh terminal,
   `HERDR_ENV` unset), where the guard never fires; observable behavior for
   every specified scenario is unchanged.

The guard is therefore structurally like tmux's but not a verbatim copy: it
checks a different marker (`HERDR_ENV` with a safe `${...:-}` default, not
`$TMUX`) and is justified by re-entrancy/ambient-attach semantics rather than
tmux's cross-server `-L` semantics. What changed from the earlier D1 is only
*where* it sits: the flag decision happens at execution in `hrd::start`, not in
the forwarding wrapper every caller was assumed to use.

**`hrd::start` is the only constructor of the flag.** It checks the binary (D4),
emits the spec-required `message_info` when `HERDR_WORKSPACE` is unset or empty,
and builds `--session` itself in branch 2; all `--session` construction exists
in `hrd::start` alone, and `_hrd()` never touches it. Note on the requirements
doc: RD-230's illustrative snippet shows `hrd::start` passing `--session`
itself — the chosen placement matches that snippet. The earlier reading this
document leaned on (RD-230's acceptance criterion: routing resolved in `_hrd()`,
not duplicated in `hrd::start`) is superseded by the review decision recorded
above; the observable behavior of the entry point is identical either way, and
the difference was confined to an indirection almost no call site used.

Scope note: `hrd::project` invokes `herdr workspace create` directly
(`pkg/helper.zsh:124`), one of the 28 call sites that bypass `_hrd()`. Left
untouched — the proposal scopes this change to `hrd::start` and `_hrd()`'s
comment, and workspace-creation calls are not entry-point launches.

Alternatives considered:

- **(a) Routing in `_hrd()`, "the single seam" — the previous design, D1 as
  originally written** — rejected: only 2 of the module's 29 `herdr`
  invocations route through `_hrd()` (the dispatcher branch at
  `pkg/helper.zsh:49` and `hrd::start`); the other 28 call `herdr`/`command
  herdr` directly, and the `hrdw::*` family never touches it. It provided the
  appearance of a single decision point without the substance — routing that
  demonstrably covers 2 of 29 call sites — while the tmux pattern it imitated
  (`zsh/modules/tmux/pkg/helper.zsh:47-54`) presumes call sites that actually
  route through the wrapper. This is the reversal recorded at the top of D1.
- **(b) Delete `_hrd()` and call `command herdr` directly** — rejected: breaks
  the module's single-binary-invocation seam (the `hrd` dispatcher's
  known-subcommand forwarding depends on it) and is gratuitous churn; as a plain
  passthrough the wrapper costs nothing.
- **(c) No inside-herdr guard (route whenever `HERDR_WORKSPACE` is set)** —
  rejected: satisfies the spec's written scenarios but relies on unverified
  in-pane `--session` semantics and can re-target a session the user deliberately
  switched to; see justification above.
- **(d) Guard on `HERDR_PANE_ID` instead of `HERDR_ENV`** — rejected:
  both are set in herdr panes, but `HERDR_ENV=1` is the documented
  "inside herdr" marker; using two markers adds no information.

### D2 — Session selection uses `--session` long form only

The only correct invocation is `herdr --session <name>`. Verified against
`herdr 0.9.1` at `/home/lucho/.local/bin/herdr`:

- The parser **silently discards unknown flags**: `herdr -s ghostty` exits 0
  with no error and is ignored (state stays under `~/.config/herdr/`);
  `herdr --session ghostty` applies (state moves to
  `~/.config/herdr/sessions/ghostty/`). `herdr --definitely-not-a-flag` and
  `herdr -Z` also exit 0 silently.
- Real short flags, extracted from the 124 `opts=` blocks of
  `herdr completion bash`: only `-h` and `-V` (global), `-v`
  (`herdr agent explain`), `-y` (`herdr integration plugin install`).
- No `--socket`, no `--instance`; `--server` is a verb, not a session flag.
  `herdr --help` lists `--session <name>` under root `Options` and shows
  `herdr --session <name> [options]` as a usage form.

The danger this decision exists to prevent: a `-s` implementation would look
correct, pass every manual smoke test (exit 0!), and silently connect to the
`default` session. This is the single highest-consequence decision in the
change — the failure mode is indistinguishable from success by exit code.

Verification rule that follows from this: confirm routing by checking that state
lands in `~/.config/herdr/sessions/<name>/` (e.g. via
`herdr --session <name> status`, whose `socket:` line names the session
directory), never by exit code.

Alternatives considered and rejected:

- **`-s` short form** — rejected: silently ignored by the parser; produces a
  wrong-but-successful connection to `default` with zero diagnostics.
- **Rely on herdr's built-in `HERDR_ENV=1` auto-attach with no flag** —
  rejected: works, but gives no persistent per-emulator workspace. The original
  intent of `TMUX_SOCKET` (and RD-230's rename) was per-emulator persistence —
  distinct named sessions per emulator — which no-flag invocation does not
  provide.

### D3 — Naming: `hrd::start`, not `herdr::start`

The file's de-facto convention is `hrd::*` for user-facing interactive commands
(`hrd`, `hrdk`, `hrd::project`, `hrd::plugin`) plus `hrd::internal::*` for
helpers, and `hrdw::*` for worktree helpers. The `herdr::` namespace lives in
`pkg/base.zsh` for lifecycle wrappers over `herdr::internal::*`. No `herdr::`
function is defined anywhere in `pkg/helper.zsh` (RD-230 counts: ~27 `hrd::*`
user-facing vs ~24 `herdr::*` lifecycle functions). An entry point the user
invokes belongs to the interactive namespace of the file it lives in.

Alternatives considered and rejected:

- **`herdr::start`** — rejected: wrong namespace for this file; would read as a
  lifecycle wrapper and break the `hrd::`/`herdr::` split the module already
  maintains.
- **`hrd::open` / `hrd::launch`** — rejected: less clear than `start` for an
  entry point, and the "open" idiom is already occupied by `hrdw::*` worktree
  helpers.

### D4 — Binary presence check lives in `hrd::start`, via `core::exists`

The absence of a dependency is a user-facing precondition of the entry point:
it must be reported before any routing is attempted, so `hrd::start` performs
`if ! core::exists herdr` first, then `message_error` + `return 1`. `_hrd()`
stays a thin passthrough wrapper with no error-path responsibilities — it is
called by internal dispatchers (`hrd` subcommand forwarding) where a
user-facing error banner would be noise.

Convention (matches existing herdr code): `core::exists`, `message_error`,
`message_info` are thin wrappers in `zsh/system/core/pkg/base.zsh` (lines 14,
34-47); the message functions are called **without** the `core::` prefix
(`message_error "..."`, `message_info "..."`), while existence checks keep it
(`if ! core::exists fzf; then` — e.g. `pkg/helper.zsh:163`,
`internal/main.zsh:27`).

Alternatives considered and rejected:

- **Check inside `_hrd()`** — rejected: every internal caller (the dispatcher's
  forwarded subcommands) would pay for a user-facing error path, and the check
  would run on every invocation instead of once at the entry point.
- **Check in the core layer / a global guard** — rejected: overreach; binary
  availability is a concern of this entry point only.

### D5 — Placement next to `hrd::project`

`hrd::start` goes in the "Project launcher"-adjacent region of
`pkg/helper.zsh` (the section divider at lines 75-77, after the workspace
helpers), using `hrd::project` (line 83) as the structural template: a
multi-line doc comment stating purpose and behavior, guard clauses with
`message_error` + `return 1` on failure (lines 87-90), and the sectioned-file
layout the module already uses.

Alternatives considered and rejected:

- **Top of file, next to `_hrd()`** — rejected: that region holds the fzf
  workspace-switch helpers (`hrd`, `hrdk`); the entry point is a launcher, not a
  switcher, and burying it above the dispatcher obscures the public surface.
- **A new dedicated section** — rejected: adds navigation overhead for a single
  function; the launcher region is the natural sibling (both are
  `hrd::<verb>` entry points ported from the tmux module).

## Risks / Trade-offs

- **Silent flag discard** → Mitigation: any future use of `-s`, or of a guessed
  long flag (`--socket`, `--instance`), would be silently ignored by herdr,
  producing a wrong-but-successful session. The long-form-only requirement is
  therefore normative in the spec, and the parser finding is recorded in D2 so
  it is not re-litigated. Verification always checks that state lands in
  `~/.config/herdr/sessions/<name>/` — never the exit code, which is 0 either
  way.

- **Env var inheritance** → Mitigation/Trade-off: `HERDR_WORKSPACE` leaks into
  child processes — documented at `zsh/modules/wezterm/data/wezterm.lua:14-16`
  with "Alacritty launched from WezTerm" as the example (also
  `zsh/detect/terminal.zsh:4-7` for the same class of leak). This is known and
  intentional: terminal detection in `zsh/zshrc` deliberately uses
  `TERM_PROGRAM`, not this variable, precisely to avoid the trap. Accepted
  consequence: nested emulators share the outer emulator's workspace, which is
  consistent with how `TERM_PROGRAM` sidesteps the same issue for detection.

- **No automated test coverage** → Mitigation: the repo has no bats/test runner
  for zsh module functions; the only automated gate is shellcheck via
  `.pre-commit-config.yaml` on `.zsh` files (excludes
  SC1072,SC1073,SC2068,SC1091), plus codespell+lychee on markdown. Behavior is
  verified manually against the state-directory side effect (D2's verification
  rule). Recorded here as an explicit coverage gap — this design does not
  pretend a suite exists.

- **Double attach semantics** → Mitigation: herdr already auto-attaches to the
  current session inside its own panes, so a `--session`-carrying invocation
  from within a herdr session must not create a nested session loop. Addressed
  by D1's guard in `hrd::start`: the flag is only built when `HERDR_ENV` is
  unset, so in-pane invocations fall back to herdr's ambient auto-attach (bare
  `command herdr`) and the flag is never applied re-entrantly.

- **`hrd` subcommands are no longer session-routed** → Mitigation: `hrd status`,
  `hrd session ...`, `hrd worktree ...` reach herdr through the `hrd`
  dispatcher's `_hrd` call at `pkg/helper.zsh:49`, which is now an un-routed
  passthrough — those subcommands launch without `--session`, matching the
  pre-change baseline exactly (`_hrd()` forwarded verbatim before this change
  too). The 28 direct invocations were never routed either. Per-emulator session
  routing is a property of the entry point (`hrd::start`), not of every herdr
  call the module makes; if subcommand routing is ever wanted, it must be added
  where those calls actually happen — not at a wrapper they do not use.
