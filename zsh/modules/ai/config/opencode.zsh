# shellcheck shell=bash
# OpenCode configuration variables

export ZSH_AI_OPENCODE_ROOT_PATH="${HOME}/.opencode"
export ZSH_AI_OPENCODE_BIN_PATH="${ZSH_AI_OPENCODE_ROOT_PATH}/bin"
export ZSH_AI_OPENCODE_CONFIG_PATH="${HOME}/.config/opencode"
export ZSH_AI_OPENCODE_CONFIG_FILE="opencode.jsonc"
export ZSH_AI_OPENCODE_CONFIG_SOURCE_PATH="${ZSH_AI_PATH}/data/opencode"
export ZSH_AI_OPENCODE_RUNTIME_SOURCE_PATH="${ZSH_AI_PATH}/.opencode"
export ZSH_AI_OPENCODE_RUNTIME_CONFIG_PATH="${ZSH_AI_OPENCODE_CONFIG_PATH}/.opencode"
export ZSH_AI_OPENCODE_CONFIG_FILE_PATH="${ZSH_AI_OPENCODE_CONFIG_PATH}/${ZSH_AI_OPENCODE_CONFIG_FILE}"
export ZSH_AI_INSTALL_URL_OPENCODE="https://opencode.ai/install"

# === Central MCP configuration ===
# Aligned with ~/.config/opencode/opencode.jsonc (mcp.servers). Consumed by
# internal/opencode.zsh (validation/reinstall) and pkg/opencode.zsh (public API).

export ZSH_AI_OPENCODE_MCP_TIMEOUT=5

typeset -ga ZSH_AI_OPENCODE_MCP_NAMES
# shellcheck disable=SC2034 # used dynamically via ${(P)} expansion in internal/opencode.zsh
ZSH_AI_OPENCODE_MCP_NAMES=(
  aws-mcp
  rea
  postgres
  git
  playwright
  google_workspace
  awslabs.aws-knowledge
  chrome-devtools
  memglobal
  markitdown
  context7
  docker
  filesystem
  github
  grep
  hashicorp_terraform
  image-compression
  jira
  notebooklm
  obsidian
  scrapling
  sentry
  sequential-thinking
  serena
  supabase
  codegraph
  crawl4ai
  scopus
)

typeset -gA ZSH_AI_OPENCODE_MCP_TYPE
ZSH_AI_OPENCODE_MCP_TYPE["aws-mcp"]=local
ZSH_AI_OPENCODE_MCP_TYPE["rea"]=local
ZSH_AI_OPENCODE_MCP_TYPE["postgres"]=local
ZSH_AI_OPENCODE_MCP_TYPE["git"]=local
ZSH_AI_OPENCODE_MCP_TYPE["playwright"]=local
ZSH_AI_OPENCODE_MCP_TYPE["google_workspace"]=local
ZSH_AI_OPENCODE_MCP_TYPE["awslabs.aws-knowledge"]=remote
ZSH_AI_OPENCODE_MCP_TYPE["chrome-devtools"]=local
ZSH_AI_OPENCODE_MCP_TYPE["memglobal"]=local
ZSH_AI_OPENCODE_MCP_TYPE["markitdown"]=local
ZSH_AI_OPENCODE_MCP_TYPE["context7"]=local
ZSH_AI_OPENCODE_MCP_TYPE["docker"]=local
ZSH_AI_OPENCODE_MCP_TYPE["filesystem"]=local
ZSH_AI_OPENCODE_MCP_TYPE["github"]=local
ZSH_AI_OPENCODE_MCP_TYPE["grep"]=remote
ZSH_AI_OPENCODE_MCP_TYPE["hashicorp_terraform"]=local
ZSH_AI_OPENCODE_MCP_TYPE["image-compression"]=local
ZSH_AI_OPENCODE_MCP_TYPE["jira"]=remote
ZSH_AI_OPENCODE_MCP_TYPE["notebooklm"]=local
ZSH_AI_OPENCODE_MCP_TYPE["obsidian"]=remote
ZSH_AI_OPENCODE_MCP_TYPE["scrapling"]=local
ZSH_AI_OPENCODE_MCP_TYPE["sentry"]=local
ZSH_AI_OPENCODE_MCP_TYPE["sequential-thinking"]=local
ZSH_AI_OPENCODE_MCP_TYPE["serena"]=local
ZSH_AI_OPENCODE_MCP_TYPE["supabase"]=local
ZSH_AI_OPENCODE_MCP_TYPE["codegraph"]=local
ZSH_AI_OPENCODE_MCP_TYPE["crawl4ai"]=remote
ZSH_AI_OPENCODE_MCP_TYPE["scopus"]=local
# shellcheck disable=SC2034 # used dynamically via ${(P)} expansion in internal/opencode.zsh


typeset -gA ZSH_AI_OPENCODE_MCP_COMMAND
ZSH_AI_OPENCODE_MCP_COMMAND["aws-mcp"]="uvx mcp-proxy-for-aws@latest https://aws-mcp.us-east-1.api.aws/mcp --metadata INSTALL_SOURCE=aws-cli"
ZSH_AI_OPENCODE_MCP_COMMAND["rea"]="bunx rea-agents@6.7.0 mcp"
ZSH_AI_OPENCODE_MCP_COMMAND["postgres"]="bunx @microsoft/postgres-mcp run"
ZSH_AI_OPENCODE_MCP_COMMAND["git"]="bunx @cyanheads/git-mcp-server@latest"
ZSH_AI_OPENCODE_MCP_COMMAND["playwright"]="bunx -y @playwright/mcp"
ZSH_AI_OPENCODE_MCP_COMMAND["google_workspace"]="/home/lucho/.local/bin/workspace-mcp --single-user --tools drive gmail calendar chat contacts search sheets docs tasks"
ZSH_AI_OPENCODE_MCP_COMMAND["chrome-devtools"]="npx -y chrome-devtools-mcp@latest --no-usage-statistics --headless true"
ZSH_AI_OPENCODE_MCP_COMMAND["memglobal"]="npx -y @modelcontextprotocol/server-memory --file-path /home/lucho/.config/opencode/memory.json"
ZSH_AI_OPENCODE_MCP_COMMAND["markitdown"]="uvx markitdown-mcp"
ZSH_AI_OPENCODE_MCP_COMMAND["context7"]="npx -y @upstash/context7-mcp --api-key {env:CONTEXT7_API_KEY}"
ZSH_AI_OPENCODE_MCP_COMMAND["docker"]="bunx -y docker-mcp"
ZSH_AI_OPENCODE_MCP_COMMAND["filesystem"]="bunx -y @modelcontextprotocol/server-filesystem"
ZSH_AI_OPENCODE_MCP_COMMAND["github"]="bunx -y @modelcontextprotocol/server-github"
ZSH_AI_OPENCODE_MCP_COMMAND["hashicorp_terraform"]="docker run -i --rm hashicorp/terraform-mcp-server:latest"
ZSH_AI_OPENCODE_MCP_COMMAND["image-compression"]="bunx -y @inhiblab-core/mcp-image-compression"
ZSH_AI_OPENCODE_MCP_COMMAND["notebooklm"]="npx -y notebooklm-mcp@latest"
ZSH_AI_OPENCODE_MCP_COMMAND["scrapling"]="uvx --from scrapling[ai] scrapling-mcp"
ZSH_AI_OPENCODE_MCP_COMMAND["sentry"]="uvx mcp-server-sentry"
ZSH_AI_OPENCODE_MCP_COMMAND["sequential-thinking"]="bunx -y @modelcontextprotocol/server-sequential-thinking"
ZSH_AI_OPENCODE_MCP_COMMAND["serena"]="uvx --from git+https://github.com/oraios/serena serena start-mcp-server"
ZSH_AI_OPENCODE_MCP_COMMAND["supabase"]="bunx -y supabase-mcp@latest supabase-mcp-claude"
ZSH_AI_OPENCODE_MCP_COMMAND["codegraph"]="codegraph serve --mcp"
ZSH_AI_OPENCODE_MCP_COMMAND["scopus"]="/home/lucho/.local/share/scopus-mcp/.venv/bin/scopus-mcp"
ZSH_AI_OPENCODE_MCP_COMMAND["awslabs.aws-knowledge"]=""
ZSH_AI_OPENCODE_MCP_COMMAND["grep"]=""
ZSH_AI_OPENCODE_MCP_COMMAND["jira"]=""
ZSH_AI_OPENCODE_MCP_COMMAND["obsidian"]=""
ZSH_AI_OPENCODE_MCP_COMMAND["crawl4ai"]=""
# shellcheck disable=SC2034 # used dynamically via ${(P)} expansion in internal/opencode.zsh


typeset -gA ZSH_AI_OPENCODE_MCP_ENV
ZSH_AI_OPENCODE_MCP_ENV["aws-mcp"]=""
ZSH_AI_OPENCODE_MCP_ENV["rea"]=""
ZSH_AI_OPENCODE_MCP_ENV["postgres"]=""
ZSH_AI_OPENCODE_MCP_ENV["git"]="MCP_TRANSPORT_TYPE=stdio MCP_LOG_LEVEL=warn MCP_RESPONSE_FORMAT=json MCP_RESPONSE_VERBOSITY=minimal"
ZSH_AI_OPENCODE_MCP_ENV["playwright"]=""
ZSH_AI_OPENCODE_MCP_ENV["google_workspace"]="GOOGLE_OAUTH_CLIENT_ID={env:GOOGLE_OAUTH_CLIENT_ID} GOOGLE_OAUTH_CLIENT_SECRET={env:GOOGLE_OAUTH_CLIENT_SECRET}"
ZSH_AI_OPENCODE_MCP_ENV["awslabs.aws-knowledge"]=""
ZSH_AI_OPENCODE_MCP_ENV["chrome-devtools"]=""
ZSH_AI_OPENCODE_MCP_ENV["memglobal"]=""
ZSH_AI_OPENCODE_MCP_ENV["markitdown"]=""
ZSH_AI_OPENCODE_MCP_ENV["context7"]=""
ZSH_AI_OPENCODE_MCP_ENV["docker"]="DOCKER_MCP_LOCAL=true DOCKER_MCP_HOST={env:DOCKER_MCP_HOST} DOCKER_MCP_USERNAME={env:DOCKER_MCP_USERNAME} DOCKER_MCP_PRIVATE_KEY={env:DOCKER_MCP_PRIVATE_KEY} DOCKER_MCP_PORT={env:DOCKER_MCP_PORT} DOCKER_MCP_PASSPHRASE={env:DOCKER_MCP_PASSPHRASE}"
ZSH_AI_OPENCODE_MCP_ENV["filesystem"]="ROOT=."
ZSH_AI_OPENCODE_MCP_ENV["github"]="GITHUB_PERSONAL_ACCESS_TOKEN={env:GH_TOKEN}"
ZSH_AI_OPENCODE_MCP_ENV["grep"]=""
ZSH_AI_OPENCODE_MCP_ENV["hashicorp_terraform"]=""
ZSH_AI_OPENCODE_MCP_ENV["image-compression"]="IMAGE_COMPRESSION_DOWNLOAD_DIR=assets/images"
ZSH_AI_OPENCODE_MCP_ENV["jira"]=""
ZSH_AI_OPENCODE_MCP_ENV["notebooklm"]=""
ZSH_AI_OPENCODE_MCP_ENV["obsidian"]=""
ZSH_AI_OPENCODE_MCP_ENV["scrapling"]=""
ZSH_AI_OPENCODE_MCP_ENV["sentry"]="SENTRY_AUTH_TOKEN={env:SENTRY_AUTH_TOKEN}"
ZSH_AI_OPENCODE_MCP_ENV["sequential-thinking"]=""
ZSH_AI_OPENCODE_MCP_ENV["serena"]=""
ZSH_AI_OPENCODE_MCP_ENV["supabase"]="SUPABASE_URL={env:SUPABASE_URL} SUPABASE_ANON_KEY={env:SUPABASE_ANON_KEY} SUPABASE_SERVICE_ROLE_KEY={env:SUPABASE_SERVICE_ROLE_KEY} MCP_API_KEY={env:SUPABASE_MCP_API_KEY}"
ZSH_AI_OPENCODE_MCP_ENV["codegraph"]=""
ZSH_AI_OPENCODE_MCP_ENV["crawl4ai"]=""
ZSH_AI_OPENCODE_MCP_ENV["scopus"]="SCOPUS_API_KEY={env:SCOPUS_API_KEY}"
# shellcheck disable=SC2034 # used dynamically via ${(P)} expansion in internal/opencode.zsh


typeset -gA ZSH_AI_OPENCODE_MCP_URL
ZSH_AI_OPENCODE_MCP_URL["awslabs.aws-knowledge"]="https://knowledge-mcp.global.api.aws"
ZSH_AI_OPENCODE_MCP_URL["grep"]="https://mcp.grep.app"
ZSH_AI_OPENCODE_MCP_URL["jira"]="https://mcp.atlassian.com/v1/mcp/authv2"
ZSH_AI_OPENCODE_MCP_URL["obsidian"]="http://127.0.0.1:27123/mcp"
ZSH_AI_OPENCODE_MCP_URL["crawl4ai"]="http://localhost:11235/mcp/sse"
# shellcheck disable=SC2034 # used dynamically via ${(P)} expansion in internal/opencode.zsh

typeset -gA ZSH_AI_OPENCODE_MCP_DISABLED
ZSH_AI_OPENCODE_MCP_DISABLED["aws-mcp"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["rea"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["postgres"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["git"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["playwright"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["google_workspace"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["awslabs.aws-knowledge"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["chrome-devtools"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["memglobal"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["markitdown"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["context7"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["docker"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["filesystem"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["github"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["grep"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["hashicorp_terraform"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["image-compression"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["jira"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["notebooklm"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["obsidian"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["scrapling"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["sentry"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["sequential-thinking"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["serena"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["supabase"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["codegraph"]=false
ZSH_AI_OPENCODE_MCP_DISABLED["crawl4ai"]=true
ZSH_AI_OPENCODE_MCP_DISABLED["scopus"]=true
# shellcheck disable=SC2034 # used dynamically via ${(P)} expansion in internal/opencode.zsh

