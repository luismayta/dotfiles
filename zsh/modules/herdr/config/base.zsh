# shellcheck shell=bash
ZSH_HERDR_ENABLED="${ZSH_HERDR_ENABLED:-true}"

# Canonical names
export ZSH_HERDR_PACKAGE_NAME=herdr
export ZSH_HERDR_INSTALL_URL="https://herdr.dev/install.sh"
export ZSH_HERDR_CONFIG_DIR="${HOME}/.config/herdr"
export ZSH_HERDR_DATA_PATH="${ZSH_HERDR_PATH}/data"

# Workspace management
export ZSH_HERDR_WORKSPACE_PREFIX="${ZSH_HERDR_WORKSPACE_PREFIX:-}"

# Project template path
export ZSH_HERDR_PROJECT_TEMPLATE_PATH="${ZSH_HERDR_DATA_PATH}/plugins/config/cloudmanic.herdr-plus/projects"

# Plugin management
# Add plugins via ZSH_HERDR_INSTALL_PLUGINS+=("owner/repo") in your .zshrc
# shellcheck disable=SC2034 # used externally by internal/base.zsh
typeset -ga ZSH_HERDR_INSTALL_PLUGINS
export ZSH_HERDR_PLUGIN_ENABLED="${ZSH_HERDR_PLUGIN_ENABLED:-true}"

# Backward-compatible aliases (temporary — for existing shell sessions)
export HERDR_PACKAGE_NAME="${ZSH_HERDR_PACKAGE_NAME}"
export HERDR_INSTALL_URL="${ZSH_HERDR_INSTALL_URL}"
export HERDR_WORKSPACE_PREFIX="${ZSH_HERDR_WORKSPACE_PREFIX}"
export ZSH_HRD_PROJECT_TEMPLATE_PATH="${ZSH_HERDR_PROJECT_TEMPLATE_PATH}"
export ZSH_HRD_PLUGIN_ENABLED="${ZSH_HERDR_PLUGIN_ENABLED}"

# Orchestrate & Run — agent coordination, factories, pipelines
ZSH_HERDR_INSTALL_PLUGINS+=(
  razajamil/herdr-factory
  0x5c0f/herdr-insight
  rohanthewiz/herdr-todo
  tomoasleep/herdr-symphony
  machine-machine/herdr-factory-loop-skill
  machine-machine/ask-fable-skill
  bakescakes/claude-orchestration
  carze/herdr-smolmachine
  noor-latif/herd
)

# Connect — socket API, MCP, notifications, bridges
ZSH_HERDR_INSTALL_PLUGINS+=(
  54rt1n/herdr-python-client
  eugeneb50/herdr-mcp
  runchr-works/herdr-mesh
  ogulcancelik/herdr-plugin-examples
  gaijinjoe/herdres
  54rt1n/herdr-simple-mcp
  lib-x/herdr-sock-go
  codybontecou/herdr-telemetry-bridge
  dcolinmorgan/herdr-push
  vaclavik-xyz/herdwatch
  carsonjones/herdr-agent-dashboard
)

# Editor integrations — Neovim, Vim, Obsidian
ZSH_HERDR_INSTALL_PLUGINS+=(
  devxplay/herdr.nvim
  momepp/herd.nvim
  paulbkim-dev/vim-herdr-navigation
  lmilojevicc/herdr-splits.nvim
  luiarthur/herdr.vim
  daniel-steinberger/obsidian-herdr
)

# Sessions — switch, restore, pick, project layouts
ZSH_HERDR_INSTALL_PLUGINS+=(
  ridho9/switchr
  j0urneyk/herdrctx
  nickmaglowsch/herdr-session-restore
  thanhdat77/herdr-picker-plus
  andrewchng/herdr-sessionizer
  alon-z/herdr-command-palette
  third774/herdr-last-workspace
)

# Worktrees & terminal UX — git, layouts, navigation, overlays
ZSH_HERDR_INSTALL_PLUGINS+=(
  noamsiegel/git-wt-herdr
  sirtenzin/superherd
  justcyl/pi-herdr-tab-sync
  taeyoung96/herdr-dotfiles
  mattarau/wt-herdr
  qdentity/herdr-worktree-lifecycle
  razajamil/herdr-plugin-workspace-manager
  alon-z/herdr-devup
  persiyanov/herdr-reviewr
  x0d7x/herdr-fzf-url
  rmarganti/herdr-pluck
  smarzban/herdr-file-viewer
  beomjungil/herdr-lazygit-overlay
  carsonjones/herdr-plugin-tiles
  kamaaina/herdr_sync
  wyattjoh/herdr-plugin-renamer
  alexjsp/herdr-scrollback-capture
)

# Desktop & packaging — menu bar, web UI, remote
ZSH_HERDR_INSTALL_PLUGINS+=(
  hmu332233/herdr-menu-bar
  alecuba16/herdr-webui
  dcolinmorgan/herdr-remote
  kcosr/herdr-web
  lachieh/vfox-herdr
  re2zero/deepin-herdr
  aodhanhayter/herdr-nix
  timvdhoorn/stream-deck-herdr-plugin
)