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

# Shared: scaffold from a named template into $PWD
nix::scaffold::_from_template() {
  local template_name="$1"

  if [[ -z "${template_name}" ]]; then
    echo "error: usage: nix::scaffold::_from_template <name>" >&2
    return 1
  fi

  local target_dir="${PWD}"
  local flake_file="${target_dir}/flake.nix"
  local nix_dir="${target_dir}/nix"
  local template="${ZSH_NIX_PATH}/data/templates/${template_name}/flake.nix"

  if [[ ! -d "${target_dir}" ]]; then
    echo "error: current directory does not exist" >&2
    return 1
  fi

  if [[ ! -f "${template}" ]]; then
    echo "error: template '${template_name}' not found at ${template}" >&2
    return 1
  fi

  echo "Scaffolding ${template_name} Nix structure in ${target_dir}"

  # Create nix/ directory (idempotent)
  if [[ ! -d "${nix_dir}" ]]; then
    mkdir -p "${nix_dir}"
    echo "  created  ${nix_dir}/"
  else
    echo "  exists   ${nix_dir}/"
  fi

  # Copy flake.nix if absent (idempotent)
  if [[ ! -f "${flake_file}" ]]; then
    cp "${template}" "${flake_file}"
    echo "  created  ${flake_file}"
  else
    echo "  exists   ${flake_file}  (skipped)"
  fi

  echo "done."
}

# Per-language scaffold commands
nix::scaffold::go()         { nix::scaffold::_from_template go; }
nix::scaffold::python()     { nix::scaffold::_from_template python; }
nix::scaffold::typescript() { nix::scaffold::_from_template typescript; }
nix::scaffold::rust()       { nix::scaffold::_from_template rust; }
