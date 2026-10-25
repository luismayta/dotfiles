#!/usr/bin/env bats
# Acceptance tests for bounded adapter dispatch — OpenSpec change
# fix-notify-terminal-freeze, tasks 4.1, 4.2, 4.3 (design D8).
#
# Contract: openspec/changes/fix-notify-terminal-freeze/specs/notify-prompt-safety/spec.md
#   - "Notification dispatch is hard-bounded": the noti and notify-send
#     invocations SHALL be wrapped in timeout with a SIGKILL backup, so a
#     hung provider cannot block the prompt.
#   - Task 4.3: the happy path is unchanged — the same -t/-m/--icon and
#     --urgency=low/-i arguments must reach the provider.
#
# Provider selection is exercised through plugin.zsh (the real load path:
# config/main -> internal/main -> pkg). Each snippet then calls
# notify::internal::popup (internal/linux.zsh), which dispatches through
# notify::adapter::send to the active adapter — the exact call path the
# precmd hook takes at prompt time.
#
# Stub: a fake `noti` / `notify-send` first on PATH records one invocation
# (argv via bash printf %q + pid) to NOTIFY_FAKE_ADAPTER_LOG, then runs the
# mode:
#   exit        instant exit 0 (happy path)
#   hang        sleep 30 — only the timeout bound can end it in time
#   ignore-term trap '' TERM, then loop — only SIGKILL (timeout -k) ends it
# The recording file doubles as the spawn marker: file absent => the
# provider was never invoked (vacuous-pass guard).

load "${BATS_TEST_DIRNAME}/test_helper.bash"

setup() {
  FIXTURE_HOME="$(make_notify_tmpdir)"
  ADAPTER_LOG="$FIXTURE_HOME/adapter.log"
}

teardown() {
  cleanup_fake_adapter
  cleanup_notify_tmpdir "$FIXTURE_HOME"
}

# ── PATH shim ────────────────────────────────────────────────────────────────

# Install a fake provider named $1 at the front of PATH (dir kept in
# NOTIFY_ADAPTER_DIR), recording each invocation to $2, scenario $3.
install_fake_adapter() {
  local name="$1" record="$2" mode="${3:-exit}"
  case "$mode" in
    exit | hang | ignore-term) ;;
    *)
      printf 'ERROR: install_fake_adapter: unknown mode %q (want: exit|hang|ignore-term)\n' "$mode" >&2
      return 2
      ;;
  esac
  NOTIFY_ADAPTER_DIR="$(mktemp -d)"
  cat >"${NOTIFY_ADAPTER_DIR}/${name}" <<'MOCK'
#!/usr/bin/env bash
# Fake provider installed by install_fake_adapter. Scenario via env vars:
#   NOTIFY_FAKE_ADAPTER_LOG   file to append the invocation record to
#   NOTIFY_FAKE_ADAPTER_MODE  exit | hang | ignore-term
{
  printf 'argv:'
  for a in "$@"; do printf ' %q' "$a"; done
  printf '\n'
  printf 'pid: %s\n' "$$"
} >>"${NOTIFY_FAKE_ADAPTER_LOG:?}"
case "${NOTIFY_FAKE_ADAPTER_MODE:-exit}" in
  hang)
    sleep 30
    ;;
  ignore-term)
    trap '' TERM
    while :; do sleep 1; done
    ;;
  *)
    exit 0
    ;;
esac
MOCK
  chmod +x "${NOTIFY_ADAPTER_DIR}/${name}"
  PATH="${NOTIFY_ADAPTER_DIR}:${PATH}"
  NOTIFY_FAKE_ADAPTER_LOG="$record"
  NOTIFY_FAKE_ADAPTER_MODE="$mode"
  export PATH NOTIFY_ADAPTER_DIR NOTIFY_FAKE_ADAPTER_LOG NOTIFY_FAKE_ADAPTER_MODE
}

# Remove the fake provider and kill leftovers of THIS stub only — a pid is
# only touched when its /proc entry still carries our shim dir in cmdline
# (never a recycled pid that happens to collide).
cleanup_fake_adapter() {
  [[ -n "${NOTIFY_ADAPTER_DIR:-}" && -d "$NOTIFY_ADAPTER_DIR" ]] || return 0
  if [[ -f "${NOTIFY_FAKE_ADAPTER_LOG:-}" ]]; then
    local pid child children
    pid="$(sed -n 's/^pid: //p' "$NOTIFY_FAKE_ADAPTER_LOG")"
    if [[ -n "$pid" && -d "/proc/$pid" ]] \
      && grep -aq -- "$NOTIFY_ADAPTER_DIR" "/proc/$pid/cmdline" 2>/dev/null; then
      children="$(pgrep -P "$pid" 2>/dev/null || true)"
      for child in $children; do
        kill -9 "$child" 2>/dev/null || true
      done
      kill -9 "$pid" 2>/dev/null || true
    fi
  fi
  PATH="${PATH#"${NOTIFY_ADAPTER_DIR}:"}"
  export PATH
  rm -rf "$NOTIFY_ADAPTER_DIR"
  unset NOTIFY_ADAPTER_DIR NOTIFY_FAKE_ADAPTER_LOG NOTIFY_FAKE_ADAPTER_MODE
}

# Rebuild the exact argv line the stub records (same bash printf %q).
notify_expected_argv_line() {
  local line="argv:" a q
  for a in "$@"; do
    printf -v q ' %q' "$a"
    line+="$q"
  done
  printf '%s\n' "$line"
}

# Exit 0 only when pid is still alive AND is still our stub (cmdline names
# the shim dir — a recycled pid must not read as "still hung").
notify_adapter_stub_alive() {
  local pid="$1"
  [[ -n "$pid" && -d "/proc/$pid" ]] || return 1
  grep -aq -- "$NOTIFY_ADAPTER_DIR" "/proc/$pid/cmdline" 2>/dev/null
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 4.3 — happy path: same arguments reach the provider
# ─────────────────────────────────────────────────────────────────────────────

# Spec: bounded dispatch must not alter the invocation itself. noti gets
# -t/-m/--icon (icon branch of internal/adapter/noti.zsh:99).
@test "4.3 happy path: noti receives -t/-m/--icon unchanged" {
  install_fake_adapter noti "$ADAPTER_LOG" exit
  local q_plugin snippet expected
  printf -v q_plugin '%q' "$NOTIFY_MODULE_DIR/plugin.zsh"
  snippet="source ${q_plugin} || exit 1
notify::internal::popup 'deploy' 'finished ok' 'success.jpg'"

  run run_notify_zsh "$FIXTURE_HOME" "$FIXTURE_HOME" "$snippet"
  [ "$status" -eq 0 ]

  expected="$(notify_expected_argv_line -t deploy -m "finished ok" --icon \
    "$NOTIFY_MODULE_DIR/data/notify/assets/success.jpg")"
  run grep -qxF -- "$expected" "$ADAPTER_LOG"
  [ "$status" -eq 0 ]
}

# Same contract for notify-send: --urgency=low/-i plus both message
# arguments, byte for byte.
@test "4.3 happy path: notify-send receives --urgency=low/-i unchanged" {
  export ZSH_NOTIFY_PROVIDER=notify-send
  install_fake_adapter notify-send "$ADAPTER_LOG" exit
  local q_plugin snippet expected
  printf -v q_plugin '%q' "$NOTIFY_MODULE_DIR/plugin.zsh"
  snippet="source ${q_plugin} || exit 1
notify::internal::popup 'deploy' 'finished ok' 'success.jpg'"

  run run_notify_zsh "$FIXTURE_HOME" "$FIXTURE_HOME" "$snippet"
  [ "$status" -eq 0 ]

  expected="$(notify_expected_argv_line --urgency=low \
    -i "$NOTIFY_MODULE_DIR/data/notify/assets/success.jpg" \
    "Long running command: deploy" "finished ok")"
  run grep -qxF -- "$expected" "$ADAPTER_LOG"
  [ "$status" -eq 0 ]
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 4.1 — hung noti dies within the bound, the caller waits no longer
# ─────────────────────────────────────────────────────────────────────────────

# Spec scenario: "Hung provider" — the adapter SHALL be terminated within
# the bound (timeout -k 2 5: SIGTERM at 5 s) and the calling shell SHALL
# not wait past it. Exit 124 is GNU timeout's documented "command timed
# out" status — proof the bound, not the provider, ended the call.
@test "4.1 hung noti stub killed within the 5 s + 2 s bound; caller waits <= 7 s" {
  install_fake_adapter noti "$ADAPTER_LOG" hang
  local q_plugin snippet t0 elapsed pid
  printf -v q_plugin '%q' "$NOTIFY_MODULE_DIR/plugin.zsh"
  snippet="source ${q_plugin} || exit 1
notify::internal::popup 'deploy' 'slow provider' ''"

  t0=$SECONDS
  run run_notify_zsh "$FIXTURE_HOME" "$FIXTURE_HOME" "$snippet"
  elapsed=$((SECONDS - t0))

  [ "$status" -eq 124 ]
  [ "$elapsed" -le 7 ]

  # the provider actually ran, then died: recording exists, pid gone
  [ -f "$ADAPTER_LOG" ]
  pid="$(sed -n 's/^pid: //p' "$ADAPTER_LOG")"
  [ -n "$pid" ]
  run notify_adapter_stub_alive "$pid"
  [ "$status" -ne 0 ]
}

# SIGKILL backup (the "-k 2" half of timeout -k 2 5): a provider that
# ignores SIGTERM dies anyway, within 5 s + 2 s grace. GNU coreutils then
# exits 137 (128 + SIGKILL — the kill-after SIGKILL takes the whole
# process group down, verified against coreutils 9.11 in this environment).
@test "4.1 SIGTERM-ignoring noti stub is SIGKILLed within the grace period" {
  install_fake_adapter noti "$ADAPTER_LOG" ignore-term
  local q_plugin snippet t0 elapsed pid
  printf -v q_plugin '%q' "$NOTIFY_MODULE_DIR/plugin.zsh"
  snippet="source ${q_plugin} || exit 1
notify::internal::popup 'deploy' 'stubborn provider' ''"

  t0=$SECONDS
  run run_notify_zsh "$FIXTURE_HOME" "$FIXTURE_HOME" "$snippet"
  elapsed=$((SECONDS - t0))

  [ "$status" -eq 137 ]
  [ "$elapsed" -le 7 ]

  [ -f "$ADAPTER_LOG" ]
  pid="$(sed -n 's/^pid: //p' "$ADAPTER_LOG")"
  [ -n "$pid" ]
  run notify_adapter_stub_alive "$pid"
  [ "$status" -ne 0 ]
}

# ─────────────────────────────────────────────────────────────────────────────
# Task 4.2 — hung notify-send dies within the bound
# ─────────────────────────────────────────────────────────────────────────────

# Same "Hung provider" scenario through the notify-send adapter (D-Bus
# stall case).
@test "4.2 hung notify-send stub killed within the 5 s + 2 s bound; caller waits <= 7 s" {
  export ZSH_NOTIFY_PROVIDER=notify-send
  install_fake_adapter notify-send "$ADAPTER_LOG" hang
  local q_plugin snippet t0 elapsed pid
  printf -v q_plugin '%q' "$NOTIFY_MODULE_DIR/plugin.zsh"
  snippet="source ${q_plugin} || exit 1
notify::internal::popup 'deploy' 'slow provider' 'success.jpg'"

  t0=$SECONDS
  run run_notify_zsh "$FIXTURE_HOME" "$FIXTURE_HOME" "$snippet"
  elapsed=$((SECONDS - t0))

  [ "$status" -eq 124 ]
  [ "$elapsed" -le 7 ]

  [ -f "$ADAPTER_LOG" ]
  pid="$(sed -n 's/^pid: //p' "$ADAPTER_LOG")"
  [ -n "$pid" ]
  run notify_adapter_stub_alive "$pid"
  [ "$status" -ne 0 ]
}
