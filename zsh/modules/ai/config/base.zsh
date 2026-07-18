# shellcheck shell=bash
ZSH_AI_ENABLED="${ZSH_AI_ENABLED:-true}"

ARCH_NAME="$(uname -m)"
export ARCH_NAME

export AI_PACKAGE_NAME=ai

# opencode
export AI_OPENCODE_ROOT_PATH="${HOME}/.opencode"
export AI_OPENCODE_BIN_PATH="${AI_OPENCODE_ROOT_PATH}/bin"
export AI_OPENCODE_CONFIG_PATH="${HOME}/.config/opencode"
export AI_OPENCODE_CONFIG_FILE="opencode.json"
export AI_OPENCODE_CONFIG_SOURCE_PATH="${AI_PATH}/data/opencode"
export AI_OPENCODE_RUNTIME_SOURCE_PATH="${AI_PATH}/.opencode"
export AI_OPENCODE_RUNTIME_CONFIG_PATH="${AI_OPENCODE_CONFIG_PATH}/.opencode"
export AI_OPENCODE_CONFIG_FILE_PATH="${AI_OPENCODE_CONFIG_PATH}/${AI_OPENCODE_CONFIG_FILE}"

# fabric
export AI_FABRIC_PATTERNS_PATH="${HOME}/.config/fabric/patterns"
export AI_FABRIC_PATTERNS_SYNC_SOURCE="${AI_PATH}/data/patterns"

# ollama
export AI_OLLAMA_MODELS_PATH="${HOME}/.ollama/models"

# shimmy
export AI_SHIMMY_BIN_PATH="${HOME}/.local/bin"

# openclaw
export AI_OPENCLAW_BIN_PATH="${HOME}/.local/bin"

# codegraph
export AI_CODEGRAPH_BIN_PATH="${HOME}/.local/bin"

# rtk
export AI_RTK_BIN_PATH="${HOME}/.local/bin"
export AI_RTK_CONFIG_PATH="${HOME}/.config/rtk"
export AI_RTK_CONFIG_SOURCE_PATH="${AI_PATH}/data/rtk"

# hunk
export AI_HUNK_BIN_PATH="${HOME}/.local/bin"
export AI_HUNK_CONFIG_PATH="${HOME}/.config/hunk"

# pi (AI coding agent)
export AI_PI_BIN_PATH="${HOME}/.local/bin"
export AI_PI_CONFIG_PATH="${HOME}/.pi/agent"
export AI_PI_CONFIG_SOURCE_PATH="${AI_PATH}/data/pi"

# graphify (knowledge graph for codebases)
export AI_GRAPHIFY_BIN_PATH="${HOME}/.local/bin"

# openspec (spec-driven development)

# skills (agent-skills ecosystem)
export AI_SKILLS_BIN_PATH="${HOME}/.local/bin"
export AI_SKILLS_CONFIG_PATH="${HOME}/.config/skills"
export AI_SKILLS_DATA_PATH="${AI_PATH}/data/skills"

export AI_SKILLS_DEFAULT=()

# Vercel Labs — platform & framework best practices
AI_SKILLS_DEFAULT+=(
  vercel-labs/agent-skills/skills/vercel-optimize
  vercel-labs/agent-skills/skills/vercel-deploy-claimable
  vercel-labs/agent-skills/skills/react-best-practices
  vercel-labs/agent-skills/skills/react-native-guidelines
  vercel-labs/agent-skills/skills/react-view-transitions
  vercel-labs/agent-skills/skills/composition-patterns
  vercel-labs/agent-skills/skills/web-design-guidelines
  vercel-labs/agent-skills/skills/writing-guidelines
)

# CodipLab — Git & PR workflows
AI_SKILLS_DEFAULT+=(
  CodipLab/codip-ai/skills/github-create-pr
  CodipLab/codip-ai/skills/github-update-pr
  CodipLab/codip-ai/skills/github-validate-pr
  CodipLab/codip-ai/skills/gitlab-create-mr
  CodipLab/codip-ai/skills/gitlab-update-mr
  CodipLab/codip-ai/skills/gitlab-validate-mr
  CodipLab/codip-ai/skills/goji-commit-smart
)

# CodipLab — Jira & project management
AI_SKILLS_DEFAULT+=(
  CodipLab/codip-ai/skills/jira-add-worklog
  CodipLab/codip-ai/skills/jira-epic-generator
  CodipLab/codip-ai/skills/jira-start-task
  CodipLab/codip-ai/skills/jira-task-generator
  CodipLab/codip-ai/skills/jira-work-report
  CodipLab/codip-ai/skills/jpd-epic-generator
  CodipLab/codip-ai/skills/jpd-task-generator
  CodipLab/codip-ai/skills/markdown-to-jira
)

# CodipLab — Calendar & productivity
AI_SKILLS_DEFAULT+=(
  CodipLab/codip-ai/skills/gcal-daily-planner
  CodipLab/codip-ai/skills/markdown-to-gcal
)

# CodipLab — Ideas & capture
AI_SKILLS_DEFAULT+=(
  CodipLab/codip-ai/skills/idea-capture
  CodipLab/codip-ai/skills/idea-jpd-create
  CodipLab/codip-ai/skills/idea-jpd-draft
  CodipLab/codip-ai/skills/idea-jpd-import
)

# CodipLab — Bootstrap & utilities
AI_SKILLS_DEFAULT+=(
  CodipLab/codip-ai/skills/image-compression
)

# installation urls
export AI_INSTALL_URL_OPENCODE="https://opencode.ai/install"
export AI_INSTALL_URL_FABRIC="https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh"
export AI_INSTALL_URL_OLLAMA="https://ollama.com/install.sh"
export AI_INSTALL_URL_SHIMMY="https://github.com/Michael-A-Kuykendall/shimmy/releases/latest/download"
export AI_INSTALL_URL_HF="https://hf.co/cli/install.sh"
export AI_INSTALL_URL_OPENCLAW="https://openclaw.ai/install.sh"
export AI_INSTALL_URL_CODEGRAPH="https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh"
export AI_INSTALL_URL_TMUXAI="https://get.tmuxai.dev"
export AI_INSTALL_URL_RTK="https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh"
export AI_INSTALL_URL_HUNK="npm i -g hunkdiff"
export AI_INSTALL_URL_PI="https://pi.dev/install.sh"
export AI_INSTALL_URL_SKILLS="https://raw.githubusercontent.com/vercel-labs/skills/main/install.sh"

export AI_TOOLS=(
  opencode
  fabric
  ollama
  shimmy
  hf
  openclaw
  codegraph
  tmuxai
  hunk
  rtk
  pi
  skills
)

export AI_OLLAMA_MODELS=(
  deepseek-coder:6.7b
  qwen2.5-coder:7b
  codellama:13
)