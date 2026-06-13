# shellcheck shell=bash
# Notify plugin loader

[[ -n "${__ZSH_NOTIFY_LOADED:-}" ]] && return
typeset -r __ZSH_NOTIFY_LOADED=1

zmodload zsh/regex

# shellcheck disable=SC2277,SC2296,SC2298,SC2299
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
# shellcheck disable=SC2277,SC2296,SC2298,SC2299
0="${${(M)0:#/*}:-$PWD/$0}"

export ZSH_NOTIFY_PATH="${0:h}"
message_info "Loading module: notify"

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/config/main.zsh"
# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/internal/main.zsh"
# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/pkg/main.zsh"

# Notify if commands were running for more than TIME_THRESHOLD seconds
typeset -g _ZSH_NOTIFY_TIME_THRESHOLD=10
typeset -g _ZSH_NOTIFY_RE_SKIP_COMMANDS="^[^ ]*(ssh|vi|vim|nvim|tmux|tig|man|cat|more|less)"
typeset -g _ZSH_NOTIFY_TERMINAL_BUNDLE="com.googlecode.iterm2"

# Register hooks for automatic notifications
autoload -Uz add-zsh-hook
add-zsh-hook preexec notify::command::store
add-zsh-hook precmd notify::command::completed
