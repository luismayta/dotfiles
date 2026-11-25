# shellcheck shell=bash
# Agent skills configuration variables

export ZSH_AI_SKILLS_BIN_PATH="${HOME}/.local/bin"
export ZSH_AI_SKILLS_CONFIG_PATH="${HOME}/.config/skills"
export ZSH_AI_SKILLS_DATA_PATH="${ZSH_AI_PATH}/data/skills"

# shellcheck disable=SC2034 # used dynamically via ${(P)} expansion in internal/skills.zsh
# Skills repos — one entry per repository
ZSH_AI_SKILLS_REPOS=(
  vercel-labs/agent-skills
  CodipLab/codip-ai
  tt-a1i/archify
  agavra/tuicr
)

# shellcheck disable=SC2034 # used dynamically via ${(P)} expansion in internal/skills.zsh
# Vercel Labs — platform & framework best practices
ZSH_AI_SKILLS_VERCEL=(
  vercel-optimize
  vercel-deploy-claimable
  react-best-practices
  react-native-guidelines
  react-view-transitions
  composition-patterns
  web-design-guidelines
  writing-guidelines
)

# shellcheck disable=SC2034 # used dynamically via ${(P)} expansion in internal/skills.zsh
# CodipLab — Git & PR workflows
ZSH_AI_SKILLS_CODIP=(
  agents-md-generator
  codi-find-skills
  diagram-design
  discord-config-manager
  discord-create-thread
  discord-send-to-thread
  gcal-daily-planner
  gcal-task-suggester
  gdrive-to-markdown
  github-create-pr
  github-update-pr
  github-validate-pr
  gitlab-create-mr
  gitlab-update-mr
  gitlab-validate-mr
  goji-commit-smart
  idea-capture
  idea-jpd-create
  idea-jpd-draft
  idea-jpd-import
  image-compression
  inbox-archive
  jira-add-worklog
  jira-approve-task
  jira-epic-generator
  jira-start-task
  jira-sync-components
  jira-sync-filters
  jira-task-generator
  jira-work-report
  jpd-epic-generator
  jpd-task-generator
  markdown-to-gcal
  markdown-to-gdoc
  markdown-to-gslides
  markdown-to-jira
  okf-classify
  osint-investigation
  research-capture
  research-classify
  simplify
  task-validate
  technical-document-auditor
)

# shellcheck disable=SC2034 # used dynamically via ${(P)} expansion in internal/skills.zsh
# Tuicr — TUI code review with AI agent integration
ZSH_AI_SKILLS_TUICR=(
  tuicr
)

export ZSH_AI_INSTALL_URL_SKILLS="https://raw.githubusercontent.com/vercel-labs/skills/main/install.sh"