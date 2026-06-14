#
# shellcheck shell=bash
# FZF git helpers — commit hash selector and branch switcher
#

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

# fgb — checkout a git branch via fzf
fgb() {
  local branches branch
  branches="$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)')" && \
    branch="$(echo "${branches}" \
      | fzf-tmux -d $(( 2 + $(wc -l <<< "${branches}") )) +m)" && \
    git checkout "$(echo "${branch}" | sed 's/.* //' | sed 's#remotes/[^/]*/##')"
}
