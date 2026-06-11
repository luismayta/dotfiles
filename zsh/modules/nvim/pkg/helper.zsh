# shellcheck shell=bash
#
# Helper functions for nvim.

# Open neovim settings file with the default editor
function editnvim {
  if [[ -z "${EDITOR:-}" ]]; then
    echo "ERROR: EDITOR is not set" >&2
    return 1
  fi

  if [[ -z "${NVIM_FILE_SETTINGS:-}" ]]; then
    echo "WARNING: NVIM_FILE_SETTINGS is not set. Opening neovim config directory..." >&2
    "${EDITOR}" "${NVIM_CONFIG_PATH}"
    return 0
  fi

  "${EDITOR}" "${NVIM_FILE_SETTINGS}"
}
