# shellcheck shell=bash
# shellcheck disable=SC2296,SC2034
# Generic module runner — powers dotfiles::sync, dotfiles::setup, etc.
#
# Iterates over a named array of module names, checking each module's
# ZSH_<MODULE>_ENABLED flag, verifying the {module}::<suffix> function
# exists, executing it with timing and stderr capture, and producing
# a per-module progress report + final summary.
#
# Usage: _dotfiles::run_modules <array_name> <func_suffix> <action_label>

function _dotfiles::run_modules {
  local modules_var="$1"
  local suffix="$2"
  local action_label="$3"
  local -a modules
  modules=( "${(@P)modules_var}" )
  local total="${#modules[@]}" i=1
  local -A results
  local -a summary_items
  local module count_ok=0 count_err=0 count_skip=0
  local start_time elapsed err_file

  print -P "%F{blue}═══ dotfiles::${action_label} %f"

  for module in "${modules[@]}"; do
    local enabled_var="ZSH_${(U)module}_ENABLED"
    local enabled_value="${(P)enabled_var}"

    if [[ "${enabled_value}" == "false" ]] || [[ "${enabled_value}" == "0" ]]; then
      print -P "  → [${i}/${total}] ${module}... %F{yellow}-%f (disabled)"
      results[$module]="skip"
      summary_items+="%F{yellow}- ${module}%f"
      (( count_skip++, i++ ))
      continue
    fi

    local func="${module}::${suffix}"
    if ! type "${func}" >/dev/null 2>&1; then
      print -P "  → [${i}/${total}] ${module}... %F{yellow}-%f (not found)"
      results[$module]="skip"
      summary_items+="%F{yellow}- ${module}%f"
      (( count_skip++, i++ ))
      continue
    fi

    start_time=$SECONDS
    err_file=$(mktemp 2>/dev/null) || err_file="${TMPDIR:-/tmp}/dotfiles-${action_label}-${module}-$$"
    print -n "  → [${i}/${total}] ${module}... "

    if "${func}" >/dev/null 2>"${err_file}"; then
      elapsed=$(( SECONDS - start_time ))
      print -P "%F{green}✓%f (${elapsed}s)"
      results[$module]="ok"
      summary_items+="%F{green}✓ ${module}%f"
      (( count_ok++ ))
    else
      elapsed=$(( SECONDS - start_time ))
      print -P "%F{red}✗%f (${elapsed}s)"
      results[$module]="err"
      summary_items+="%F{red}✗ ${module}%f"
      (( count_err++ ))
      if [[ -s "${err_file}" ]]; then
        print -P "  %F{red}stderr:%f" >&2
        head -5 "${err_file}" | sed 's/^/  /' >&2
      fi
    fi
    [[ -f "${err_file}" ]] && rm -f "${err_file}"
    (( i++ ))
  done

  # ── Summary ──
  print -P ""
  print -P "%F{blue}════════════════════════════════%f"
  print -P "%F{blue}dotfiles::${action_label} complete%f"
  print -P "  ${summary_items[*]}"
  print -P "%F{blue}────────────────────────────────%f"
  print -P "  ${count_ok}/${total} done  |  ${count_err} errors  |  ${count_skip} skipped"
  print -P ""

  return $(( count_err > 0 ? 1 : 0 ))
}
