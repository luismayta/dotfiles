# shellcheck shell=bash

# ──────────────────────────────────────────────
# Plugin management (interactive)
# ──────────────────────────────────────────────

# hrd::plugin — interactive plugin management via fzf.
# Follows the same pattern as hrd (workspace switch) and hrdk (workspace kill).
# Without arguments: presents an fzf selector with actions.
# With argument "install|list|update|uninstall": executes that action directly.
function hrd::plugin {
  local action="${1:-}"

  # Ensure fzf is available for interactive mode
  if [[ -z "$action" ]]; then
    if ! core::exists fzf; then
      message_error "fzf is required for interactive mode."
      return 1
    fi

    action="$(
      printf '%s\n' "install" "list" "update" "uninstall" \
        | hrd::internal::fzf_select "Plugin action: "
    )" || return 1
  fi

  case "$action" in
    install)
      hrd::internal::plugin::install::all
      ;;
    list)
      hrd::internal::plugin::list
      ;;
    update)
      hrd::internal::plugin::update::all
      ;;
    uninstall)
      local installed
      installed="$(herdr plugin list 2>/dev/null)" || {
        message_error "Failed to list installed plugins."
        return 1
      }

      if [[ -z "$installed" ]]; then
        message_info "No plugins installed."
        return 0
      fi

      local selection
      selection="$(
        printf '%s\n' "$installed" \
          | hrd::internal::fzf_select "Select plugin to uninstall: "
      )"

      if [[ -n "$selection" ]]; then
        hrd::internal::plugin::uninstall "$selection"
      fi
      ;;
    *)
      message_error "Unknown action: $action. Use install, list, update, or uninstall."
      return 1
      ;;
  esac
}
