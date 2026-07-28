# shellcheck shell=bash

# Orchestrate & Run — agent coordination, factories, pipelines
ZSH_HERDR_INSTALL_PLUGINS+=(
  0x5c0f/herdr-insight
  rohanthewiz/herdr-todo
  carze/herdr-smolmachine
)

# Connect — socket API, MCP, notifications, bridges
ZSH_HERDR_INSTALL_PLUGINS+=(
  codybontecou/herdr-telemetry-bridge
  dcolinmorgan/herdr-push
  vaclavik-xyz/herdwatch
  carsonjones/herdr-agent-dashboard
)

# Editor integrations — Neovim, Vim, Obsidian
ZSH_HERDR_INSTALL_PLUGINS+=(
  paulbkim-dev/vim-herdr-navigation
  lmilojevicc/herdr-splits.nvim
)

# Sessions — switch, restore, pick, project layouts
ZSH_HERDR_INSTALL_PLUGINS+=(
  thanhdat77/herdr-picker-plus
  andrewchng/herdr-sessionizer
  alon-z/herdr-command-palette
  third774/herdr-last-workspace
)

# Navigation — agent focus, recent nav
ZSH_HERDR_INSTALL_PLUGINS+=(
  beyondlex/herdr-recent-navigator
)

# Worktrees & terminal UX — git, layouts, navigation, overlays
ZSH_HERDR_INSTALL_PLUGINS+=(
  qdentity/herdr-worktree-lifecycle
  razajamil/herdr-plugin-workspace-manager
  alon-z/herdr-devup
  persiyanov/herdr-reviewr
  rmarganti/herdr-pluck
  smarzban/herdr-file-viewer
  beomjungil/herdr-lazygit-overlay
  carsonjones/herdr-plugin-tiles
  kamaaina/herdr_sync
  wyattjoh/herdr-plugin-renamer
  alexjsp/herdr-scrollback-capture
)