# shellcheck shell=bash
# Scaffold: Nix project structure
# Generates flake.nix + nix/ directory with minimal templates

nix::scaffold::init() {
  local project_dir="${1:-.}"

  # Resolve to absolute path
  project_dir="$(realpath -m "${project_dir}")"

  if [[ ! -d "${project_dir}" ]]; then
    echo "error: directory '${project_dir}' does not exist" >&2
    return 1
  fi

  local flake_file="${project_dir}/flake.nix"
  local nix_dir="${project_dir}/nix"

  echo "Scaffolding Nix structure in ${project_dir}"

  # Create nix/ directory
  if [[ ! -d "${nix_dir}" ]]; then
    mkdir -p "${nix_dir}"
    echo "  created  ${nix_dir}/"
  else
    echo "  exists   ${nix_dir}/"
  fi

  local template="${ZSH_NIX_PATH}/data/templates/flake.nix"

  # Create flake.nix if absent
  if [[ ! -f "${flake_file}" ]]; then
    cp "${template}" "${flake_file}"
    echo "  created  ${flake_file}"
  else
    echo "  exists   ${flake_file}  (skipped)"
  fi

  echo "done."
}
