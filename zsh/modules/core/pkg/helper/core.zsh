#
# shellcheck shell=bash
# FZF helpers, auto-install side-effects, and misc utilities
#

# Auto-install common tools
if ! core::exists axel; then core::install axel; fi
if ! core::exists rg; then core::install ripgrep; fi
if ! core::exists fzf; then core::install fzf; fi
if ! core::exists jq; then core::install jq; fi
if ! core::exists bat; then core::install bat; fi
if ! core::exists ghead; then core::install coreutils; fi
if ! core::exists ag; then core::install the_silver_searcher; fi

# cat → bat
cat() {
  bat "${@}"
}

# FZF_CTRL_T command
if core::exists fd; then
  export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
fi

# fkill — kill a process via fzf
fkill() {
  local pid
  pid="$(ps -ef | sed 1d | fzf -m | awk '{print $2}')"
  if [ -n "${pid}" ]; then
    echo "${pid}" | xargs kill "-${1:-9}"
  fi
}

# fa — cd into a directory via fzf
fa() {
  local dir
  dir="$(fd --type d --hidden --follow --exclude .git | fzf +m | awk -F: '{print $1}')" \
    && cd "${dir}" || return
}

# fah — cd into a directory (including hidden) via fzf
fah() {
  local dir
  dir="$(find "${1:-.}" -type d 2> /dev/null | fzf +m)" && cd "${dir}" || return
}

# fcs — select and copy a git commit hash via fzf
fcs() {
  local commits commit
  commits="$(git log --color=always --pretty=oneline --abbrev-commit --reverse)" && \
    commit="$(echo "${commits}" | fzf --tac +s +m -e --ansi)" && \
    echo -n "$(echo -n "${commit}" \
      | awk '{print $(1)}' \
      | perl -pe 'chomp' \
      | sed 's/\"//g' \
      | ghead -c -1 \
      | pbcopy)"
}

# fenv — select and copy an env var value via fzf
fenv() {
  local out
  out="$(env | fzf)"
  echo -n "$(echo -n "${out}" | cut -d= -f2 | ghead -c -1 | pbcopy)"
}

# falias — select and copy an alias value via fzf
falias() {
  local out
  out="$(alias | fzf)"
  echo -n "$(echo -n "${out}" | cut -d= -f2 | ghead -c -1 | pbcopy)"
}

# fo — open a file via fzf in $EDITOR
fo() {
  local file
  file="$(fd --type f --hidden --follow --exclude .git | fzf | awk -F: '{print $1}')"
  if [ -n "${file}" ]; then
    ${EDITOR} "${file}"
  fi
}

# fgb — checkout a git branch via fzf
fgb() {
  local branches branch
  branches="$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)')" && \
    branch="$(echo "${branches}" \
      | fzf-tmux -d $(( 2 + $(wc -l <<< "${branches}") )) +m)" && \
    git checkout "$(echo "${branch}" | sed 's/.* //' | sed 's#remotes/[^/]*/##')"
}

# ftm — create or switch tmux session via fzf
ftm() {
  local change="attach-session"
  [[ -n "${TMUX}" ]] && change="switch-client"
  if [ -n "${1}" ]; then
    tmux "${change}" -t "${1}" 2>/dev/null \
      || (tmux new-session -d -s "${1}" && tmux "${change}" -t "${1}")
    return
  fi
  local session
  session="$(tmux list-sessions -F '#{session_name}' 2>/dev/null | fzf --exit-0)" \
    && tmux "${change}" -t "${session}" \
    || echo "No sessions found."
}

# ftmk — kill a tmux session via fzf
ftmk() {
  if [ -n "${1}" ]; then
    tmux kill-session -t "${1}"
    return
  fi
  local session
  session="$(tmux list-sessions -F '#{session_name}' 2>/dev/null \
    | fzf --exit-0)" \
    && tmux kill-session -t "${session}" \
    || echo "No session found to delete."
}

# fgr — grep via rg and open in $EDITOR
fgr() {
  local file line
  read -r file line <<< "$(rg --no-heading --line-number "$@" | fzf -0 -1 | awk -F: '{print $1, $2}')"
  if [ -n "${file}" ]; then
    ${EDITOR} "+/${line}" "${file}"
  fi
}

# fag — grep via ag and open in $EDITOR
fag() {
  local file line
  read -r file line <<< "$(ag --no-heading --line-number "$@" | fzf -0 -1 | awk -F: '{print $1, $2}')"
  if [ -n "${file}" ]; then
    ${EDITOR} "+/${line}" "${file}"
  fi
}

# agr — replace text using ag + perl
agr() {
  # shellcheck disable=SC2016
  ag --hidden --ignore=.git -0 -l "${1}" \
    | AGR_FROM="${1}" AGR_TO="${2}" xargs -0 perl -pi -e 's/$ENV{AGR_FROM}/$ENV{AGR_TO}/g'
}

# pubkey — copy public key to clipboard
pubkey() {
  more "${HOME}"/.ssh/id_rsa.pub | perl -pe 'chomp' | pbcopy \
    && message_info 'Public key copied to pasteboard.'
}

# download — download with axel (20 chunks)
download() {
  if ! core::exists axel; then core::install axel; fi
  axel -n 20 -av "${1}"
}

# ip — show public IP
ip() {
  dig +short myip.opendns.com @resolver1.opendns.com
}

# localip — show local IP
localip() {
  ipconfig getifaddr en0
}

# net — check internet connectivity
net() {
  ping 8.8.8.8 | grep -E --only-match --color=never '[0-9\.]+ ms'
}
