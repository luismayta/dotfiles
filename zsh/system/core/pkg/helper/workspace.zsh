#
# shellcheck shell=bash
# Workspace name derivation — single shared source for herdr and tmux (design D1).
#
# core::workspace::derive_name [explicit-name] [prefix-map]
#   $1 - explicit name; when non-empty it becomes the base name and the
#        prefix map is NOT consulted (parent directories are irrelevant).
#   $2 - newline-separated `parent=prefix` pairs (e.g. $'codiplab=cl\nother=ot'),
#        consulted ONLY in the {parent}-{dir} branch and ONLY against the RAW
#        parent directory name, before slugification. Newline-delimited, not
#        space/comma, because parent directory names may contain spaces. An
#        entry with an empty prefix does not match.
#
# Reads only $1, $2, $PWD and $HOME: no global is read or mutated, no
# filesystem access, no side effects beyond the name (with trailing newline)
# on stdout; always exits 0. The map is an ARGUMENT, never a global — tmux
# passes "" and therefore gets the legacy {parent}-{dir} derivation for every
# input by construction, keeping tmux session names byte-identical (design D1,
# requirement #19).
#

function core::workspace::derive_name {
  local name
  local explicit="${1:-}"
  local prefix_map="${2:-}"

  if [[ -n "$explicit" ]]; then
    name="$explicit"
  else
    local current_dir="${PWD:t}"
    local parent_dir="${PWD:h:t}"

    if [[ "$PWD" == "$HOME" ]]; then
      name="core"
    elif [[ "${PWD:h}" == "$HOME" ]]; then
      name="core-${current_dir}"
    else
      # Third branch only: substitute the mapped prefix for the parent
      # component when the RAW parent directory name has a non-empty entry.
      # Newline-delimited here-string: parent directory names may contain
      # spaces, so word-splitting on IFS would corrupt the keys.
      local prefix=""
      local entry key value
      while IFS= read -r entry; do
        [[ "$entry" != *=* ]] && continue
        key="${entry%%=*}"
        value="${entry#*=}"
        if [[ "$key" == "$parent_dir" && -n "$value" ]]; then
          prefix="$value"
          break
        fi
      done <<< "$prefix_map"

      if [[ -n "$prefix" ]]; then
        name="${prefix}-${current_dir}"
      else
        name="${parent_dir}-${current_dir}"
      fi
    fi
  fi

  # Slug: replace non-alphanumeric chars with hyphen, collapse runs, strip
  # edges, lowercase — applied to the WHOLE assembled name so unmapped
  # parents stay byte-identical to the legacy derivation. The collapse loop
  # runs BEFORE the edge strip, so `---x---` yields `x`, not `--x--`.
  name="${name//[^a-zA-Z0-9]/-}"
  while [[ "$name" == *--* ]]; do name="${name//--/-}"; done
  name="${name#-}"
  name="${name%-}"
  name="${name:l}"

  printf '%s\n' "$name"
}
