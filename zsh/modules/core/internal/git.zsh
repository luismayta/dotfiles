#
# shellcheck shell=bash
# Git utilities
#

core::git::get_module_path() {
  local basename
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    basename="$(basename "$(pwd)")"
    core::internal::message::error "not git repository → ${basename}"
    return 0
  fi

  local remote_url
  remote_url="$(git config --get remote.origin.url)"

  echo "${remote_url}" | awk '
  {
    if ($0 ~ /^git@/) {
      sub(/^git@/, "", $0)
      split($0, a, ":")
      host = a[1]
      path = a[2]
    }
    else if ($0 ~ /^https?:\/\//) {
      sub(/^https?:\/\//, "", $0)
      split($0, a, "/")
      host = a[1]
      path = substr($0, length(host) + 2)
    }
    else {
      print "unknown/unknown/" ENVIRON["PWD"]
      exit
    }

    if (path ~ /\.git$/) {
      sub(/\.git$/, "", path)
    }

    print host "/" path
  }'
}
